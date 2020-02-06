## How to use
1. Allow income ports: 5044(for Logstash,highly recommend to open specific ips).
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

5. Most simpliest authorization, use nginx to set username and password.

```
// /etc/nginx/default
// Example config file.
server {
  listen 80;
  listen [::]:80;

  server_name your.elk.domain;

  location / {
    root /opt/kibana;
    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/site_pass;  # file for username/password storage.
    proxy_set_header Host $host:5601;
    proxy_set_header X-Real-Ip $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://localhost:5601;
    proxy_set_header Via "nginx";
  }
}
```

The site_pass is generage by htpasswd.

```bash
sudo htpasswd -b -c site_pass your_username your_password
```


6. RUN~
```bash
sudo docker-compose up
```

7. All things done. Kibana will be avaiable in http://your.elk.domain

## Tips:
- logstash-beats-output.conf is used to override 02-beats-input.conf in container.
- elasticsearch data will be persisted in elasticsearch_data directory of host.

## todo
- config logstash to parser message field?
