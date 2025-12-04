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
		AND birthdate IS NOT NULL
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
			JOIN media m ON pl.media_id = m.id
			JOIN direct d ON m.id = d.media_id
		WHERE pl.actor_id = acteur.id
		  AND d.director_id = real.id
	)
);
