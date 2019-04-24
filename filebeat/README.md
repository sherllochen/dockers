# How to use
With this docker-compose, you can easily depoly filebeat to watch your log directory, and let it send all log to target logstash server.

## 1. Edit filebeat.yml to change host and port of target logstash server

## 2. build
```bash
docker build -t sherllo/filebeat:7.0.0 .
```

## 3. config log path of host to watch
```
// open docker-compose.yml and add volume like below, first one is log path of host
- "/Users/neversion/dev/ats/log:/usr/share/filebeat/hostlogs:ro"
```

## 4. start docker-compose
```bash
docker-compose up
```

# Tips 
## 1. Attach to container
- check container id
```bash
docker ps
```

- attach
```bash
docker exec -it container_id_xxxx /bin/bash
```

## 2. How can the container access host.
Use host.docker.internal as the host address. If your logstash server is running in the same host of filebeat, you can set the host name in filebeat.yml for filebeat container to use host's network.