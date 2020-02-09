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
1. Copy all files to app root directory.
2. Change args for dependency version in docker-compose.yml if need.
3. Default db dependency is Postgres, can be change to MySQL. The MySQL service has been included. 
4. Any volumes would be mounted in container must be created.
5. Execute for first time of dockerfile changed
6. Database name, username and password is definded in docker-compose.yml. The config in config/database.yml must be the same.

```bash
docker-compose build
```

5. Run specific service as you want

## For running development
Rails service will be exposed in 3000.
1. Run service

```bash
docker-compose run --service-ports dev
```

2. Db setup

```bash
# get rails container id
docker-compose container ps
# attach to rails container
docker exec -it rails-container-id /bin/bash
bundle exec rake db:setup
bundle exec rake db:migrate
bundle exec rake db:seed_fu
```

## For production
Port 22 will be exposed for deploy using Capistrano through ssh. Default deploy user is 'deploy', password is the same with username. These info can be change in nginx/Dockerfile. Default deploy path is /home/deploy/app.
```bash
# run service in server
docker-compose run --service-ports production
# run deploy command in local machine.
cap production deploy
```

### TIPS
- To view the Rails logs

```bash
less /home/deploy/app/current/log/production.log
```

- To view the NGINX and Passenger logs

```bash
sudo cat /var/log/nginx/error.log
```

## TIPS
1. Once something in Dockerfile change, such as Gemfile, you need to rebuild the container.

```bash
docker-compose down
docker-compose up --build #rebuild
```

## Command for other services
### For bash debug

```bash
docker-compose run --service-ports debug
```

### Run command in running service with not root user 
```bash
docker-compose exec --user $(id -u):$(id -g) service-name /bin/bash
```

### Attach to specific container
```bash
docker container ps
docker exec -it container_id /bin/bash
```