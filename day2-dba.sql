-- user: postgres, db : dbmovie

-- creation d'un schema pour stocker les logs
create schema logs authorization movie;
alter user movie set search_path to movie, toto, logs;

CREATE DATABASE dbmovie_dev ENCODING = 'UTF8';

-- reconnection sur dbmovie_dev

create schema movie authorization movie;