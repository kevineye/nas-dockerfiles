FROM buildpack-deps
MAINTAINER kevineye@gmail.com

# docker run -d --name bragi --restart always -h bragi.kevin-eye.com -e MPD_ADDR=192.168.1.110:6600 -p 8800:80 kevineye/bragi

WORKDIR /app

RUN git clone https://github.com/kanaka/websockify.git \
 && cd websockify \
 && git checkout -q tags/v0.7.0

RUN git clone https://github.com/bobboau/Bragi-MPD.git bragi

ENV MPD_ADDR mpd:6600
EXPOSE 80

CMD /app/websockify/run --web=/app/bragi 80 $MPD_ADDR
