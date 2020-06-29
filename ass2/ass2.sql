-- COMP3311 19T3 Assignment 2
-- Written by Nathan Ellis (z5160405)

-- Helper view for 'Movie Titles'
create or replace view Movies as
select *
from Titles
where format = 'movie';

-- Q1 Which movies are more than 6 hours long? 

create or replace view Q1(title) as
select main_title
from Movies
where runtime > 360;


-- Q2 What different formats are there in Titles, and how many of each?

create or replace view Q2(format, ntitles) as
select format, count(*)
from Titles
group by format;


-- Q3 What are the top 10 movies that received more than 1000 votes?

create or replace view Q3(title, rating, nvotes) as
select main_title, rating, nvotes
from Movies
where nvotes > 1000
order by rating desc, main_title asc
limit 10;


-- Q4 What are the top-rating TV series and how many episodes did each have?

create or replace view NumEpisodes(id, nepisodes) as
select parent_id, count(parent_id)
from episodes
group by parent_id;

create or replace view Q4(title, nepisodes) as
select main_title, nepisodes
from Titles t join NumEpisodes e on (t.id = e.id)
where rating = (select max(rating) from Titles) and (format like 'tvSeries' or format like 'tvMiniSeries');


-- Q5 Which movie was released in the most languages?

create or replace view UniqLanguages(id, language) as
select distinct title_id, language
from aliases
where language is not null;

create or replace view LanguageCount(id, nlang) as
select id, count(language)
from UniqLanguages
group by id;

create or replace view MovieLanguageCount(title, nlang) as
select main_title, nlang
from Movies m join LanguageCount l on (m.id = l.id);

create or replace view Q5(title, nlanguages) as
select title, nlang
from MovieLanguageCount
where nlang = (select max(nlang) from MovieLanguageCount);


-- Q6 Which actor has the highest average rating in movies that they're known for?

create or replace view WorkedAsActor(name_id) as
select distinct name_id
from worked_as
where work_role = 'actor';

create or replace view KnownAsActors(name_id, title_id) as
select distinct w.name_id, title_id
from WorkedAsActor w join known_for k on (w.name_id = k.name_id);

create or replace view KnownAsMovieActors(name_id, title_id, rating) as
select name_id, title_id, rating
from KnownAsActors k join Movies m on (k.title_id = m.id)
where rating is not null;

create or replace view ActorMovieInfo(name_id, avg_rating, nmovies) as
select name_id, avg(rating), count(title_id)
from KnownAsMovieActors
group by name_id;

create or replace view MultiMovieActorRatings(name_id, avg_rating) as
select name_id, avg_rating
from ActorMovieInfo
where nmovies > 1;

create or replace view NameRatings(name, avg_rating) as
select name, avg_rating
from MultiMovieActorRatings m join Names n on (m.name_id = n.id);

create or replace view Q6(name) as
select name
from NameRatings
where avg_rating = (select max(avg_rating) from NameRatings);


-- Q7 For each movie with more than 3 genres, show the movie title and a comma-separated list of the genres

create or replace view MovieGenres(id, title, genre) as
select id, main_title, genre
from Movies m join title_genres t on (m.id = t.title_id);

create or replace view MovieGenreCount(id, ngenres) as
select id, count(genre)
from MovieGenres
group by id;

create or replace view MoreThan3(id) as
select id
from MovieGenreCount
where ngenres > 3;

create or replace view MoreThan3MovieGenres(title, genre) as
select title, genre
from MoreThan3 m join MovieGenres g on (m.id = g.id)
order by title, genre;

create or replace view Q7(title, genres) as
select title, string_agg(genre, ',')
from MoreThan3MovieGenres
group by title;

-- Q8 Get the names of all people who had both actor and crew roles on the same movie

create or replace view ActorCrew(title_id, name_id) as
select distinct a.title_id, a.name_id
from actor_roles a join crew_roles c on (a.title_id = c.title_id and a.name_id = c.name_id);

create or replace view MovieActorCrew(name_id) as
select distinct name_id
from ActorCrew a join Movies m on (a.title_id = m.id);

create or replace view Q8(name) as
select name
from MovieActorCrew m join Names n on (m.name_id = n.id);

-- Q9 Who was the youngest person to have an acting role in a movie, and how old were they when the movie started?

create or replace view MovieActors(name_id, start_year) as
select distinct name_id, start_year
from actor_roles a join Movies m on (a.title_id = m.id)
where start_year is not null;

create or replace view MovieActorInfo(name, age) as
select name, (start_year - birth_year)
from MovieActors a join Names n on (a.name_id = n.id)
where birth_year is not null;

create or replace view Q9(name, age) as
select name, age
from MovieActorInfo
where age = (select min(age) from MovieActorInfo);


-- Q10 Write a PLpgSQL function that, given part of a title, shows the full title and the total size of the cast and crew

create type TitleInfo as (title_id integer, title_name text);

create or replace function
	Q10(partial_title text) returns setof text
as $$
declare
    title_record record;
    title_info TitleInfo;
    actor_crew integer;
    people_count integer;
begin
    people_count := 0;

    for title_record in
        select * from Titles
        where main_title ilike '%'||partial_title||'%'
    loop
        title_info.title_id := title_record.id;
        title_info.title_name := title_record.main_title;
        actor_crew := 0;

        select count(distinct p.name_id) into actor_crew
        from principals p full outer join actor_roles a on p.title_id = a.title_id
        full outer join crew_roles c on p.title_id = c.title_id
        where p.title_id = title_info.title_id;
        
        if actor_crew > 0 then
            people_count := people_count + 1;
            return next title_info.title_name||' has '||actor_crew||' cast and crew';
        end if;
    end loop;

    if people_count = 0 then
        return next 'No matching titles';
    end if;
    return;
end;
$$ language plpgsql;

