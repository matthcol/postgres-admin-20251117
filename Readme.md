# PostgreSQL
Web site (doc + install): postgresql.org

## Service
### Service Windows
```
"C:\Program Files\PostgreSQL\18\bin\pg_ctl.exe" runservice -N "postgresql-x64-18" -D "C:\Program Files\PostgreSQL\18\data" -w
```

### Service Linux
Voir unité de service systemd dans `/usr/lib/systemd/system`

## Connection with CLI
```
psql -U postgres -d postgres
psql -U postgres -d postgres -p 5432
psql -U postgres -d postgres -p 5432 -h localhost
```

Pour la saisie du mot de passe:
- interactif
- variable d'environnement PGPASSWORD
- fichier ~/.pgpass : https://www.postgresql.org/docs/current/libpq-pgpass.html

## Config user/db/réseau
postgresql.conf: voir settings
- listen_addresses
- port

pg_hba.conf: https://www.postgresql.org/docs/18/auth-pg-hba-conf.html

### Netstat
Windows:
```
netstat -aon
netstat -aonb   # admin
```

Linux (admin: on voit le nom du programme)
```
netstat -plantu
ss -plantu
```

### Primary keys

- smallserial = smallint + gen auto avec 1 sequence (créée automatiquement) 16 bits
- serial = int + gen auto avec 1 sequence (créée automatiquement) 32 bits
- bigserial = bigint + gen auto avec 1 sequence (créée automatiquement) 64 bits

- identity

### Privilèges
https://www.postgresql.org/docs/current/sql-grant.html











