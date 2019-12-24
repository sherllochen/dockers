## Build
```
docker build -t sherllo/hexo-client .
```

## Run container
```
docker run -v /host_path:/opt/hexo -p 4000:4000 -it sherllo/hexo-client
```

## Init
```
hexo init blog_name
```

## Deploy to github pages with travis ci
Copy .travis.yml to root path of hexo. There must two branch, hexo-source and master.
hexo-source is used as source branch(default) and generated static files will be in master branch. Because Github pages only can build from master branch. 
