docker build -t kevineye/btsync-32 btsync-32

docker run --name btsync -it --rm -p 8888:8888/tcp -p 5555:5555/tcp -p 3838:3838/udp -v ~/Desktop/Everything:/Everything kevineye/btsync-32 /bin/bash
docker run --name btsync -d -p 8888:8888/tcp -p 5555:5555/tcp -p 3838:3838/udp -v ~/Desktop/Everything:/Everything kevineye/btsync-32
