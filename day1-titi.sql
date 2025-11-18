-- user: movie, db : dbmovie

show search_path;

insert into movie (title, year) values ('One Battle After Another', 2025);
select * from movie where year = 2025;