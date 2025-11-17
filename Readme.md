# PostgreSQL
site (doc + install): postgresql.org

## Service
### Service Windows
```
"C:\Program Files\PostgreSQL\18\bin\pg_ctl.exe" runservice -N "postgresql-x64-18" -D "C:\Program Files\PostgreSQL\18\data" -w
```

## Connection with CLI
```
psql -U postgres -d postgres
psql -U postgres -d postgres -p 5432
psql -U postgres -d postgres -p 5432 -h localhost
```
