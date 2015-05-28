NAMESPACE   = kevineye
NAME        = heyu-32
HOSTNAME    = home
DOMAINNAME  = kevin-eye.com

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
	#sudo chmod 666 /dev/ttyUSB0
	-docker rm -f $(NAME) 2>&1 >/dev/null
	docker run --name $(NAME) -d -h $(HOSTNAME).$(DOMAINNAME) --privileged -v /etc/localtime:/etc/localtime $(NAMESPACE)/$(NAME)

shell: build
	-docker rm -f $(NAME) 2>&1 >/dev/null
	@clear
	docker run --rm -it --name $(NAME) -h $(HOSTNAME).$(DOMAINNAME) --privileged -v /etc/localtime:/etc/localtime $(NAMESPACE)/$(NAME) bash

enter:
	docker exec -it $(NAME) bash
