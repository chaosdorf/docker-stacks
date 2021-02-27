Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"
  config.vm.provider :virtualbox do |v|
    v.memory = 1500
  end

  config.vm.network :forwarded_port, host: 8080, guest: 80
  config.vm.network :forwarded_port, host: 4443, guest: 443
  config.vm.provision :shell, inline: <<-SHELL
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io
    adduser vagrant docker
    systemctl enable docker.service
    docker swarm init
    docker network create --driver overlay traefik_net
    echo "foo" | docker secret create DASHING_AUTH_TOKEN -
    echo "foo" | docker secret create TWITTER_ACCESS_TOKEN -
    echo "foo" | docker secret create TWITTER_ACCESS_TOKEN_SECRET -
    echo "foo" | docker secret create TWITTER_CONSUMER_KEY -
    echo "foo" | docker secret create TWITTER_CONSUMER_SECRET -
    echo "https://pass@example.net/1" | docker secret create DASHPI_SENTRY_DSN -
    echo "foo" | docker secret create INFO_BEAMER_API_KEY -
    echo "https://pass@example.net/2" | docker secret create FFTALKS_SENTRY_DSN -
    echo "foo" | docker secret create TELEMETE_API_KEY -
    echo "https://pass@example.net/3" | docker secret create TELEMETE_SENTRY_DSN -
    echo "https://pass@example.net/4" | docker secret create MPD2MQTT_SENTRY_DSN -
    echo "https://pass@example.net/4" | docker secret create LABELLO_SENTRY_DSN -
    echo "https://pass@example.net/5" | docker secret create METE_SENTRY_DSN -
    echo "https://pass@example.net/6" | docker secret create CHAOSPIZZA_SENTRY_DSN -
    echo "foo" | docker secret create CHAOSPIZZA_DJANGO_SECRET_KEY -
    echo "foo" | docker secret create CF_API_KEY -
    echo "admin:traefik:817374111f31cc282162486425ee5e9e" | docker secret create TRAEFIK_DIGEST_AUTH - # admin:admin
    cd /vagrant && ./deploy-stacks.sh
    docker exec $(docker ps -q -f name=sentry_snuba-api) ./docker_entrypoint.sh bootstrap --force
    docker exec $(docker ps -q -f name=sentry_web) ./docker-entrypoint.sh upgrade --noinput
  SHELL
end
