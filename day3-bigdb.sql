-- base dbmoviebig, user proprietaire data

-- utilise index btree : =, <, <=, >, >=, between
select * from media where id = 8185818;

select * from media where title = 'The Terminator';

select * from pg_indexes 
where schemaname = 'public'
order by indexname;

-- beaucoup de lignes par année, la sélectivité de la colonne release_year est diluée
-- par rapport à la petite base: même nb d'années et volume total 1K => 10M
select
	count(distinct release_year) / count(release_year)::float as selectivity_year -- 1.606153162127334e-05
from media;

-- statistiques sur les colonnes de la table
select * from pg_stats
where tablename in ('media', 'person')
order by tablename, attname;

-- rafraichissement des stats (en général fait pendant l'autovacuum)
analyze media;
-- recalcul complet des statistiques pendant le vacuum full (defragmentation)
vacuum full analyze media;

-- recherche de mot(s) dans un film
select * 
from media
where title ilike '%star%'; -- balayage de la table, l'opérateur like n'est pas performant

-- avec la recherche full texte, on pourra mettre en place un index de qualité
-- FTS = Full Text Search
-- https://www.postgresql.org/docs/current/textsearch.html
select * 
from media
where to_tsvector('english', title) @@ plainto_tsquery('english', 'star');

-- avec l'index => très rapide
create index idx_media_title on media using gin(to_tsvector('english', title));

