
-- SQL 92 format

SELECT artist.artist, cd.cd_title 	
FROM ((artist INNER JOIN song
ON artist.artist_id = song.artist_id) 
INNER JOIN cd_makeup 
ON song.song_id = cd_makeup.song_id) 
INNER JOIN cd 
ON cd_makeup.cd_id=cd.cd_id;


-- SQL 
SELECT artist.artist, cd.cd_title 	
FROM artist, song, cd_makeup, cd
WHERE artist.artist_id = song.artist_id AND
song.song_id = cd_makeup.song_id AND 
cd_makeup.cd_id=cd.cd_id;
