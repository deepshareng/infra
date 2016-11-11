# Prometheus

## Prometheus at Qidian

TODO:

- How to access Prometheus
- What Prometheus is monitoring
- How do we originize services inside Prometheus

## Configure Prometheus Server To Monitor Services

TODO:

- Who is responsible for managing Prometheus.
- How to add a service into Prometheus to be monitored.
- What are the best practices for setting up the dashboard.
- How to set up the alert.

## Security Considerations

Both prometheus server and PromDash should be installed in a private network enviornment. 
None of them should be exposed to the internet. They do not even have an auth or any security
related features. 

On Azure, we should put all of our infrastructure in side one or several [private network](https://azure.microsoft.com/en-us/services/virtual-network/).
Thus, all prometheus related service should only be exposed to the private networks we build and trust.

## Setup Prometheus Environment on Ubuntu

[Digital Ocean Full Reference] (https://www.digitalocean.com/community/tutorials/how-to-use-prometheus-to-monitor-your-ubuntu-14-04-server)

### Installing Prometheus Server

```bash
mkdir ~/Downloads
cd ~/Downloads
```

```bash
wget "https://github.com/prometheus/prometheus/releases/download/0.15.1/prometheus-0.15.1.linux-amd64.tar.gz"
```

```bash
mkdir -p ~/Prometheus/server
cd ~/Prometheus/server
tar -xvzf ~/Downloads/prometheus-0.14.0.linux-amd64.tar.gz
```

chack version

```
./prometheus -version
```

### Starting Prometheus Server

```bash
cd ~/Prometheus/server
```

Before you start Prometheus, you must first create a configuration file for it called prometheus.yml.
In this example, we configure Prometheus to monitor itself.

```
vim prometheus.yml
```

Copy the following code into the file.

``` yml
global:
  scrape_interval:     15s # By default, scrape targets every 15 seconds.
  evaluation_interval: 15s # By default, scrape targets every 15 seconds.
  # scrape_timeout is set to the global default (10s).

  # Attach these extra labels to all timeseries collected by this Prometheus instance.
  labels:
    monitor: 'codelab-monitor'

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s
    scrape_timeout: 10s

    target_groups:
      - targets: ['localhost:9090']
```

Now you can start Prometheus

```bash
GOMAXPROCS=8 ./prometheus -config.file=prometheus.yml
```

### Installing PromDash

```bash
cd ~/Prometheus
```

```bash
git clone https://github.com/prometheus/promdash.git
```

```bash
sudo apt-get install ruby bundler libsqlite3-dev sqlite3
```

```bash
cd ~/Prometheus/promdash
```

```bash
bundle install --without mysql postgresql
# This might fail... and prints out some pkgs we need to preinstall.
# But it is pretty easy to fix... We need to fill in the doc.
```

### Setting Up the Rails Environment

Create a directory to store the SQLite3 databases associated with PromDash.

```bash
mkdir ~/Prometheus/databases
```

PromDash uses an environment variable called `DATABASE_URL` to determine the name of the the database associated with it. 
Type in the following so that PromDash creates a SQLite3 database called mydb.sqlite3 inside the databases directory:

```bash
echo "export DATABASE_URL=sqlite3:$HOME/Prometheus/databases/mydb.sqlite3" >> ~/.bashrc
```

In this tutorial, you will be running PromDash in production mode, 
so set the `RAILS_ENV` environment variable to production.

```bash
echo "export RAILS_ENV=production" >> ~/.bashrc
. ~/.bashrc
```

Next, create PromDash's tables in the SQLite3 database using the `rake` tool.

```bash
rake db:migrate
```

Because PromDash uses the Rails Asset Pipeline, all the assets(CSS files, images and Javascript files) of the PromDash project should be precompiled. 
Type in the following to do so:

```bash
rake assets:precompile
```

### Starting and Configuring PromDash

```bash
bundle exec thin start -d
```

Wait for a few seconds for the server to start and then visit `http://your_server_ip:3000/` to view PromDash's homepage.

