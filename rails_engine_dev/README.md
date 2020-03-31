# For rails engine development
1. Change version of Rails and image version in docker-compose.yml.
2. Use the same version of Rails in Gemfile.docker 
3. Add all gem dependency to Gemfile.docker, this file is used to build image.
4. RUN debug service
```bash
docker-compose run --service-ports debug
```