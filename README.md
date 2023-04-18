# Crazyarena Repository

This repository makes use of the **CrazyS** and **Crazyswarm** packages as well as the **cfclient** to provide a starting point for running simulations and real experiments using one or more Crazyflies. The crazyarena repository makes use of docker to simplify the installation procedure.

### Prerequesites

Make sure you have docker properly installed before continuing, official instalation instructions are available [here](https://docs.docker.com/get-docker/). It is also recommended that you visit the documentation for [CrazyS](https://github.com/gsilano/CrazyS/wiki) and [Crazyswarm](https://crazyswarm.readthedocs.io/en/latest/index.html).
### Installation Instructions

Start by cloning this repository.

```bash
git clone https://github.com/hardtekpt/crazyarena
cd crazyarena
```

A script is provided to install the crazyarena. The build flag ```-b``` can be used to build the image in adition to creating the container. This flag takes an argument regarding the base image to use. If you have an nvidia gpu then use the **cuda** image as it contains the nvidia drivers, otherwise use the **base** image.

```bash
./run_crazyarena.bash -b <base,cuda>
```

After the installation is complete it is possible to start the crazyarena container and open a shell inside. 

```bash
docker start crazyarena
docker exec -it crazyarena bash
```

Moreover both the CrazyS and Crazyswarm workspaces are available outside the container using docker volumes making it easy to edit files inside them.

### Dealing with docker containers

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

---

> **Note** 
> If you encouter the issue *ModuleNotFoundError: No module named 'crazyswarm'* while running a real experiment using the crazyswarm package, add these lines in the begining of the *crazyflie.py* file.

```python
# /home/crazyuser/crazyswarm/ros_ws/src/crazyswarm/scripts/pycrazyswarm/crazyflie.py

from os.path import dirname, abspath
sys.path.insert(0, dirname(dirname(dirname(abspath(__file__)))))
```
