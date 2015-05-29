NAMESPACE     = kevineye
NAME          = webdav-32
CONTAINERNAME = camerasync

IMAGETAG      = $(NAMESPACE)/$(NAME)
HOSTNAME      = $(CONTAINERNAME).kevin-eye.com

SHELLOPTS     = --name $(CONTAINERNAME) \
                -h $(HOSTNAME).$(DOMAINNAME) \
                -v /mnt/sdb1/Everything/Photo\ Library/CameraSync:/share \
                -e PASSWORD=$(shell read -p "New WebDav password: " -s PASSWORD && echo $$PASSWORD)

RUNOPTS       = $(SHELLOPTS) \
                --restart always

# ------------------------------

SHELL         = /bin/bash
.PHONY: all build forcebuild .rmbuilt scratchbuild run dev shell test enter

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
run: build
	-docker rm -f $(CONTAINERNAME) 2>&1 >/dev/null
	@docker run -d $(RUNOPTS) $(IMAGETAG)

# make shell -- like run, but start a shell instead of the default command
shell: build
	-docker rm -f $(CONTAINERNAME) 2>&1 >/dev/null
	@clear
	@docker run --rm -it $(SHELLOPTS) $(IMAGETAG) bash

# make enter -- enter shell in running container; must already be running
enter:
	docker exec -it $(CONTAINERNAME) bash
