NAMESPACE     = kevineye
NAME          = plex-32
CONTAINERNAME = plex

IMAGETAG      = $(NAMESPACE)/$(NAME)
DATANAME      = $(CONTAINERNAME)-data
HOSTNAME      = $(CONTAINERNAME).kevin-eye.com

OPTS          = --name $(CONTAINERNAME) \
                --net=host \
                --volumes-from $(DATANAME) \
                -e PUBLIC_HTTP_HOST=$(HOSTNAME) \
                -e PUBLIC_HTTP_PORT=32400

SHELLOPTS     = $(OPTS) \
                -u root

RUNOPTS       = $(OPTS) \
                --restart always

DATAOPTS      = -v /mnt/everything/Everything:/share

# ------------------------------

SHELL         = /bin/bash
.PHONY: all build forcebuild .rmbuilt scratchbuild data cleandata run dev shell test enter

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

# make data -- start data volume container, only if not already started
data: .data-vol-exists

.data-vol-exists:
	-docker rm -v -f $(DATANAME) 2>&1 >/dev/null
	docker run --name $(DATANAME) $(DATAOPTS) $(IMAGETAG) echo data
	@touch .data-vol-exists

# make cleandata -- remove data volume (and stop running container)
cleandata:
	-docker rm -f $(CONTAINERNAME) 2>&1 >/dev/null
	-docker rm -v -f $(DATANAME) 2>&1 >/dev/null
	@rm -f .data-vol-exists

# make run -- start the container, building, starting data volume, and removing already-existing container as necessary
run: build data
	-docker rm -f $(CONTAINERNAME) 2>&1 >/dev/null
	@docker run -d $(RUNOPTS) $(IMAGETAG)

# make shell -- like run, but start a shell instead of the default command
shell: build data
	-docker rm -f $(CONTAINERNAME) 2>&1 >/dev/null
	@clear
	@docker run --rm -it $(SHELLOPTS) $(IMAGETAG) bash

# make enter -- enter shell in running container; must already be running
enter:
	docker exec -it $(CONTAINERNAME) bash
