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

## For running development
1. Copy all files in root directory to app root directory.
2. Change args for dependency version in docker-compose.yml if need.
3. Default db dependency is MySQL, can be change to Postgres. The Postgres service has been included. 
4. Any volumes would be mounted in container must be created.
5. Database name, username and password is defined in docker-compose.yml. The config in config/database.yml must be the same.
6. When there is not rails existed, u need to comment out two lines below in .dockerdev/rails/Dockerfile. If there is rails 
```
COPY Gemfile Gemfile.lock $WORKDIR/
COPY package.json yarn.lock $WORKDIR/
```   
7. Execute for first time or whenever dockerfile changed
```bash
sudo docker-compose build
```
7. Run service, rails service will be exposed in 3000.

```bash
sudo docker-compose run --service-ports dev
```

8. Db setup

```bash
# get dev container id, its container name is just list xxx_dev_run_xxx
sudo docker ps -qf "name=^containername$"
# attach to dev container
sudo docker exec -it $(dps -qf "name=containername$") /bin/bash
bundle exec rake db:setup
bundle exec rake db:migrate
bundle exec rake db:seed_fu
```

## For production
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
7. Comment out lines from 69-73 of .dockerdev/rails/Dockerfile.
```
# edit .dockerdev/rails/Dockerfile
#COPY Gemfile Gemfile.lock $WORKDIR/
#RUN bundle install  -j $(nproc)

#COPY package.json yarn.lock $WORKDIR/
#RUN yarn install --no-bin-links
```
8. Execute for first time or whenever dockerfile changed
```bash
sudo docker-compose build
```
9. Get to run.
```bash
# run service in server
sudo docker-compose run --service-ports production
# run deploy command in local machine.
cap production deploy
```
10. Connect to server, setup db for the first time.
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

2. Because the base os image of ruby image is not buster, comment out these lines will help.
W: GPG error: http://mirrors.aliyun.com buster InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 04EE7237B7D453EC NO_PUBKEY 648ACFD622F3D138 NO_PUBKEY DCC9EFBF77E11517

3. If change the args in docker-compose.yml, you may face some errors, recommend to delete yarn.lock and Gemfile.lock and edit Dockerfile about these files. Such as:
```
FROM: COPY Gemfile Gemfile.lock $WORKDIR/
TO: COPY Gemfile $WORKDIR/
FROM: COPY package.json yarn.lock $WORKDIR/
TP: COPY package.json $WORKDIR/
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