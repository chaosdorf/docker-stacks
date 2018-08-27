# chaosdorf docker stacks

[work in progress]

Contains docker stacks intended to be deployed on our single-node docker swarm.
Single-node docker swarm is similar to docker engine on a single host but gives a bit more management capabilities like stacks, configs and secrets.

All applications are run in isolated networks not accessible from the outside world by default.
Traefik is deployed to provide L7 HTTP/HTTPS access for all internal services when necessary.
It also automatically configures DNS records and LetsEncrypt TLS certificates for domains.

# Setup

Tested with docker 18.06.1-ce, build e68fc7a in swarm mode.

To deploy services:

```bash
$ docker stack deploy -c traefik-stack.yml traefik
$ docker stack deploy -c chaospizza-stack.yml chaospizza
$ docker stack deploy -c mete-stack.yml mete
```

Traefik publishes port 80 for application access and 8080 for [admin access](http://127.0.0.1:8080/dashboard/).

# Notes

Traefik does not manage DNS records and TLS certs yet. When running swarm on localhost, make sure to add DNS records e.g. to `/etc/hosts`:

```
127.0.0.1 swarmpit.chaosdorf.space
127.0.0.1 portainer.chaosdorf.space
127.0.0.1 chaospizza.chaosdorf.space
127.0.0.1 mete.chaosdorf.space
```

The mete docker image is currently broken and wont initialize correctly.

Portainer and swarmpit are fancy management web UIs and can be deployed tor testing.
