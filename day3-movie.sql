-- base dbmovie, user movie

---------------------------------------
-- indexes                           --
---------------------------------------

select * from pg_indexes 
where schemaname = 'movie'
order by indexname;


select 
	m.id,
	m.title,
	m.year,
	m.director_id,
	d.name
from 
	movie m 
	join person d on m.director_id = d.id
where year = 1984;


select 
	m.id,
	m.title,
	m.year,
	m.director_id,
	d.name
from 
	movie m 
	join person d on m.director_id = d.id
where d.name = 'Steven Spielberg'
order by m.year;
-- sans index balaye la table movie pour trouver les films réalisés

create index idx_movie_director on movie(director_id); -- default BTREE
-- OK utilise cet index pour trouver les films réalisés

create index idx_person_name on person(name);
-- OK utilise cet index pour trouver le nom de la personne

-- Choix d'un index: utilisation de la sélectivité
select
	count(name) as nb_name,
	count(distinct name) as nb_name_distinct,
	count(distinct name) / count(name)::float as selectivity_name, -- 0.9926886744949546
	count(distinct id) / count(id)::float as selectivity_id
from person;

select
	count(distinct year) / count(year)::float as selectivity_year -- 0.08930075821398484
from movie;

select * from pg_stats
where tablename in ('movie', 'person')
order by tablename, attname;
-- NB: colonne n_distinct : si nb négatif => séléctivité sinon nb de valeurs distinctes 

-- index partiel, autre type index, fulltext

select * from person where name like 'Steven %';
select * from person where name ilike 'steven %';
select * from person where name ~ '^Steven';


select * 
from movie
where title ilike '%star%';

select 
	id,
	title,
	year,
	to_tsvector('english', title)
from movie
where to_tsvector('english', title) @@ plainto_tsquery('english', 'starring');

select 
	id,
	title,
	year,
	to_tsvector('english', title)
from movie
where title ilike '%terminator%';

select 
	id,
	title,
	year,
	to_tsvector('english', title)
from movie
where to_tsvector('english', title) @@ plainto_tsquery('english', 'terminate');


select to_tsvector('english', 'the little house in the prairie');
select to_tsvector('french', 'the little house in the prairie');
select to_tsvector('french', 'la petite maison dans la prairie');

create index idx_movie_title on movie using gin(to_tsvector('english', title));

-------------------------------------------
-- transactions                          --
-------------------------------------------

select * from movie where year = 2025;
-- no transaction:
insert into movie (title, year) values ('Conjuring 2', 2025) returning *; -- 8079261
insert into movie (title, year) values ('A Battle after another', 2025) returning *; -- 8079262

--session 1
begin; -- start transaction
update movie set duration = 122 where id = 8079261;
update movie set duration = 122 where id = 8079262;

select * from movie where year = 2025;
commit; -- ou rollback;

-- session 2
begin;
update movie set duration = 121 where id = 8079262;
update movie set duration = 121 where id = 8079261;

select * from movie where year = 2025;
commit; -- ou rollback;


create or replace view movie.movie_70s 
as 
	select id, title, year, duration, director_id
	from movie
	where year between 1970 and 1979
with check option -- si DML insert,update
;












