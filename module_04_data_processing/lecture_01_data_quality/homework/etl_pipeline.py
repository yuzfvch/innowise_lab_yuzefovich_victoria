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
    ("countries.csv", "silver_countries"),
    ("cities.csv", "silver_cities"),
    ("categories.csv", "silver_categories"),
    ("products.csv", "silver_products"),
    ("shops.csv", "silver_shops"),
    ("employees.csv", "silver_employees"),
    ("customers.csv", "silver_customers"),
    ("sales.csv", "silver_sales"),
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

def validate_and_fix_date(date_str):
    """Валидирует и исправляет дату."""
    if pd.isna(date_str) or date_str == '':
        return '1900-01-01'
    
    date_str = str(date_str).strip()
    for fmt in ('%Y-%m-%d', '%Y/%m/%d', '%d.%m.%Y', '%m/%d/%Y'):
        try:
            dt = pd.to_datetime(date_str, format=fmt)
            if 1900 <= dt.year <= 2100:
                return dt.strftime('%Y-%m-%d')
        except (ValueError, TypeError):
            continue
    
    return '1900-01-01'

def load_sales_with_fix(engine, file_name, table_name, schema='silver'):
    """Загружает sales.csv с восстановлением времени и удалением строк без даты."""
    try:
        print(f"Чтение файла {file_name}...")
        df = pd.read_csv(file_name, sep=';')
        
        def fix_timestamp(val):
            if pd.isna(val):
                return None
            val = str(val).strip()
            if val == '' or pd.isna(val):
                return None 
            
            if len(val) == 10 and val.count('-') == 2:
                return val + ' 00:00:00'
            return val

        df['sales_timestamp'] = df['sales_timestamp'].apply(fix_timestamp)
        df = df.dropna(subset=['sales_timestamp'])
        df['sales_timestamp'] = pd.to_datetime(df['sales_timestamp'], errors='coerce')
        df = df.dropna(subset=['sales_timestamp'])
        
        df.to_sql(
            name=table_name,
            con=engine, 
            schema=schema,
            if_exists='append',
            index=False, 
            chunksize=10000,
        )
        print(f"Таблица {schema}.{table_name} успешно загружена ({len(df)} записей).")
    except Exception as e:
        print(f"Ошибка при загрузке {file_name}: {e}")
        raise

def load_employees_with_fix(engine, file_name, table_name, schema='silver'):
    """Загружает employees с валидацией дат."""
    try:
        print(f"Чтение файла {file_name}...")
        df = pd.read_csv(file_name, sep=';')
        
        if 'birth_date' in df.columns:
            df['birth_date'] = df['birth_date'].apply(validate_and_fix_date)
        if 'hire_date' in df.columns:
            df['hire_date'] = df['hire_date'].apply(validate_and_fix_date)
            
        df['birth_date'] = pd.to_datetime(df['birth_date']).dt.date
        if 'hire_date' in df.columns:
            df['hire_date'] = pd.to_datetime(df['hire_date']).dt.date
            
        df.to_sql(
            name=table_name, 
            con=engine,
            schema=schema,
            if_exists='append',
            index=False, 
            chunksize=10000,
        )
        print(f"Таблица {schema}.{table_name} успешно загружена ({len(df)} записей).")
    except Exception as e:
        print(f"Ошибка при загрузке {file_name}: {e}")
        raise

def load_csv_to_table(engine, file_name, table_name, schema='silver'):
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
    
        

def run_etl():
    """Основная функция ETL-пайплайна."""
    try:
        engine = get_engine(DB_USER, DB_PASSWORD, DB_HOST, DB_PORT, DB_NAME)
        print("\nНАЧАЛО ЗАГРУЗКИ ДАННЫХ:")
        
        for file_name, table_name in FILES:
            print(f"\nЗагрузка {file_name} → {table_name}:")
            if file_name == 'sales.csv':
                rows = load_sales_with_fix(engine, file_name, table_name)
            elif file_name == 'employees.csv':
                rows = load_employees_with_fix(engine, file_name, table_name)
            else:
                rows = load_csv_to_table(engine, file_name, table_name)
    
        print(f"ETL-ПАЙПЛАЙН УСПЕШНО ЗАВЕРШЁН!")
        
    except Exception as e:
        print(f"\nОШИБКА: {e}")
        raise


if __name__ == "__main__":
    run_etl()