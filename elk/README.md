## How to use
1. Allow income ports: 5601(for Kibana)/5044(for Logstash,recommend only open to specific ip).
2. Install docker and docker compose. [offical docs](https://docs.docker.com/install/linux/docker-ce/ubuntu/).
3. Test the installation, command below must return specific version info of docker compose.Such as "docker-compose version 1.25.3, build 1110ad01".

```bash
docker-compose --version 
```
4. Increase vm.max_map_count .

```bash
//The vm.max_map_count kernel setting needs to be set to at least 262144 for production use
sudo sysctl -w vm.max_map_count=262144
```

5. RUN~
```bash
sudo docker-compose up
```

## Tips:
- logstash-beats-output.conf used to override 02-beats-input.conf in container.
- elasticsearch data will be persisted in elasticsearch_data directory of host.

## todo
- config logstash to parser message field?
