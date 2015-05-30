NAMESPACE     = kevineye
NAME          = base-32

IMAGETAG      = $(NAMESPACE)/$(NAME)

SHELLOPTS     = 

# ------------------------------

SHELL         = /bin/bash
.PHONY: all build forcebuild .rmbuilt scratchbuild run dev shell test enter install

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

# make shell -- like run, but start a shell instead of the default command
shell: build
	@clear
	@docker run --rm -it $(SHELLOPTS) $(IMAGETAG) bash

# make install -- setup host system for container
install:
	grep -q '^data-user:.*:900:' /etc/passwd || useradd --uid 900 --gid 100 --system --no-create-home --no-user-group data-user
