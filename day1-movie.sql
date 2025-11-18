-- user: movie, db : dbmovie

show search_path; -- $user, public (default database)
select * from person limit 10; -- found: movie.person
select * from movie.person limit 10;

CREATE TABLE toto.blague
(
    id_blague smallserial,
    contenu text NOT NULL, -- texte non contraint (1G max)
    PRIMARY KEY (id_blague) -- not null, unique
);

select * from blague; -- ERROR:  relation "blague" does not exist
select * from toto.blague;

set search_path = toto;
select * from blague;

insert into blague (contenu) values ('C''est Toto à l''école. La maîtresse demande :
— Les enfants, qui peut me donner un exemple de malheur ?
Toto lève le doigt :
— Si mon papa tombait dans la rivière, ce serait un malheur !
La maîtresse répond :
— Non Toto, ce serait un accident. Un malheur, c''est quelque chose qui touche tout le monde.
Toto réfléchit et dit :
— Ah ! Alors si mon papa tombait dans la rivière et que personne ne le repêchait, ce serait un malheur ?
La maîtresse soupire :
— Non Toto, ce serait une tragédie...
Toto s''énerve un peu :
— Mais alors c''est quoi un malheur ?!
La maîtresse répond :
— Eh bien par exemple, si l''avion du président s''écrasait, ce serait un malheur.
Toto demande :
— Ah bon ? Mais ce ne serait ni un accident, ni une tragédie ?
La maîtresse sourit :
— Non, parce que ça ne serait une perte pour personne !');
select * from blague;

select * from person limit 10; -- not found

-- réglage de session
set search_path = movie, toto;
select * from blague;
select * from person limit 10;

-- réglage au niveau user (permanent):
-- NB: à changer soi-même ou par le DBA
alter user movie set search_path = movie, toto;

-- donne le droit d'usage au schema movie (par user movie ou dba)
GRANT USAGE ON SCHEMA movie TO titi;
grant select on movie.movie to titi; -- table par table
grant select on all tables in schema movie to titi; -- table + view => 4x (car 4 tables)

grant insert on movie.movie to titi;
grant all on sequence movie.movie_id_seq to titi;



