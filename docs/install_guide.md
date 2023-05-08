# Installation Instructions

[![Docker](https://badges.aleen42.com/src/docker.svg)](https://docs.docker.com/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04LTS-brightgreen?style=flat)](https://releases.ubuntu.com/20.04/)
[![ROS](https://img.shields.io/badge/ROS-Noetic-brightgreen?style=flat)](http://wiki.ros.org/noetic)
[![CrazyS](https://img.shields.io/badge/CrazyS-7.0.1-brightgreen?style=flat)](https://github.com/gsilano/CrazyS)
[![CrazySwarm](https://img.shields.io/badge/Crazyswarm-1-brightgreen?style=flat)](https://github.com/USC-ACTLab/crazyswarm)

Start by cloning this repository.

```bash
git clone https://github.com/hardtekpt/crazyarena
cd crazyarena
```

A script is provided to install the crazyarena. The build flag ```-b``` can be used to build the image in adition to creating the container. This flag takes an argument regarding the base image to use. If you have an nvidia gpu then use the **cuda** image as it contains the nvidia drivers, otherwise use the **base** image.

!!! note

    When using the cuda image, it is necessary to install the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#setting-up-nvidia-container-toolkit) on the host machine. The NVIDIA Container Toolkit allows users to build and run GPU accelerated containers using container engines such as Docker.

```bash
./run_crazyarena.bash -b <base,cuda>
```

After the installation is complete it is possible to start the crazyarena container and open a shell inside. 

```bash
docker start crazyarena
docker exec -it crazyarena bash
```

Moreover both the CrazyS and Crazyswarm workspaces are available outside the container using docker volumes making it easy to edit files inside them. These volumes are mapped to the crazyarena repository folder.

The repository also includes a convenience script to remove the container, image and volumes from docker. 

!!! note

    If you are using this script as middle step to fix your installation don't forget to delete the catkin_ws and crazyswarm folders before installing again.

```bash
./rm_crazyarena.bash
```

!!! warning

    Make sure you only make changes to the contents of the volumes (catkin_ws and crazyswarm folders) while the container is running, otherwise the changes are not persistent and you may loose them.