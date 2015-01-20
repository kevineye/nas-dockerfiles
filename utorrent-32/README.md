docker build -t kevineye/utorrent-32 utorrent-32

docker run --name utorrent -d -p 8080:8080 -p 6881:6881 -v ~/Desktop/Everything:/Everything kevineye/utorrent-32

https://192.168.1.151:8080/gui
