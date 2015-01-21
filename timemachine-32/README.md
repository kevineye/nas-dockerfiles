docker build -t kevineye/timemachine-32 timemachine-32

docker run --name timemachine -d -p 548:548 -v ~/Desktop/TimeMachine:/TimeMachine -e AFPD_LOGIN=eye -e AFPD_PASSWORD=___ -e AFPD_NAME="Time Machine" -e AFPD_SIZE_LIMIT=1000 kevineye/timemachine-32

http://192.168.59.103:32400/web