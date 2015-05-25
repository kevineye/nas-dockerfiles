# httpd-router

Dynamic host and path-based routing to docker containers.

### Features:
 - routes http (port 80) traffic to containers based on container hostname (e.g. `docker run -h ...`)
 - additional configuration rules (e.g. redirects) provided in templated config files, yaml markup, or by REST API
 - live routing updates for container start/stop and other config changes
 - zero downtime (connections not interrupted to reconfigure routing)

### Future improvements:
 - cross-host routing
 - caching
 - authentication
 - SSL termination

### Run
Typical configuration:
```
docker run -d --name httpd-router --restart always -p 80:80 -v /var/run/docker.sock:/var/run/docker.sock ubeas/httpd-router
```

#### Automatic hostname routing
When httod-router is run with `-v /var/run/docker.sock:/var/run/docker.sock`, any containers launched in the same docker daemon with a hostname argument (`docker run -h ...`) will automatically have any traffic to httpd-router forwarded to their port 80. Containers do not need to use any `-P` or `-p` flags to be open to traffic on the docker bridged network. The traffic has to make it to httpd-router with the `Host` HTTP header set, probably via wildcard DNS.

#### YAML config
Run with `-v /your/rules.yaml:/app/rules.yaml` to see/edit/persist dynamic rules from outside the container.

Example rules.yml:
```
rules:
  - from: '^$'
    to: /slideshow/
    external: true
  - from: '^slideshow\b'
    container: slideshow
    group: slideshow
  - from: '^grid\b'
	container: grid
    group: grid
```
See below for more on rules.

#### REST API
Use /config/rules and /config/groups endpoints with GET/PUT/DELETE methods to manage rules.yml file dynamically. POST can be used in place of PUT.

Services:

 - **GET /config/rules** - list all rules
 - **PUT /config/rules** - replace all rules
 - **GET /config/rules/*N*** - get rule *N* (first rule = 1)
 - **PUT /config/rules/*N*** - replace rule *N* (or add rule at end if *N* > num rules)
 - **PUT /config/rules/new** - add rule at end
 - **DELETE /config/rules/*N*** - delete rule *N*
 - **GET /config/groups** - list all groups
 - **GET /config/groups/*groupname*** - get all rules with group=*groupname*
 - **PUT /config/groups/*groupname*** - delete all rules with group=*groupname* and add these, setting group=*groupname* for each
 - **DELETE /config/groups/*groupname*** - delete all rules with group=*groupname*

Examples with curl:
```
# get all rules
$ curl localhost/config/rules
[
  {
    "external": "true",
    "from": "^$",
    "to": "/slideshow/"
  },
  {
    "container": "grid",
    "from": "^grid",
    "group": "grid"
  },
  {
    "container": "slideshow",
    "from": "^slideshow",
    "group": "slideshow"
  }
]

# add 301 redirect from /a to /b
$ curl -d '{"from":"^a$", "to":"/b", external:true}' localhost/config/rules/new

# update "slideshow" rules with new rules
$ curl -d '[{"container":"slideshow", "from":"^slideshow"}]' localhost/config/groups/slideshow
```

### Rules
Rules are an ordered list of properties. Rules are processed in order to completion (unless stopped, for example, by "external"). Rules are processed before container routing. Available rule properties are:

**from** - regular expression filtering URL paths this rule applies to. Should probably start with "^". Omit leading "/". A good "from" property probably also leaves off the trailing "/" (the underlying container may not need this or may redirect to add it), but should probably end with "\b" to not match partial words.

**to** - redirect matching URLs to this path or complete URL. Redirect is "internal" (if possible) and rule processing will continue. Can optionally be combined with "container".

**external** - set to "true" to force an external 301 redirect and stop rule processing.

**container** - direct traffic to this container. Must be only the host part of the container's `-h` hostname. Case sensitive. Can optionally be combined with "to".

**group** - allows modifying rules in groups via REST API. Does not affect rule processing.
