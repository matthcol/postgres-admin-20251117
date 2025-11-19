-- base dbmovie_dev & dbmovie, user postgres

-- base dbmovie_dev

-- NB: PG version < 15:  role PUBLIC que tout le monde a contient
-- les droits de creer des objets dans le schema public (droit CREATE)
-- On faisait alors souvent: REVOKE CREATE ON SCHEMA public FROM PUBLIC;

-- A partir de PG 15, il n'y a plus que USAGE
-- si on veut écrire sur le schema public protégé:
GRANT ALL ON SCHEMA public TO movie;

-- gestion de schema pdt des import de dump
-- ici: import d'un dump sur la nouvelle base (cf Readme)
create schema movie authorization movie;
drop schema movie cascade;
alter schema movie rename to cinema;



-- base dbmovie
vacuum full analyze;

----------------------------------------------
-- gestion des extensions                   --
----------------------------------------------
-- cas de l'extension pg_stat_statements 

select * from pg_extension;
select * from pg_available_extensions;

-- dans postgresql.conf: 
--	shared_preload_libraries = 'pg_stat_statements'

create extension pg_stat_statements;
select * from pg_extension;


SELECT pg_stat_statements_reset();
select * from pg_stat_statements
order by total_exec_time desc;

----------------------------------------------
-- Gestion des sessions, transactions, verrous
----------------------------------------------

-- sessions
select * from pg_stat_activity
order by usename, datname;

-- kill session
select pg_terminate_backend(5280); -- true

-- mettre fin aux requetes en attente ou en cours
select pg_cancel_backend(29276);
select pg_terminate_backend(29276);

-- verrous
select * from pg_class; -- oid table movie = "34050"
-- pids: 29276, 22952
select * from pg_locks 
where 
	pid in (29276, 22952)
	and relation = 34050
order by pid;

------------------------------------------------------
-- complément sur les roles et la notion d'héritage  -
------------------------------------------------------
create role lecteur;
grant usage on schema movie to lecteur;
grant select on movie.movie_70s to lecteur;

create role redacteur;
grant lecteur to redacteur;
grant insert on movie.movie_70s to redacteur;
grant update (duration, director_id )on movie.movie_70s to redacteur;
grant all on sequence movie.movie_id_seq to redacteur;

create user fan1 with login password 'password';
create user fan2 with login password 'password' NOINHERIT;
create user fan3 with login password 'password';

grant lecteur to fan1;
grant lecteur to fan2;
grant redacteur to fan3;

-- NB: fan1 et fan3 ont directement leur role, 
-- fan2 (noinherit) doit prendre le role lecteur explicitement si il veut en bénéficier 
--      à faire avec une option de connexion ou avec SET role = lecteur dans sa session


-- tests insert à faire avec les users: movie, fan1, fan2 ou fan3
insert into movie.movie_70s (title, year) values ('super movie disco', 1972);
update movie.movie_70s set year = 2035 where id = 70328; -- ko si vue avec check option pour ceux qui peuvent faire cet update
update movie.movie_70s set duration = 120 where id = 70328;
insert into movie.movie_70s (title, year) values ('super movie disco IV', 1992); -- ko si vue avec check option























