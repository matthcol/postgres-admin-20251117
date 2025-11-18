-- user: postgres, db : dbmovie

-- creation d'un schema pour stocker les logs
create schema logs authorization movie;
alter user movie set search_path to movie, toto, logs;