1. How to use
```bash
//The vm.max_map_count kernel setting needs to be set to at least 262144 for production use
sudo sysctl -w vm.max_map_count=262144
sudo docker-compose up
```

## Tips:
- logstash-beats-output.conf used to override 02-beats-input.conf in container
- elasticsearch data will be persisted in elasticsearch_data directory 

## todo
- config logstash to parser message field?