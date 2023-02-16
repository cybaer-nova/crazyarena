# Crazyarena Repository

This repository makes use of the CrazyS and Crazyswarm packages to provide a starting point for running simulations and real experiments using one or more Crazyflies. The crazyarena repository makes use of docker to simplify the installation procedure.

### Prerequesites

Make sure you have docker properly installed before continuing, official instalation instructions are available [here](https://docs.docker.com/get-docker/). It is also recommended that you visit the documentation for [CrazyS](https://github.com/gsilano/CrazyS/wiki) and [Crazyswarm](https://crazyswarm.readthedocs.io/en/latest/index.html) 
### Installation Instructions

Start by cloning this repository.

```bash
git clone https://github.com/hardtekpt/crazyarena
cd crazyarena
```

Run the script to build the image and start the crazyarena. The ```-b``` flag is only necessary for the first time you start the crazyarena.

```bash
./run_crazyarena.bash -b
```

After the installation is complete it is possible to open a shell inside the crazyarena container. 

```bash
docker exec -it crazyarena bash
```

Moreover both the CrazyS and Crazyswarm workspaces are available outside the container using docker volumes making it easy to edit files inside them.

> **Warning**
> Make sure you only make changes to the contents of the volumes (catkin_ws and crazyswarm folders) while the container is running, otherwise the changes are not persistent and you will loose them.

