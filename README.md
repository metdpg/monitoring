# Monitoring

Docker setup for monitoring servers and web services using grafana and prometheus.

## Install

```shell
sudo apt-get install docker
sudo apt-get install docker-compose
sudo apt-get install git
```

```shell
cd <path to where you want the setup>
git clone git@github.com:metdpg/monitoring.git
```

## Configure

Add list of web services to file `prometheus/web_targets.yml`

Add list of servers to file `prometheus/server_targets.yml`

## Run

```shell
cd monitoring
docker-compose up
```

## Test

Go to a browser: https://localhost:3000 to test grafana dashboard.

Test blackbox exporter with e.g `http://localhost:9115/probe?target=google.com&module=icmp&debug=true`