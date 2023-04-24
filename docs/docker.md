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

The repository also includes a convenience script to remove the container, image and volumes from docker. 

> **Note** 
> If you are using this script as middle step to fix your installation don't forget to delete the catkin_ws and crazyswarm folders before installing again.

```bash
./rm_crazyarena.bash
```

> **Warning**
> Make sure you only make changes to the contents of the volumes (catkin_ws and crazyswarm folders) while the container is running, otherwise the changes are not persistent and you will loose them.