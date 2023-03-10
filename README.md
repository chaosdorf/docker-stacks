# chaosdorf docker stacks

Contains docker stacks deployed on our single-node docker swarm.
Single-node docker swarm is similar to docker engine on a single host
but gives a bit more management capabilities like stacks, configs and secrets.

All applications are run in isolated networks not accessible from the outside world by default.
Traefik is deployed to provide L7 HTTP/HTTPS access for all internal services when necessary.
It also automatically configures LetsEncrypt TLS certificates for domains.

## Add a new piece of software

**tl;dr**: Open a pull request which adds a new file to `enabled/`.

For more details please see the [wiki](https://wiki.chaosdorf.de/Software#HowTo).

## Test this on your own machine

You can simply use the provided `Vagrantfile`:

```bash
vagrant up
```

If you want to set up the system yourself:

It is tested with docker 20.10 and 23.0 in swarm mode.

To deploy services:

```bash
$ ./deploy-stacks.sh traefik
$ ./deploy-stacks.sh chaospizza
...
$ ./deploy-stacks.sh # deploys everything
```

Traefik publishes port 80 for application access and 443 for HTTPS.
The Vagrantfile remaps this to 8080 and 4443.

## Notes

### DNS

Traefik does not manage DNS records yet.

When running swarm on localhost, make sure to add DNS records e.g. to `/etc/hosts`:

```
127.0.0.1 swarmpit.chaosdorf.space
127.0.0.1 portainer.chaosdorf.space
127.0.0.1 pizza.chaosdorf.space
127.0.0.1 dashboard.chaosdorf.space
127.0.0.1 labello.chaosdorf.space
127.0.0.1 prittstift.chaosdorf.space
127.0.0.1 mete.chaosdorf.space
127.0.0.1 fftalks.chaosdorf.space
127.0.0.1 pulseweb.chaosdorf.space
127.0.0.1 ympd.chaosdorf.space
127.0.0.1 traefik.chaosdorf.space
127.0.0.1 glitchtip.chaosdorf.space
127.0.0.1 snmp.chaosdorf.space
127.0.0.1 swarmpit
127.0.0.1 portainer
127.0.0.1 pizza
127.0.0.1 dashboard
127.0.0.1 labello
127.0.0.1 prittstift
127.0.0.1 mete
127.0.0.1 fftalks
127.0.0.1 pulseweb
127.0.0.1 ympd
127.0.0.1 traefik
127.0.0.1 glitchtip
127.0.0.1 snmp
```

### Disabled containers

Portainer and swarmpit are fancy management web UIs and can be deployed tor testing.

### IPv6

Docker has [experimental `ip6tables` support](https://github.com/moby/moby/pull/41622).
When enabling it (and
[reconfiguring `docker_gwbridge`](https://github.com/robbertkl/docker-ipv6nat/blob/master/README.md#swarm-mode-support)
), containers get internal IPv6 addresses and might be able to reach external
hosts via IPv6. This does not seem to work for the ingress network, though.

That's why forwarded ports are marked with `mode: host` which bypasses Swarm's
load balancing.

