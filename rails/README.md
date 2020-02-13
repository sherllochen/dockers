# Base Docker & Docker Compose

## Environment included
- Ruby
- Bundle
- Rails
- Postgres
- MySQL
- Redis
- NodeJS
- Yarn
- Nginx

## Base setup
1. Copy all files in base_dockerdev to app root directory.
2. Change args for dependency version in docker-compose.yml if need.
3. Default db dependency is Postgres, can be change to MySQL. The MySQL service has been included. 
4. Any volumes would be mounted in container must be created.
5. Execute for first time of dockerfile changed
6. Database name, username and password is definded in docker-compose.yml. The config in config/database.yml must be the same.

```bash
sudo docker-compose build
```

5. Run specific service as you want

## For running development
1. Copy all files in base_dockerdev to app root directory.
2. Change args for dependency version in docker-compose.yml if need.
3. Default db dependency is MySQL, can be change to Postgres. The Postgres service has been included. 
4. Any volumes would be mounted in container must be created.
5. Database name, username and password is defined in docker-compose.yml. The config in config/database.yml must be the same.
5. Execute for first time or whenever dockerfile changed
```bash
sudo docker-compose build
```
6. Run service, rails service will be exposed in 3000.

```bash
sudo docker-compose run --service-ports dev
```

7. Db setup

```bash
# get dev container id, its container name is just list xxx_dev_run_xxx
sudo docker-compose container ps
# attach to dev container
sudo docker exec -it dev-container-id /bin/bash
bundle exec rake db:setup
bundle exec rake db:migrate
bundle exec rake db:seed_fu
```

## For production
### Need to know for local development machine
1. As default, port 8888 will be exposed for deploying using Capistrano through ssh. 

### Steps
1. Sever SSH port for deploying. Default port is 8888. If need to change, there are 3 places need to change. And the specific port must be open in server firewall.
```
# edit .dockerdev/nginx/sshd_config
Port 8888
# edit nginx service in docker-compose.yml 
ports:
  - '80:80'
  - '8888:8888'
# edit config/deploy/production.rb
server "server_domain", user: "deploy", roles: %w{app db web},
       ssh_options: {
           port: 8888
       }
```
2. Default deploy user is 'deploy', password is the same with username. These info can be change in nginx/Dockerfile. Default deploy path is /home/deploy/app.
```
# edit .dockerdev/nginx/Dockerfile
RUN useradd -rm -d /home/deploy -s /bin/bash -g root -G sudo -u 1000 deploy_username -p "$(openssl passwd -1 deploy_password)"
```
3. Change other args for dependency version in docker-compose.yml if need.
4. Default db dependency is MySQL, can be change to Postgres. The Postgres service has been included. 
5. Any volumes would be mounted in container must be created.
6. Database name, username and password is defined in docker-compose.yml. The config in config/database.yml must be the same.
7. Execute for first time or whenever dockerfile changed
```bash
sudo docker-compose build
```
8. Get to run.
```bash
# run service in server
sudo docker-compose run --service-ports production
# run deploy command in local machine.
cap production deploy
```
9. Connect to server, setup db for the first time.
```bash
# get dev container id, its container name is just list xxx_dev_run_xxx
sudo docker-compose container ps
# attach to dev container
docker exec -it dev-container-id /bin/bash
bundle exec rake db:setup
bundle exec rake db:migrate
bundle exec rake db:seed_fu
```


### TIPS
- To view the Rails logs

```bash
less /home/deploy/app/current/log/production.log
```

- To view the NGINX and Passenger logs

```bash
sudo less /var/log/nginx/error.log
```

## TIPS
1. Once something in Dockerfile change, such as Gemfile, you need to rebuild the container.

```bash
sudo docker-compose down
sudo docker-compose up --build #rebuild
```

## Command for other services
### For bash debug

```bash
sudo docker-compose run --service-ports debug
```

### Run command in running service with not root user 
```bash
sudo docker-compose exec --user $(id -u):$(id -g) service-name /bin/bash
```