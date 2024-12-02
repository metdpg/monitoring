# Monitoring

Docker setup for monitoring servers and web servers/web services using grafana and prometheus.

Monitoring of servers use ICMP (ping) to check if a server is up.

Monitoring of web servers/web services sends a http request and use a 2xx response to check if a service is up or not.

The setup includes a dashboard, `Status of servers and services`, which shows the results of the above mentioned monitoring. You can edit this dashboard, but please note that restarts and future updates will overwrite these changes.

You can also create other dashboards, and these will not be affected by restarts and updates.

## Usage

Follow the documentation below in the same order as described to install dependencies, download repo, configure and run the system.

### Install dependencies

#### Ubuntu

You need to have `docker`, `docker compose plugin` and `git` installed to use this system.

Install `docker` and `docker compose plugin` by following the instructions here: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

Install git:

```shell
sudo apt-get install git
```

#### MacOS

```shell
brew install git
brew install docker
```

Versions used for testing setup:

- git: 2.42.0
- docker: 24.0.6

### Download this repo

```shell
cd <path to where you want the setup>
git clone git@github.com:metdpg/monitoring.git
cd monitoring
```

### Configure

#### Servers and services to monitor

Create file `prometheus/web_targets.yml` and add list of web services to that file. Look at `prometheus/web_targets.yml.example` for how to do that.

Create file `prometheus/server_targets.yml` and add list of servers to that file.  Look at `prometheus/server_targets.yml.example` for how to do that.

Restart the system everytime you make a change to either of these files.

#### Alert configuration

If you want automatic alerts when a server or service becomes unavailable, do the following:

1. Create file `prometheus/alert_rules.yml`. Start by copying `prometheus/alert_rules.yml.example` and replace `<NMHS>` with relevant name.
2. Create file `prometheus/alertmanager.yml`. Start by copying `prometheus/alertmanager.yml.example` and replace `<NMHS>` with relevant name. Then: 
    - configure SMTP fields.
    - set `email_configs` in `receiver` to the desired address to receive alerts on.
3. If you wish to receive alerts through other channels, see https://prometheus.io/docs/alerting/latest/configuration/#receiver-integration-settings.
4. Adjust `prometheus/prometheus.yml` by removing `#` from `alerting` and `rules_files` blocks.
5. Alter docker compose command to: `docker compose --profile alertmanager up -d`

#### Authentication

To edit dashboards login with the `admin` user.
Update `GF_SECURITY_ADMIN_PASSWORD` in the file `grafana/env.config` to set a proper admin password.

To view the dashboards you do not need to login.

### Run

```shell
docker compose up -d
```

Restart system with:

```shell
docker compose stop
docker compose up -d
```

## Test

Go to a browser: https://localhost:3000 and click into dashboard `Status of servers and services` to test grafana dashboard.

Test blackbox exporter with e.g `http://localhost:9115/probe?target=google.com&module=icmp&debug=true`

## Maintenance

### Check status of system

Check that its running:

```shell
docker compose ls
```

Look at the logs:

```shell
docker compose logs
```

### Disk space

The system creates two docker volumes when it starts up for the first time. These two docker volumes contain metrics information and grafana configuration.

Particularly the metrics volume can become large, so the `/var/lib/docker` disk partition need to have sufficient space allocated. Currently the system is configured to retain metrics for 90 days. Data older than that will be deleted.

### Upgrades

Regularly, you should restart the service to get new versions of the images. To do that, run the following commands:

```shell
docker compose stop
docker compose pull --ignore-buildable
docker compose up --force-recreate --build -d
docker image prune
```

Type `y` when asked:

>WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N]

### Remove old setup

NB! This will remove all previous metrics data and dashboards.

```shell
docker compose stop
docker compose rm
docker volume rm monitoring_metdpg_grafana_data monitoring_metdpg_prometheus_data
docker image prune
```
