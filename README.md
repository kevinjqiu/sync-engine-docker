sync-engine-docker
==================

This repo contains Dockerfile and docker-compose file to run [Nylas' sync-engine](https://github.com/nylas/sync-engine) on your own server.

Remove past volumes
-------------------

Use `docker volume` command to show the volume names

    $ docker volume ls
    DRIVER              VOLUME NAME
    local               d4a1487efa55554c2c0841de39e0c85e8bc124feda7c7608a03f70e6b67ca102
    local               syncenginedocker_db1_data
    local               syncenginedocker_db2_data
    local               syncenginedocker_inbox_data

`docker volume rm` the ones no longer needed
