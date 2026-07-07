CREATE USER data_engineer_trainee WITH PASSWORD 'trainee123';

GRANT SELECT ON Sales TO data_engineer_trainee;

GRANT INSERT, UPDATE ON Sales TO data_engineer_trainee;
