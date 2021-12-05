1. Install laravel sail and create a new app with name of "app-name".
```shell
curl -s https://laravel.build/app-name | bash
```
Once got message of "Application ready! Build something amazing.
Sail scaffolding installed successfully.", the installation is done.

2. If developing a existed application, install dependencies of existed application.
```shell
cd app-name
docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v $(pwd):/var/www/html \
    -w /var/www/html \
    laravelsail/php80-composer:latest \
    composer install --ignore-platform-reqs
```

3. Use mirrors to speed up installation within GFW.(optional)
```shell
cd app-name
vim docker-compose.yml
#insert before apt-update
RUN  sed -i s@/ports.ubuntu.com/@/mirrors.tuna.tsinghua.edu.cn/@g /etc/apt/sources.list
RUN  sed -i s@/security.ubuntu.com/@/mirrors.tuna.tsinghua.edu.cn@g /etc/apt/sources.list
RUN  apt-get clean
npm config set registry https://registry.npm.taobao.org
```

4. Navigate into app-name and run sail, actually run 'docker-compose up'.
```shell
cd app-name && ./vendor/bin/sail up
```

