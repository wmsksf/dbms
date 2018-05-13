# --------------------------------------
# --------------------------------------

DROP PROCEDURE IF EXISTS ValidateQuery;
DELIMITER //
CREATE PROCEDURE ValidateQuery(IN qNum INT, IN queryTableName VARCHAR(255))
BEGIN
	DECLARE cname VARCHAR(64);
	DECLARE done INT DEFAULT FALSE;
	DECLARE cur CURSOR FOR SELECT c.column_name FROM information_schema.columns c WHERE 
c.table_schema='movies' AND c.table_name=queryTableName;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	# Add the column fingerprints into a tmp table
	DROP TABLE IF EXISTS cFps;
	CREATE TABLE cFps (
  	  `val` VARCHAR(50) NOT NULL
	) 
	ENGINE = InnoDB;

	OPEN cur;
	read_loop: LOOP
		FETCH cur INTO cname;
		IF done THEN
      			LEAVE read_loop;
    		END IF;
		
		DROP TABLE IF EXISTS ordered_column;
		SET @order_by_c = CONCAT('CREATE TABLE ordered_column as SELECT ', cname, ' FROM ', queryTableName, ' ORDER BY ', cname);
		PREPARE order_by_c_stmt FROM @order_by_c;
		EXECUTE order_by_c_stmt;
		
		SET @query = CONCAT('SELECT md5(group_concat(', cname, ', "")) FROM ordered_column INTO @cfp');
		PREPARE stmt FROM @query;
		EXECUTE stmt;

		INSERT INTO cFps values(@cfp);
		DROP TABLE IF EXISTS ordered_column;
	END LOOP;
	CLOSE cur;

	# Order fingerprints
	DROP TABLE IF EXISTS oCFps;
	SET @order_by = 'CREATE TABLE oCFps as SELECT val FROM cFps ORDER BY val'; 
	PREPARE order_by_stmt FROM @order_by;
	EXECUTE order_by_stmt;

	# Read the values of the result
	SET @q_yours = 'SELECT md5(group_concat(val, "")) FROM oCFps INTO @yours';
	PREPARE q_yours_stmt FROM @q_yours;
	EXECUTE q_yours_stmt;

	SET @q_fp = CONCAT('SELECT fp FROM fingerprints WHERE qnum=', qNum,' INTO @rfp');
	PREPARE q_fp_stmt FROM @q_fp;
	EXECUTE q_fp_stmt;

	SET @q_diagnosis = CONCAT('select IF(@rfp = @yours, "OK", "ERROR") into @diagnosis');
	PREPARE q_diagnosis_stmt FROM @q_diagnosis;
	EXECUTE q_diagnosis_stmt;

	INSERT INTO results values(qNum, @rfp, @yours, @diagnosis);

	DROP TABLE IF EXISTS cFps;
	DROP TABLE IF EXISTS oCFps;
END//
DELIMITER ;

# --------------------------------------

# Execute queries (Insert here your queries).

# Validate the queries
drop table if exists results;
CREATE TABLE results (
  `qnum` INTEGER  NOT NULL,
  `rfp` VARCHAR(50)  NOT NULL,
  `yours` VARCHAR(50)  NOT NULL,
  `diagnosis` VARCHAR(10)  NOT NULL
)
ENGINE = InnoDB;


# -------------
# Q1
drop table if exists q;
create table q as # Do NOT delete this line. Add the query below.

select title
from movie
where movie_id in
	(select movie_id
	from role
    join actor
		on role.actor_id = actor.actor_id
	where actor.last_name = 'Allen'
    )
and
	movie_id in
	(select movie_id 
	from movie_has_genre
    join genre
		on movie_has_genre.genre_id = genre.genre_id
	where genre.genre_name = 'Comedy'
    );

CALL ValidateQuery(1, 'q');
drop table if exists q;
# -------------


# -------------
# Q2
drop table if exists q;
create table q as # Do NOT delete this line. Add the query below.

select last_name, title
from director, movie
where (director_id, movie_id) in
	(select director_id, movie_id
    from movie_has_director
	where movie_id in
		(select movie_id
		from role
		join actor
			on role.actor_id = actor.actor_id
		where actor.last_name = 'Allen'
        )
    )
and  
	director_id in
	(select director_id
    from movie_has_director
    join movie_has_genre 
		on movie_has_genre.movie_id = movie_has_director.movie_id
    group by movie_has_director.director_id
    having count(genre_id) >= 2
    );

CALL ValidateQuery(2, 'q');
drop table if exists q;
# -------------


# -------------
# Q3
drop table if exists q;
create table q as # Do NOT delete this line. Add the query below.

select distinct a.last_name
from role
join actor a
	on role.actor_id = a.actor_id
join movie_has_director md
	on role.movie_id = md.movie_id
join director d
	on md.director_id = d.director_id
where d.last_name = a.last_name
	and a.actor_id in
		(select distinct a.actor_id
		from role
		join actor a
			on role.actor_id = a.actor_id
		join movie_has_director md
			on role.movie_id = md.movie_id
		join director d1
			on md.director_id = d1.director_id
		join movie_has_genre mg
			on md.movie_id = mg.movie_id
		where d1.last_name <> a.last_name and mg.genre_id in
			(select distinct genre_id
            from movie_has_genre
            join movie_has_director
				on movie_has_genre.movie_id = movie_has_director.movie_id
			join director
				on movie_has_director.director_id = director.director_id
			where d.last_name = director.last_name 
			)
		);

CALL ValidateQuery(3, 'q');
drop table if exists q;
# -------------


# -------------
# Q4
drop table if exists q;
create table q as # Do NOT delete this line. Add the query below.

select 'yes' as answer
from movie
where year=1995 and movie_id in
	(select movie_id
	from movie_has_genre
	join genre
		on movie_has_genre.genre_id = genre.genre_id
	where genre.genre_name = 'Drama'
    )
union
select 'no' as answer
from movie
where year=1995 and movie_id not in
	(select movie_id
	from movie_has_genre
	join genre
		on movie_has_genre.genre_id = genre.genre_id
	where genre.genre_name = 'Drama'
	);
        
CALL ValidateQuery(4, 'q');
drop table if exists q;
# -------------


# -------------
# Q5
drop table if exists q;
create table q as # Do NOT delete this line. Add the query below.

select d1.last_name as director_1, d2.last_name as director_2
from movie_has_director md1, movie_has_director md2, director d1,
	director d2, movie_has_genre mg1, movie_has_genre mg2
where d1.director_id = md1.director_id
	and d2.director_id = md2.director_id
	and mg1.movie_id = md1.movie_id
    and mg2.movie_id = md2.movie_id
	and md1.director_id < md2.director_id
    and md1.movie_id = md2.movie_id
    and md1.movie_id in
    (select movie_id
	from movie
	where movie.year >= 2000 and movie.year <= 2006)
group by md1.director_id, md2.director_id
having count(distinct mg1.genre_id) >= 6 and count(distinct mg2.genre_id) >= 6;

CALL ValidateQuery(5, 'q');
drop table if exists q;
# -------------


# -------------
# Q6
drop table if exists q;
create table q as # Do NOT delete this line. Add the query below.

select first_name, last_name, count(distinct director_id) as directors
from actor
join role
	on actor.actor_id = role.actor_id
join movie_has_director
	on role.movie_id = movie_has_director.movie_id
group by actor.actor_id
having count(distinct role.movie_id) = 3;

CALL ValidateQuery(6, 'q');
drop table if exists q;
# -------------


# -------------
# Q7
drop table if exists q;
create table q as # Do NOT delete this line. Add the query below.

select genre_id, count(distinct director_id) as directors
from movie_has_director
join movie_has_genre
	on movie_has_director.movie_id = movie_has_genre.movie_id
where genre_id in
    (select genre_id
	from movie_has_genre
    group by movie_id
	having count(distinct genre_id) = 1)
group by genre_id;  

CALL ValidateQuery(7, 'q');
drop table if exists q;
# -------------


# -------------
# Q8
drop table if exists q;
create table q as # Do NOT delete this line. Add the query below.

select actor_id
from role
join movie_has_genre
	on role.movie_id = movie_has_genre.movie_id
group by role.actor_id
having count(movie_has_genre.movie_id) >= (select count(*) from genre);

CALL ValidateQuery(8, 'q');
drop table if exists q;
# -------------


# -------------
# Q9
drop table if exists q;
create table q as # Do NOT delete this line. Add the query below.

select g1.genre_id as genre_1, g2.genre_id as genre_2,
	count(distinct director_id) as directors
from movie_has_genre g1, movie_has_genre g2, movie_has_director
where g1.genre_id < g2.genre_id 
	and director_id in 
	(select director_id
    from movie_has_director
    where movie_id in 
		(select movie_id 
        from movie_has_genre g 
        where g.genre_id = g1.genre_id)
	)
	and director_id in
	(select director_id
    from movie_has_director
    where movie_id in 
		(select movie_id
        from movie_has_genre g 
        where g.genre_id = g2.genre_id)
	)
group by g1.genre_id, g2.genre_id;

CALL ValidateQuery(9, 'q');
drop table if exists q;
# -------------


# -------------
# Q10
drop table if exists q;
create table q as # Do NOT delete this line. Add the query below.

select genre_id, actor_id, count(r.movie_id) as movies
from role r
join movie_has_director md
	on r.movie_id = md.movie_id
join movie_has_genre mg
	on r.movie_id = mg.movie_id
where r.movie_id  in
	(select d.movie_id
	from movie_has_director d
    join movie_has_genre g
		on d.movie_id = g.movie_id
	where d.director_id not in
		(select dd.director_id
		from movie_has_director dd
        join movie_has_genre gg
			on dd.movie_id = gg.movie_id
		group by dd.director_id
        having count(distinct genre_id) <> 1
		)
	)
group by genre_id, actor_id
having count(distinct director_id) = 1;

CALL ValidateQuery(10, 'q');
drop table if exists q;
# -------------

DROP PROCEDURE IF EXISTS RealValue;
DROP PROCEDURE IF EXISTS ValidateQuery;
DROP PROCEDURE IF EXISTS RunRealQueries;