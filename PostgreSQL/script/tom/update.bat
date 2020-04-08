@ECHO OFF

SET PSQL="C:\Program Files (x86)\PostgreSQL\9.5\bin\psql.exe"
SET PGPASSWORD=<password>
SET HOST=<host>
SET USER=<username>
SET DBNAME=<database>

for %%i in (cod_tom-*.sql) do ( 
ECHO %%~ni.sql:
ECHO.
%PSQL% -h %HOST% -U %USER% -d %DBNAME% -f %%i
ECHO.
)