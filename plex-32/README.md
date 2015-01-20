docker build -t kevineye/plex-32 plex-32

docker run --name plex -d -p 32400:32400 -v ~/Desktop/Everything:/Everything kevineye/plex-32

http://192.168.59.103:32400/web