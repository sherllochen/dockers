## Build
```
docker build -t sherllo/hexo-client .
```

## RUN
```
docker run -v /host_path:/opt/hexo -p 4000:4000 -it sherllo/hexo
```

## TIPS
- Local preview will be exposed on 4000 port.(http://localhost:4000)
