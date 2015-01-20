docker build -t kevineye/dropbox-32 dropbox-32

docker run --name dropbox -d -v ~/Desktop/Everything/Dropbox:/home/Dropbox kevineye/dropbox-32

docker logs -f dropbox
