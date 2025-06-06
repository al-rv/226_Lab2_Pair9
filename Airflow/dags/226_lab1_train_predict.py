from airflow import DAG
from airflow.decorators import task
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook
from airflow.utils.dates import days_ago

# Defining default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

# Initializing the ML Forecasting stock price prediction DAG
forecast_dag = DAG(
    'stock_price_prediction',
    default_args=default_args,
    description='Stock Prediction for next 7 days prices for JPM and BAC stock prices',
    schedule_interval='@daily',  # Runs daily
    start_date=days_ago(1),
    catchup=False,
)

# Task 1: ML forecasting task to train the model
@task
def train(train_input_table, train_view, forecast_function_name):
    hook = SnowflakeHook(snowflake_conn_id='snowflake_conn')
    conn = hook.get_conn()
    cur = conn.cursor()

    create_view_sql = f"""
    CREATE OR REPLACE VIEW {train_view} AS 
    SELECT
        CAST(DATE AS TIMESTAMP_NTZ) AS DATE, CLOSE, SYMBOL
    FROM {train_input_table};
    """

    create_model_sql = f"""
    CREATE OR REPLACE SNOWFLAKE.ML.FORECAST {forecast_function_name} (
        INPUT_DATA => SYSTEM$REFERENCE('VIEW', '{train_view}'),
        SERIES_COLNAME => 'SYMBOL',
        TIMESTAMP_COLNAME => 'DATE',
        TARGET_COLNAME => 'CLOSE',
        CONFIG_OBJECT => {{ 'ON_ERROR': 'SKIP' }}
    );
    """

    try:
        cur.execute(create_view_sql)
        cur.execute(create_model_sql)
        cur.execute(f"CALL {forecast_function_name}!SHOW_EVALUATION_METRICS();")
    except Exception as e:
        print(e)
        raise
    finally:
        cur.close()
        conn.close()


# Task 2: Generating predictions from the model
@task
def predict(forecast_function_name, train_input_table, forecast_table, final_table):
    hook = SnowflakeHook(snowflake_conn_id='snowflake_conn')
    conn = hook.get_conn()
    cur = conn.cursor()

    make_prediction_sql = f"""
    BEGIN
        CALL {forecast_function_name}!FORECAST(
            FORECASTING_PERIODS => 7,
            CONFIG_OBJECT => {{'prediction_interval': 0.95}}
        );
        LET x := SQLID;
        CREATE OR REPLACE TABLE {forecast_table} AS SELECT * FROM TABLE(RESULT_SCAN(:x));
    END;
    """

    create_final_table_sql = f"""
    CREATE TABLE IF NOT EXISTS {final_table} AS
    SELECT SYMBOL, DATE, CLOSE AS actual, NULL AS forecast, NULL AS lower_bound, NULL AS upper_bound
    FROM {train_input_table}
    UNION ALL
    SELECT REPLACE(series, '"', '') AS SYMBOL, ts AS DATE, NULL AS actual, forecast, lower_bound, upper_bound
    FROM {forecast_table};
    """

    try:
        cur.execute(make_prediction_sql)
        cur.execute(create_final_table_sql)
    except Exception as e:
        print(e)
        raise
    finally:
        cur.close()
        conn.close()

# Defining the task dependencies using the decorator functions
with forecast_dag:
    train_input_table = "user_db_bluejay.raw.stock"
    train_view = "user_db_bluejay.raw.stock_view"
    forecast_table = "user_db_bluejay.raw.stock_forecast"
    forecast_function_name = "user_db_bluejay.raw.predict_stock_price"
    final_table = "user_db_bluejay.raw.final_data"

    # Defining the tasks
    train_task = train(train_input_table, train_view, forecast_function_name)
    predict_task = predict(forecast_function_name, train_input_table, forecast_table, final_table)

    # Setting the dependency
    train_task >> predict_task
