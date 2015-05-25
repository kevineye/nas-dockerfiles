NAMESPACE   = kevineye
NAME        = base-32

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

shell: build
	-docker rm -f $(NAME) 2>&1 >/dev/null
	@clear
	docker run --rm -it --name $(NAME) $(NAMESPACE)/$(NAME) bash
