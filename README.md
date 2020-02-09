Personal dockers.
https://github.com/sherllochen/dockers.git
## Required to install Docker and Docker compose(for Ubuntu)
### 1. Docker installation
```bash
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
# Test the installation
sudo docker run hello-world
```

### 2. Docker compose installation
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
# Test the installation
sudo docker-compose --version
```

## Includes:
1. rails: full docker environment for rails dev&production.
2. elk_stack: ELK sever and filebeat(client).
2. hexo: hexo writing environment and deploy.
