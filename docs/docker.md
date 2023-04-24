# Dealing with docker containers

If for some reason you need to stop or start the container the following commands might be helpful.

```bash
docker stop crazyarena
docker start crazyarena
```

If you need privileged access to the container you can open a new shell with the root user:

```bash
docker exec -it -u root crazyarena bash
```

