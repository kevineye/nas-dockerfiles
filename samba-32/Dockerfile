FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

# BUILD:
# docker build -t kevineye/samba-32 .

# RUN:
# docker run --name samba-data -v /mnt/everything/Everything:/share kevineye/samba-32 echo data
# docker run --name samba -d -p 139:139 -p 445:445 --volumes-from samba-data kevineye/samba-32

# CONFIGURE:
# docker run -it --rm --volumes-from samba-data kevineye/samba-32 useradd -M eye -g users
# docker run -it --rm --volumes-from samba-data kevineye/samba-32 smbpasswd -a eye

RUN apt-get install -yqq samba \
 && touch /etc/samba/smbpasswd

ADD smb.conf /etc/samba/smb.conf

EXPOSE 139
EXPOSE 445

VOLUME /var/lib/samba
# VOLUME /etc/passwd
# VOLUME /etc/group
# VOLUME /etc/shadow
# VOLUME /etc/samba/smbpasswd
VOLUME /etc
VOLUME /share

CMD ["smbd", "--foreground", "--log-stdout"]
