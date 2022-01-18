DROP DATABASE IF EXISTS cd_catalog_abstract;

CREATE DATABASE cd_catalog_abstract;
USE cd_catalog_abstract;

-- ARTIST table - includes UNIQUE constraint
CREATE TABLE artist(
artist_id INTEGER UNSIGNED,
artist VARCHAR(50) NOT NULL,
CONSTRAINT artist_pk PRIMARY KEY (artist_id),
CONSTRAINT artist_artist_un UNIQUE(artist));

DESCRIBE artist;

-- SONG table
CREATE TABLE song(
song_id INTEGER UNSIGNED,
song_title VARCHAR(100),
artist_id INTEGER UNSIGNED NOT NULL,
CONSTRAINT song_pk PRIMARY KEY (song_id),
CONSTRAINT song_artist_id_fk FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
	ON UPDATE cascade);

-- SONG_VALUE abstract table
CREATE TABLE song_value(
song_id INTEGER UNSIGNED,
attribute varchar(25),
value varchar(25),
CONSTRAINT song_value_pk PRIMARY KEY(song_id, attribute),
CONSTRAINT song_value_song_id_fk FOREIGN KEY (song_id) REFERENCES song(song_id));

-- CD table
CREATE TABLE cd(
cd_id INTEGER UNSIGNED,
cd_title VARCHAR(100),
CONSTRAINT cd_pk PRIMARY KEY (cd_id));

-- CD_MAKEUP table
CREATE TABLE cd_makeup(
cd_id INTEGER UNSIGNED,
song_id INTEGER UNSIGNED,
CONSTRAINT cd_makeup_pk PRIMARY KEY (cd_id, song_id),
CONSTRAINT cd_makeup_cd_id_fk FOREIGN KEY (cd_id) REFERENCES cd(cd_id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
CONSTRAINT cd_makeup_song_id_fk FOREIGN KEY (song_id) REFERENCES song(song_id)
	ON UPDATE CASCADE
	ON DELETE CASCADE);

-- ARTIST inserts
INSERT INTO artist (artist_id,artist) VALUES(1,"Backstreet Boys");
INSERT INTO artist(artist_id,artist)VALUES(2,"Smash Mouth");
INSERT INTO artist (artist_id,artist)VALUES(3,"Jennifer Lopez");
INSERT INTO artist (artist_id,artist)VALUES(4,"Eiffel 65");
INSERT INTO artist (artist_id,artist)VALUES(5,"Purple4");

-- SONG inserts
INSERT INTO song VALUES(1,"Larger Than Life",1);
INSERT INTO song VALUES(2,"Then the Morning Comes",2);
INSERT INTO song VALUES(3,"Waiting for Tonight",3);
INSERT INTO song VALUES(4,"All Star",2);
INSERT INTO song VALUES(5,"Blue",4);
INSERT INTO song VALUES(6,"Let\'s Get Loud", 3);

-- SONG_VALUE inserts
INSERT INTO song_value VALUES(1, 'length', '232');
INSERT INTO song_value VALUES(2, 'length', '182');
INSERT INTO song_value VALUES(3, 'length', '245');
INSERT INTO song_value VALUES(4, 'length', NULL);
INSERT INTO song_value VALUES(5, 'length', '206');
INSERT INTO song_value VALUES(6, 'length', '245');
INSERT INTO song_value VALUES(1, 'genre', 'pop');
INSERT INTO song_value VALUES(2, 'genre', 'ska');
INSERT INTO song_value VALUES(3, 'genre', 'dance');
INSERT INTO song_value VALUES(4, 'genre', 'pop rock');
INSERT INTO song_value VALUES(5, 'genre', 'eurodance');
INSERT INTO song_value VALUES(6, 'genre', 'salsa');

-- CD inserts
INSERT INTO cd VALUES(1,"Now 4");
INSERT INTO cd VALUES(2,"Astro Lounge");
INSERT INTO cd VALUES(3, "On the 6");

-- CD_MAKEUP inserts
INSERT INTO cd_makeup VALUES(1,1);
INSERT INTO cd_makeup VALUES(1,2);
INSERT INTO cd_makeup VALUES(1,3);
INSERT INTO cd_makeup VALUES(1,5);
INSERT INTO cd_makeup VALUES(2,4);
INSERT INTO cd_makeup VALUES(3,3);
INSERT INTO cd_makeup VALUES(3,6);


