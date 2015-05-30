NAMESPACE     = kevineye
NAME          = httpd-router-32
CONTAINERNAME = httpd-router

IMAGETAG      = $(NAMESPACE)/$(NAME)

OPTS          = --name $(CONTAINERNAME) \
                -p 8443:443 \
                -v "$(CURDIR)"/certs:/certs \
                -v /var/run/docker.sock:/var/run/docker.sock

SHELLOPTS     = $(OPTS) \
                -v "$(CURDIR)":/app                

DEVOPTS       = $(SHELLOPTS)

RUNOPTS       = $(SHELLOPTS) \
                -v "$(CURDIR)"/rules.yml:/app/rules.yml \
                --restart always

TESTOPTS      = -v "$(CURDIR)"/certs:/certs \
                -v /var/run/docker.sock:/var/run/docker.sock

# ------------------------------

SHELL         = /bin/bash
.PHONY: all build forcebuild .rmbuilt scratchbuild run dev shell test enter install cert

# make -- build, but do not run, the container
all: build

# make build -- build the image from the docker file if there are changes in the working dir
build: .built

.built: $(shell find $(CURDIR) -type d)
	docker build -t $(IMAGETAG) .
	@touch .built

# make forcebuild -- build the image even if nothing appears to have changed
forcebuild: .rmbuilt build

.rmbuilt:
	@rm -f .built

# make scratchbuild -- build the image from scratch, without using cached layers
scratchbuild:
	docker build --no-cache -t $(IMAGETAG) .
	@touch .built

# make run -- start the container, building, and removing already-existing container as necessary
run: build cert
	-docker rm -f $(CONTAINERNAME) 2>&1 >/dev/null
	docker run -d $(RUNOPTS) $(IMAGETAG)

# make dev -- start the container in dev mode
dev: build cert
	-docker rm -f $(CONTAINERNAME) 2>&1 >/dev/null
	docker run -d $(DEVOPTS) $(IMAGETAG)

# make shell -- like run, but start a shell instead of the default command
shell: build cert
	-docker rm -f $(CONTAINERNAME) 2>&1 >/dev/null
	@clear
	docker run --rm -it $(SHELLOPTS) $(IMAGETAG) bash

# make enter -- enter shell in running container; must already be running
enter:
	docker exec -it $(CONTAINERNAME) bash

# make test -- run tests
test: build cert
	docker run --rm -t $(TESTOPTS) $(NAMESPACE)/$(NAME) prove -v /app/t

# make cert -- create certificate
cert: certs/server.key certs/server.pem

certs/server.key certs/server.pem:
	docker run --rm -it -v "$(CURDIR)"/certs:/certs -w /certs $(NAMESPACE)/$(NAME) openssl req -x509 -newkey rsa:2048 -keyout server.key -out server.pem -days 3650 -nodes
