docker build -t kevineye/samba-32 samba-32

docker run --name samba -d -v ~/Desktop/Everything:/Everything -p 139:139 -p 445:445 kevineye/samba-32
