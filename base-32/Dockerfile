FROM 32bit/ubuntu:14.04
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN apt-get -qq update

RUN useradd --uid 900 --gid 100 --system --no-create-home --no-user-group data-user

CMD ["/bin/bash"]
