NAMESPACE   = kevineye
NAME        = nginx-public
PUBLIC_DIR  = /mnt/sdb1/Everything/BTSync/Public
HOSTNAME    = www
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
	-docker rm -f $(NAME) 2>&1 >/dev/null
	docker run -d --name $(NAME) --restart always -h $(HOSTNAME).$(DOMAINNAME) -v $(PUBLIC_DIR):/usr/share/nginx/html:ro $(NAMESPACE)/$(NAME)

shell: build
	-docker rm -f $(NAME) 2>&1 >/dev/null
	@clear
	docker run --rm -it --name $(NAME) -v $(PUBLIC_DIR):/usr/share/nginx/html:ro $(NAMESPACE)/$(NAME) bash
