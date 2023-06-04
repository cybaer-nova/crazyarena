# Installation Instructions

[![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04LTS-brightgreen?style=flat)](https://releases.ubuntu.com/20.04/)
[![ROS](https://img.shields.io/badge/ROS-Noetic-brightgreen?style=flat)](http://wiki.ros.org/noetic)
[![CrazyS](https://img.shields.io/badge/CrazyS-7.0.1-brightgreen?style=flat)](https://github.com/gsilano/CrazyS)
[![CrazySwarm](https://img.shields.io/badge/Crazyswarm-1-brightgreen?style=flat)](https://github.com/USC-ACTLab/crazyswarm)

Start by cloning this repository.

```bash
git clone https://github.com/hardtekpt/crazyarena
cd crazyarena
```

A script is provided to install the crazyarena. This script is responsible for building the docker image from the Dockerfile as well as creating the container from the built image. Additionally, it is possible to include the nvidia drivers in the image if you have an nvidia gpu. To do this select the **cuda** image, otherwise use the **base** image. To use the script, the flags ```-b``` and ```-c``` can be used to build the image and create the container respectively.

!!! note

    When using the cuda image, it is necessary to install the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#setting-up-nvidia-container-toolkit) on the host machine in addition to the specific graphics drivers for your gpu. The NVIDIA Container Toolkit allows users to build and run GPU accelerated containers using container engines such as Docker.

```bash
./run_crazyarena.bash -b <base,cuda> -c <base,cuda>
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