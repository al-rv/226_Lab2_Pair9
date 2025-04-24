
# Automated Stock Price Forecasting and Visualization with Snowflake, Apache Airflow, yfinance, and Superset

This project perfoms ETL and ELT for 3 stocks BAC, JPM and WFC using `yfinance`, Snowflake, Apache Airflow, and dbt. The goal is to automate financial data workflows and prepare insights for visualization.

- ## 🔄 Overview
This project follows a modular containerized setup for managing the ETL process and data visualization separately:

1. **Airflow Container (ETL/ELT Execution)**  
   - Navigate to the `airflow/` folder.  
   - This container runs the ETL and ELT DAGs using Apache Airflow.
   - It runs the extraction from yfinance, transformation and loading in Snowflake. It also runs dbt as an airflow DAG.

2. **Superset Container (Data Visualization)**  
   - In a **separate terminal window**, navigate to the `superset/` folder.  
   - This container runs Apache Superset and connects to the Snowflake instance.
   - Superset pulls the transformed data from Snowflake and presents it through interactive dashboards.

- ## ⚙️ Tools Used

- Python + `yfinance`
- Apache Airflow (ETL orchestration)
- Snowflake (Data warehouse)
- dbt (Data modeling)
- Docker Compose (Local environment setup)
