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
	docker run -d --name $(NAME) --restart always -p 80:80 -v "$(CURDIR)"/rules.yml:/app/rules.yml -v /var/run/docker.sock:/var/run/docker.sock $(NAMESPACE)/$(NAME)

dev: build
	-docker rm -f $(NAME) 2>&1 >/dev/null
	docker run -d --name $(NAME) -p 80:80 -v "$(CURDIR)":/app -v /var/run/docker.sock:/var/run/docker.sock $(NAMESPACE)/$(NAME)

test: build
	docker run --rm -t -v /var/run/docker.sock:/var/run/docker.sock $(NAMESPACE)/$(NAME) prove -v /app/t

shell: build
	-docker rm -f $(NAME) 2>&1 >/dev/null
	@clear
	docker run --rm -it --name $(NAME) -p 80:80 -v "$(CURDIR)":/app -v /var/run/docker.sock:/var/run/docker.sock $(NAMESPACE)/$(NAME) bash
