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

## Variable spéciales triggers

| Variable | Type | Description |
|----------|------|-------------|
| `NEW` | RECORD | Nouvelle ligne (INSERT/UPDATE) |
| `OLD` | RECORD | Ancienne ligne (UPDATE/DELETE) |
| `TG_NAME` | TEXT | Nom du trigger |
| `TG_WHEN` | TEXT | BEFORE, AFTER ou INSTEAD OF |
| `TG_LEVEL` | TEXT | ROW ou STATEMENT |
| `TG_OP` | TEXT | INSERT, UPDATE, DELETE, TRUNCATE |
| `TG_RELID` | OID | OID de la table |
| `TG_TABLE_NAME` | TEXT | Nom de la table |
| `TG_TABLE_SCHEMA` | TEXT | Schéma de la table |
| `TG_NARGS` | INTEGER | Nombre d'arguments |
| `TG_ARGV[]` | TEXT[] | Tableau des arguments |

## Types, opérateurs et fonctions
- numériques: 
    * opérateurs spécifiques %, ^, @, |/
- textes:
    * concaténation: opérateur || ou fonction CONCAT
    * comparaison classique LIKE (CS) ou ILIKE (CI)
    * comparaison avec regexp:  SIMILAR (standard SQL) ou opérateurs ~ ~* (POSIX)
- valeurs nulles: NULLIF, COALESCE
- date-heures: 
    * postgresql.conf : timezone = 'Europe/Paris'

## Import, Export, Backup
### Copy
En psql: \copy (local client) ou COPY (serveur + droit) avec format csv, tsv

\copy movie to 'movie.tsv' DELIMITER E'\t' CSV HEADER ENCODING 'UTF-8';

\copy (select * from movie where year = 1984)  to 'movie-1984.tsv' DELIMITER E'\t' CSV HEADER ENCODING 'UTF-8';

### Dump
Outils: pg_dump (1 base), pg_dumpall (toute base et/ou users)

pg_dump -U movie -d dbmovie 
    -a : data only
    -s : ddl only
    -t : liste de tables
    -n : schema

pg_dump -U movie -d dbmovie -s -t movie -f movie-ddl.
pg_dump -U movie -d dbmovie -a -t movie -f movie-data.sql
pg_dump -U movie -d dbmovie  -t movie -f movie-ddl-data.sql
pg_dump -U movie -d dbmovie -a  --inserts -t movie -f movie-data-i.sql 

psql -U movie -d dbmovie_dev -f movie-ddl-data.sql
psql -U movie -d dbmovie_dev
    truncate movie;

    \copy movie FROM 'movie-1984.tsv' CSV HEADER DELIMITER E'\t' ENCODING 'UTF-8'

Export du schema movie en format PG:
pg_dump -U movie -d dbmovie -n movie -F c -f schema-movie-dump.custom
pg_dump -U movie -d dbmovie -n movie -F t -f schema-movie-dump.tar
pg_dump -U movie -d dbmovie -n movie -F d -f schema-movie-dump-dir












