SELECT SP.*,
--    SP."All-Time Rank", --COMMENT OUT WHEN DONE

    --CREATING RANKING BINS
    CASE WHEN SP."All-Time Rank" <= 20 THEN '1-20'
        WHEN SP."All-Time Rank" > 20 AND SP."All-Time Rank" <= 50 THEN '21-50'
        WHEN SP."All-Time Rank" > 50 AND SP."All-Time Rank" <= 100 THEN '51-100'
        WHEN SP."All-Time Rank" > 100 AND SP."All-Time Rank" <= 200 THEN '101-200'
        WHEN SP."All-Time Rank" > 200 AND SP."All-Time Rank" <= 300 THEN '201-300'
        WHEN SP."All-Time Rank" > 300 AND SP."All-Time Rank" <= 400 THEN '301-400'
        WHEN SP."All-Time Rank" > 400 AND SP."All-Time Rank" <= 500 THEN '401-500'
        ELSE NULL 
        END "Rank Bins"
FROM (
    SELECT DISTINCT --TO AVOID DUPLICATES
        --UPDATED COLUMN NAMES TO PREP FOR TABLEAU:
        TRACK "Track", ALBUM_NAME "Album Name", ARTIST "Artist", RELEASE_DATE "Release Date", 
        EXTRACT (YEAR FROM RELEASE_DATE) "Release Year",
        
        --CREATING RELEASE MONTH AND YEAR FIELDS
        EXTRACT (MONTH FROM RELEASE_DATE) "Month",
        
        --CREATING MONTHS FOR BINNING
        CASE WHEN EXTRACT(MONTH FROM RELEASE_DATE) = 1 THEN 'Jan' 
                WHEN EXTRACT(MONTH FROM RELEASE_DATE) = 2 THEN 'Feb'
                WHEN EXTRACT(MONTH FROM RELEASE_DATE) = 3 THEN 'Mar'
                WHEN EXTRACT(MONTH FROM RELEASE_DATE) = 4 THEN 'Apr'
                WHEN EXTRACT(MONTH FROM RELEASE_DATE) = 5 THEN 'May'
                WHEN EXTRACT(MONTH FROM RELEASE_DATE) = 6 THEN 'Jun'
                WHEN EXTRACT(MONTH FROM RELEASE_DATE) = 7 THEN 'Jul'
                WHEN EXTRACT(MONTH FROM RELEASE_DATE) = 8 THEN 'Aug'
                WHEN EXTRACT(MONTH FROM RELEASE_DATE) = 9 THEN 'Sep'
                WHEN EXTRACT(MONTH FROM RELEASE_DATE) = 10 THEN 'Oct'
                WHEN EXTRACT(MONTH FROM RELEASE_DATE) = 11 THEN 'Nov'
                WHEN EXTRACT(MONTH FROM RELEASE_DATE) = 12 THEN 'Dec'
                    ELSE NULL END "Release Month",
        
        ISRC, 
--        NVL(ALL_TIME_RANK, 0) "All-Time Rank", 

        --STRIPPING COMMAS AND CONVERTING IT INT A PURE NUMBERIC FIELD
        TO_CHAR(TRANSLATE(ALL_TIME_RANK, 'X, ','X'), '0000') "All-Time Rank",
        
        --CREATING RANKING BINS
    --    CASE WHEN NVL(ALL_TIME_RANK, 0) <= 20 THEN '1-20'
    --        WHEN NVL(ALL_TIME_RANK, 0) > 20 AND NVL(ALL_TIME_RANK, 0) <= 50 THEN '21-50'
    --        WHEN NVL(ALL_TIME_RANK, 0) > 50 AND NVL(ALL_TIME_RANK, 0) <= 100 THEN '51-100'
    --        WHEN NVL(ALL_TIME_RANK, 0) > 100 AND NVL(ALL_TIME_RANK, 0) <= 200 THEN '101-200'
    --        WHEN NVL(ALL_TIME_RANK, 0) > 200 AND NVL(ALL_TIME_RANK, 0) <= 300 THEN '201-300'
    --        WHEN NVL(ALL_TIME_RANK, 0) > 300 AND NVL(ALL_TIME_RANK, 0) <= 400 THEN '301-400'
    --        WHEN NVL(ALL_TIME_RANK, 0) > 400 AND NVL(ALL_TIME_RANK, 0) <= 500 THEN '401-500'
    --        ELSE NULL 
    --        END "Rank Bins",
        
        TRACK_SCORE "Track Score", 
        
        --STREAMING COUNTS COLUMNS APPENDED WITH NVL TO UPDATE NULLS TO ZEROES
        NVL(SPOTIFY_STREAMS, 0) "Spotify Streams", --
--        NVL(TRANSLATE(SPOTIFY_STREAMS, 'X, ','X'), 0),
        
        NVL(SPOTIFY_PLAYLIST_COUNT, 0) "Spotify Playlist Count", NVL(SPOTIFY_PLAYLIST_REACH, 0) "Spotify Playlist Reach", 
        NVL(SPOTIFY_POPULARITY, 0) "Spotify Popularity", 
        
        NVL(YOUTUBE_VIEWS, 0) "YouTube Views", --
        
        NVL(YOUTUBE_LIKES, 0) "YouTube Likes", 
        NVL(TIKTOK_POSTS, 0) "TikTok Posts", NVL(TIKTOK_LIKES, 0) "TikTok Likes", 
        
        NVL(TIKTOK_VIEWS, 0) "TikTok Views", --
        
        NVL(YOUTUBE_PLAYLIST_REACH, 0) "YouTube Playlist Reach", 
        NVL(APPLE_MUSIC_PLAYLIST_COUNT, 0) "Apple Music Playlist Count", NVL(AIRPLAY_SPINS, 0) "AirPlay Spins", 
        NVL(SIRIUSXM_SPINS, 0) "Sirius XM Spins", NVL(DEEZER_PLAYLIST_COUNT, 0) "Deezer Playlist Count", 
        NVL(DEEZER_PLAYLIST_REACH, 0) "Deezer Playlist Reach", 
        
        NVL(AMAZON_PLAYLIST_COUNT, 0) "Amazon Playlist Count", 
        
        NVL(PANDORA_STREAMS, 0) "Pandora Streams", --
        
        NVL(PANDORA_TRACK_STATIONS, 0) "Pandora Track Stations", 
        
        NVL(SOUNDCLOUD_STREAMS, 0) "Soundcloud Streams", --
        
        NVL(SHAZAM_COUNTS, 0) "Shazam Counts", 
        NVL(TIDAL_POPULARITY, 0) "Tidal Popularity", 
        EXPLICIT_TRACK "Explicit Track",
        
        CASE WHEN EXPLICIT_TRACK = '1' THEN 'Y' ELSE 'N' END "Explicit IND",
        
        --Total Streams
        NVL(SPOTIFY_STREAMS, 0) + NVL(YOUTUBE_VIEWS, 0) + 
        NVL(TIKTOK_VIEWS, 0) + NVL(PANDORA_STREAMS, 0) + 
        NVL(SOUNDCLOUD_STREAMS, 0) AS "Total Streams"  
    FROM SPOTIFY_2024 
    ) SP
ORDER BY SP."All-Time Rank"
;
--WHERE NVL(ALL_TIME_RANK, 0) <= 100
--WHERE SPOTIFY_STREAMS IS NOT NULL
--ORDER BY ALL_TIME_RANK >= 100
--;
----------------------------------------------------------

--TABLE CREATION
SELECT * FROM SPOTIFY_2024 ;

--UPDATED MOST FEATURE COLUMNS AS NUMBERS TO ASSIST WITH ANALYSIS.
CREATE TABLE SPOTIFY_2024 --CREATED/CUSTOM TABLE
( 
    Track VARCHAR2 (255 BYTE),
    Album_Name VARCHAR2 (255 BYTE),
    Artist VARCHAR2 (255 BYTE),
    Release_Date DATE,
    ISRC VARCHAR2 (255 BYTE),
    All_Time_Rank NUMBER,
    Track_Score NUMBER,
    Spotify_Streams NUMBER,
    Spotify_Playlist_Count NUMBER,
    Spotify_Playlist_Reach NUMBER,
    Spotify_Popularity NUMBER,
    YouTube_Views NUMBER,
    YouTube_Likes NUMBER,
    TikTok_Posts NUMBER,
    TikTok_Likes NUMBER,
    TikTok_Views NUMBER,
    YouTube_Playlist_Reach NUMBER,
    Apple_Music_Playlist_Count NUMBER,
    AirPlay_Spins NUMBER,
    SiriusXM_Spins NUMBER,
    Deezer_Playlist_Count NUMBER,
    Deezer_Playlist_Reach NUMBER,
    Amazon_Playlist_Count NUMBER,
    Pandora_Streams NUMBER,
    Pandora_Track_Stations NUMBER,
    Soundcloud_Streams NUMBER,
    Shazam_Counts NUMBER,
    TIDAL_Popularity NUMBER,
    Explicit_Track NUMBER
)
;