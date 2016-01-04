FROM tianon/syncthing
MAINTAINER Kevin Eye <kevineye@gmail.com>

USER root

RUN useradd --uid 900 --gid 100 --system --home-dir /home/user --no-user-group data-user \
 && mkdir -p /home/user/.config/syncthing \
 && chown -R data-user:users /home/user

USER data-user

RUN syncthing -generate=/home/user/.config/syncthing \
 && sed -i.bak -e "s/<address>127.0.0.1:/<address>0.0.0.0:/" /home/user/.config/syncthing/config.xml

EXPOSE 8384
EXPOSE 22000
EXPOSE 21025/udp
EXPOSE 21026/udp

VOLUME /home/user/.config/syncthing
