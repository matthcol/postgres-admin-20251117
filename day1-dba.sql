-- user: postgres, db : dbmovie

show search_path; -- "$user", public

create schema toto authorization movie;

-- liste des "utilisateurs": 1 user = 1 role with LOGIN
select * from pg_user; -- + settings de type search_path (visible aussi dans pg_settings)

-- liste des roles/users:
select * from pg_roles;

create role titi;
create role tutu with login;
alter user titi with login; -- ou: alter role


select rolname, rolcanlogin, rolpassword
from pg_roles
where rolname in ('movie', 'postgres', 'titi', 'tutu')
;

select * from pg_shadow; -- voir les mots de passe

alter user titi with password 'password'; -- default encrypting: scram-sha-256
alter user titi set search_path = movie, toto;

set password_encryption = md5;
alter user tutu with password 'password'; -- WARNING:  setting an MD5-encrypted password


select * from pg_shadow;

select pg_reload_conf();
