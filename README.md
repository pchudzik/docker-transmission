# Docker image for transmission torrent client

How to build:
```docker build --build-arg UID=`id -u` --build-arg GUID=`id -g` -t transmission .```

To run:
```docker run --name transmission -dit -v `pwd`/watch:/watch -v `pwd`/info:/info -v `pwd`/logs:/logs -v `pwd`/downloads:/downloads -v `pwd`/incomplete:/incomplete -p 9091:9091 transmission```

To stop:
```docker stop transmission```

To resume:
```docker start transmission```
