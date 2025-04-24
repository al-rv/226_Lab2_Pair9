from airflow import DAG
from airflow.decorators import task
from datetime import timedelta, datetime
import snowflake.connector
from airflow.models import Variable
import yfinance

def return_snowflake_conn():
    snowflake_account = Variable.get("snowflake_account")
    snowflake_user = Variable.get("snowflake_userid")
    snowflake_password = Variable.get("snowflake_password")

    conn = snowflake.connector.connect(
        account=snowflake_account,
        user=snowflake_user,
        password=snowflake_password
    )
    
    return conn.cursor()


# Task to extract using yfinance
@task
def extract(symbols):
    all_data = {}

    for symbol in symbols:
        # Fetch historical data for the last 180 days
        ticker = yfinance.Ticker(symbol)
        data = ticker.history(period="180d")
        # Store relevant data for each symbol
        all_data[symbol] = data

    return all_data

# Task to transform
@task
def transform(all_data):
    records = []
    
    # Iterate over each symbol and its associated DataFrame
    for symbol, data in all_data.items():
        # Iterate over rows in the DataFrame
        for date, row in data.iterrows():
            # Extract required fields from each row
            open_price = row["Open"]
            high_price = row["High"]
            low_price = row["Low"]
            close_price = row["Close"]
            volume = row["Volume"]
            
            # Append as a record, converting 'date' to datetime
            records.append([
                symbol,
                date.to_pydatetime(),  # Convert to Python datetime
                open_price,
                high_price,
                low_price,
                close_price,
                volume
            ])

    return records


# Task to load data into Snowflake
@task
def load(records, target_table):
    con = return_snowflake_conn()

    try:
        con.execute("BEGIN;")
        con.execute(f"""CREATE TABLE IF NOT EXISTS {target_table} (
            symbol string,
            date timestamp,
            open number(38, 4),
            high number(38, 4),
            low number(38, 4),
            close number(38, 4),
            volume number(38, 0),
            PRIMARY KEY (symbol, date)
          )""")

        con.execute(f"""DELETE FROM {target_table}""")

        for r in records:
            symbol = r[0]
            date = r[1]
            open_price = r[2]
            high = r[3]
            low = r[4]
            close = r[5]
            volume = r[6]

            sql = f'''
                    INSERT INTO {target_table} (symbol, date, open, high, low, close, volume)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                  '''
            con.execute(sql, (symbol, date, open_price, high, low, close, volume))
        con.execute("COMMIT;")
    except Exception as e:
        con.execute("ROLLBACK;")
        print(e)
        raise e

default_args = {
    'owner': 'airflow',
    'retries': 1,
    'retry_delay': timedelta(minutes=3),
}

with DAG(
    dag_id='226_lab1_etl',
    default_args=default_args,
    start_date=datetime(2024, 9, 25),
    catchup=False,
    tags=['ETL'],
    schedule_interval='@daily'  # Runs daily
) as dag:
    symbols = ['JPM', 'BAC', 'WFC']  # List of symbols
    target_table = "user_db_bluejay.raw.stock"

    data = extract(symbols)
    lines = transform(data)
    load_task = load(lines, target_table)

    # Set task dependencies (sequentially)
    data >> lines >> load_task
