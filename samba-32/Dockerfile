FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN apt-get install -yqq samba

RUN useradd eye -G staff

ADD smb.conf /etc/samba/smb.conf
ADD smbpasswd /etc/samba/smbpasswd

EXPOSE 139
EXPOSE 445

VOLUME /var/lib/samba
VOLUME /Everything

CMD ["smbd", "--foreground", "--log-stdout"]
