# Base Docker & Docker Compose

## Environment included
- Ruby
- Bundle
- Postgres
- Redis
- NodeJS
- Yarn
- Rails

## Usage
1. copy all files in rails6 to app root directory.
2. change args for dependency version in docker-compose.yml if need. 
3. execute for first time of dockerfile changed.

```bash
docker-compose build
``` 

4. run bash service
```bash
docker-compose up runner
```

5. attach to container
```bash
docker container ls 
docker exec -it container_id_xxxx /bin/bash
```

6.  navigate to / directory and use /app as app root directory