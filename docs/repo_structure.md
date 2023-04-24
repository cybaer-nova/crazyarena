# Repository Structure

This repository consists of two Dockerfiles along with two scripts:

- **Dockerfile-base-cuda**: A dockerfile which installs the nvidia drivers on top of the base image;
- **Dockerfile**: A dockerfile which installs the **CrazyS**, **Crazyswarm** and **cfclient** packages;
- **run_crazyarena.bash**: A bash script to create the crazyarena docker container as well as to build the images needed.
- **rm_crazyarena.bash**: A bash script to remove the installation of the crazyarena docker container as well as to remove the images and volumes created.