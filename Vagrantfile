Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provider :virtualbox do |v|
    v.memory = 768
  end

  config.vm.network :forwarded_port, host: 8080, guest: 80
  config.vm.network :forwarded_port, host: 4443, guest: 443
  config.vm.provision :shell, inline: <<-SHELL
    apt-get update
    apt-get install -y docker.io
    adduser vagrant docker
    systemctl enable docker.service
    echo '{"userns-remap": "default"}' > /etc/docker/daemon.json
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
  SHELL
end
