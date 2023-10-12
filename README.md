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

Create file `prometheus/web_targets.yml` and add list of web services to that file. Look at `prometheus/web_targets.yml.example` for how to do that.

Create file `prometheus/server_targets.yml` and add list of servers to that file.  Look at `prometheus/server_targets.yml.example` for how to do that.

## Run

```shell
cd monitoring
docker-compose up
```

## Test

Go to a browser: https://localhost:3000 to test grafana dashboard.

Test blackbox exporter with e.g `http://localhost:9115/probe?target=google.com&module=icmp&debug=true`