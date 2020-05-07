# For rails engine development
1. Change version of Rails and image version in docker-compose.yml.
2. Use the same version of Rails in Gemfile.docker 
3. Add all gem dependency to Gemfile.docker, this file is used to build image.
4. Build the image.
5. Copy Gemfile.docker to Gemfile.
6. RUN debug service
```bash
docker-compose run --service-ports debug
```
7. Create engine.
```bash
rails plugin new engine_name --mountable

```
8. Copy all file in engine directory to root of this directory, override all files existed.
