import os
import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError

from dotenv import load_dotenv
load_dotenv()

DB_USER = os.getenv('POSTGRES_USER')
DB_PASSWORD = os.getenv('POSTGRES_PASSWORD')
DB_HOST = os.getenv('POSTGRES_HOST', 'localhost')
DB_PORT = os.getenv('POSTGRES_PORT', '5432')
DB_NAME = os.getenv('POSTGRES_DB')

FILES = [
    ("countries.csv", "bronze_countries"),
    ("cities.csv", "bronze_cities"),
    ("categories.csv", "bronze_categories"),
    ("products.csv", "bronze_products"),
    ("shops.csv", "bronze_shops"),
    ("employees.csv", "bronze_employees"),
    ("customers.csv", "bronze_customers"),
    ("sales.csv", "bronze_sales"),
]

def get_engine(db_user, db_password, db_host, db_port, db_name):
    """Создаёт подключение к базе данных PostgreSQL."""
    db_url = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
    try:
        engine = create_engine(db_url, echo=False)
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        print("Подключение к базе данных успешно установлено.")
        return engine
    except SQLAlchemyError as e:
        print(f"Ошибка подключения к базе данных: {e}")
        raise


def load_csv_to_table(engine, file_name, table_name, schema='bronze'):
    """Загружает данные из CSV-файла в таблицу базы данных."""
    try:
        print(f"Чтение файла {file_name}...")
        df = pd.read_csv(file_name, sep=';')
        row_count = len(df)
        print(f"Загружено строк: {row_count}")
        
        df.to_sql(
            name=table_name,
            con=engine,
            schema=schema,
            if_exists='append',
            index=False,
            chunksize=10000,
        )
        print(f"Таблица {schema}.{table_name} успешно загружена ({row_count} записей).")
        return row_count
    except FileNotFoundError as e:
        print(f"Ошибка: Файл {file_name} не найден.")
        raise
    except Exception as e:
        print(f"Ошибка при загрузке {file_name}: {e}")
        raise
    

def create_schema_if_not_exists(engine, schema='bronze'):
    """Создаёт схему, если она не существует."""
    with engine.connect() as conn:
        conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {schema}"))
        conn.commit()
    print(f"Схема {schema} создана (или уже существует).")
        

def run_etl():
    """Основная функция ETL-пайплайна."""
    try:
        engine = get_engine(DB_USER, DB_PASSWORD, DB_HOST, DB_PORT, DB_NAME)
        create_schema_if_not_exists(engine)
        
        print("\nНАЧАЛО ЗАГРУЗКИ ДАННЫХ:")
        
        for file_name, table_name in FILES:
            print(f"\nЗагрузка {file_name} → {table_name}:")
            rows = load_csv_to_table(engine, file_name, table_name)
        
        print(f"ETL-ПАЙПЛАЙН УСПЕШНО ЗАВЕРШЁН!")
        
    except Exception as e:
        print(f"\nОШИБКА: {e}")
        raise


if __name__ == "__main__":
    run_etl()