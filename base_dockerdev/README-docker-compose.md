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

## Usage
1. Copy all files in base_dockerdev to app root directory.
2. Change args for dependency version in docker-compose.yml if need.
3. Default db dependency is Postgres, can be change to MySQL. The MySQL service has been included. 
5. Any volumes would be mounted in container must be created.
4. Execute for first time of dockerfile changed

```bash
docker-compose build
```

5. Run specific service as you want

## TIPS
1. Once something in Dockerfile change, such as Gemfile, you need to rebuild the container.
```bash
docker-compose down
docker-compose up --build #rebuild
```

## Command for services
### For bash debug

```bash
docker-compose run --service-ports runner
```

### Run rails backend
1. Config in config/database.yml must use mysql as host. Database name ,username and password must be same with docker-compose
2. run service
```
docker-compose run --service-ports rails
```

### Run command in running service with not root user 
```bash
docker-compose exec --user $(id -u):$(id -g) service-name /bin/bash
```