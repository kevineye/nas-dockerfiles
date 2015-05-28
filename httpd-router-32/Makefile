NAMESPACE   = kevineye
NAME        = httpd-router

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
	-docker rm -f $(NAME) 2>&1 >/dev/null
	docker run -d --name $(NAME) --restart always -p 8443:443 -v "$(CURDIR)"/rules.yml:/app/rules.yml -v "$(CURDIR)"/certs:/certs -v /var/run/docker.sock:/var/run/docker.sock $(NAMESPACE)/$(NAME)

dev: build
	-docker rm -f $(NAME) 2>&1 >/dev/null
	docker run -d --name $(NAME) -p 8443:443 -v "$(CURDIR)":/app -v "$(CURDIR)"/certs:/certs -v /var/run/docker.sock:/var/run/docker.sock $(NAMESPACE)/$(NAME)

test: build
	docker run --rm -t -v "$(CURDIR)"/certs:/certs -v /var/run/docker.sock:/var/run/docker.sock $(NAMESPACE)/$(NAME) prove -v /app/t

shell: build
	-docker rm -f $(NAME) 2>&1 >/dev/null
	@clear
	docker run --rm -it --name $(NAME) -p 8443:443 -v "$(CURDIR)":/app -v "$(CURDIR)"/certs:/certs -v /var/run/docker.sock:/var/run/docker.sock $(NAMESPACE)/$(NAME) bash

enter:
	docker exec -it $(NAME) bash
	
cert:
	docker run --rm -it -v "$(CURDIR)"/certs:/certs -w /certs $(NAMESPACE)/$(NAME) openssl req -x509 -newkey rsa:2048 -keyout server.key -out server.pem -days 3650 -nodes