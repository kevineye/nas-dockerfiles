NAMESPACE   = kevineye
NAME        = webdav-32
HOSTNAME    = camerasync
DOMAINNAME  = kevin-eye.com
SHELL       = /bin/bash

.PHONY: all clean run dev shell test

all: build

# .built, build, and find cmd work together to make build only run if any file has changed
build: .built

.built: $(shell find $(CURDIR) -type d)
	docker build -t $(NAMESPACE)/$(NAME) .
	@docker inspect -f '{{.Id}}' $(NAMESPACE)/$(NAME) > .built

# use clean to re-build even if no file has changed
clean:
	@rm -f .built

run: build
	-docker rm -f $(HOSTNAME) 2>&1 >/dev/null
	@docker run --name $(HOSTNAME) -d -h $(HOSTNAME).$(DOMAINNAME) -v /mnt/sdb1/Everything/Photo\ Library/CameraSync:/share -e PASSWORD=$(shell read -p "New WebDav password: " -s PASSWORD && echo $$PASSWORD) $(NAMESPACE)/$(NAME)

shell: build
	-docker rm -f $(HOSTNAME) 2>&1 >/dev/null
	@clear
	docker run --rm -it --name $(HOSTNAME) -h $(HOSTNAME).$(DOMAINNAME) -v /mnt/sdb1/Everything/Photo\ Library/CameraSync:/share -e PASSWORD=$(shell read -p "New WebDav password: " -s PASSWORD && echo $$PASSWORD) $(NAMESPACE)/$(NAME) bash

enter:
	docker exec -it $(HOSTNAME) bash
