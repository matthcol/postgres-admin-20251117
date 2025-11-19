-- user movie, base dbmovie
-- NB: si vous voulez faire la requete sur la base dbmobiebig, remplacer movie par media
-- 	et ajouter une jointure avec la table direct

-- requete de division relationnelle pour trouver les acteurs qui ont joué 
-- avec TOUS les réalisateurs d'une liste donnée

-- solution 1: formulation double not exists
with liste_realisateur as (
	SELECT *
	FROM person
	WHERE name in (
		'Martin Scorsese',
		'Quentin Tarantino',
		'Steven Spielberg',
		'Clint Eastwood',
		'James Cameron',
		'Danny Boyle'
	)
)
SELECT * 
FROM person acteur
WHERE NOT EXISTS (
	-- Il ne doit pas exister de réalisateur...
	SELECT 1
	FROM liste_realisateur real
	WHERE NOT EXISTS (
		-- ...avec qui l'acteur n'a jamais joué
		SELECT 1
		FROM play pl
		JOIN movie m ON pl.movie_id = m.id
		WHERE pl.actor_id = acteur.id
		  AND m.director_id = real.id
	)
);

-- solution 2: en comptant
with liste_realisateur as (
	SELECT *
	FROM person
	WHERE name in (
		'Martin Scorsese',
		'Quentin Tarantino',
		'Steven Spielberg',
		'Clint Eastwood',
		'James Cameron',
		'Danny Boyle'
	)
)
SELECT
	acteur.id, acteur.name
FROM
	person acteur 
	JOIN play pl on acteur.id = pl.actor_id
	JOIN movie m on pl.movie_id = m.id
	JOIN liste_realisateur real on m.director_id = real.id
GROUP BY
	acteur.id, acteur.name
HAVING count(distinct real.id) = (
	select count(*) from liste_realisateur
);

-- delete from play;




