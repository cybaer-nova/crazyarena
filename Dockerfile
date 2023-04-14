# Dockerfile for the crazyflie flying arena 

# Start from the osrf ros image
FROM osrf/ros:noetic-desktop-full

# NVIDIA 
ENV NVARCH x86_64

ENV NVIDIA_REQUIRE_CUDA "cuda>=12.1 brand=tesla,driver>=450,driver<451 brand=tesla,driver>=470,driver<471 brand=unknown,driver>=470,driver<471 brand=nvidia,driver>=470,driver<471 brand=nvidiartx,driver>=470,driver<471 brand=geforce,driver>=470,driver<471 brand=geforcertx,driver>=470,driver<471 brand=quadro,driver>=470,driver<471 brand=quadrortx,driver>=470,driver<471 brand=titan,driver>=470,driver<471 brand=titanrtx,driver>=470,driver<471 brand=tesla,driver>=510,driver<511 brand=unknown,driver>=510,driver<511 brand=nvidia,driver>=510,driver<511 brand=nvidiartx,driver>=510,driver<511 brand=geforce,driver>=510,driver<511 brand=geforcertx,driver>=510,driver<511 brand=quadro,driver>=510,driver<511 brand=quadrortx,driver>=510,driver<511 brand=titan,driver>=510,driver<511 brand=titanrtx,driver>=510,driver<511 brand=tesla,driver>=515,driver<516 brand=unknown,driver>=515,driver<516 brand=nvidia,driver>=515,driver<516 brand=nvidiartx,driver>=515,driver<516 brand=geforce,driver>=515,driver<516 brand=geforcertx,driver>=515,driver<516 brand=quadro,driver>=515,driver<516 brand=quadrortx,driver>=515,driver<516 brand=titan,driver>=515,driver<516 brand=titanrtx,driver>=515,driver<516 brand=tesla,driver>=525,driver<526 brand=unknown,driver>=525,driver<526 brand=nvidia,driver>=525,driver<526 brand=nvidiartx,driver>=525,driver<526 brand=geforce,driver>=525,driver<526 brand=geforcertx,driver>=525,driver<526 brand=quadro,driver>=525,driver<526 brand=quadrortx,driver>=525,driver<526 brand=titan,driver>=525,driver<526 brand=titanrtx,driver>=525,driver<526"
ENV NV_CUDA_CUDART_VERSION 12.1.55-1
ENV NV_CUDA_COMPAT_PACKAGE cuda-compat-12-1

ARG TARGETARCH

LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH}/3bf863cc.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH} /" > /etc/apt/sources.list.d/cuda.list && \
    apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 12.1.0

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-12-1=${NV_CUDA_CUDART_VERSION} \
    ${NV_CUDA_COMPAT_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

#COPY NGC-DL-CONTAINER-LICENSE /

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility


# Setup a user 
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/crazyuser && \
    echo "crazyuser:x:${uid}:${gid}:crazyuser,,,:/home/crazyuser:/bin/bash" >> /etc/passwd && \
    echo "crazyuser:x:${uid}:" >> /etc/group && \
    echo "crazyuser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/crazyuser && \
    chmod 0440 /etc/sudoers.d/crazyuser && \
    chown ${uid}:${gid} -R /home/crazyuser

# Install useful packages
RUN apt-get update
RUN apt-get install -y git && apt-get install -y python3-pip && apt-get install -y nano && apt-get install -y curl

# Install cfclient
RUN apt-get install -y libxcb-xinerama0
RUN pip3 install "PyQt5-sip==12.9.0"
RUN pip3 install "PyQt5==5.15.0"
RUN pip3 install -v cfclient
#RUN yes | pip3 install --no-input --force-reinstall -v "cfclient==2022.12"

# Install CrazyS dependencies
RUN apt-get install -y ros-noetic-joy ros-noetic-octomap-ros ros-noetic-mavlink
RUN apt-get install -y ros-noetic-octomap-mapping ros-noetic-control-toolbox
RUN apt-get install -y python3-vcstool python3-catkin-tools protobuf-compiler libgoogle-glog-dev

USER crazyuser
RUN rosdep update
USER root
#RUN apt-get install python3-rosdep 
RUN apt-get install python3-wstool 
RUN apt-get install ros-noetic-ros 
RUN apt-get install libgoogle-glog-dev

ENV HOME /home/crazyuser
ENV USER crazyuser
USER crazyuser

SHELL ["/bin/bash", "-c"] 

# Setup a workspace and install CrazyS packages
RUN source /opt/ros/noetic/setup.bash && \
    mkdir -p /home/crazyuser/catkin_ws/src && \
    cd /home/crazyuser/catkin_ws/src && \
    catkin_init_workspace && \
    cd /home/crazyuser/catkin_ws/ && \
    catkin init && \
    cd /home/crazyuser/catkin_ws/src && \
    git clone -b dev/ros-noetic https://github.com/gsilano/CrazyS.git && \
    git clone -b med18_gazebo9 https://github.com/gsilano/mav_comm.git

USER root

RUN cd /home/crazyuser/catkin_ws/ && \
    rosdep install --from-paths src -i -r -y

USER crazyuser

RUN source /opt/ros/noetic/setup.bash && \
    cd /home/crazyuser/catkin_ws/ && \
    rosdep update && \
    catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -DCATKIN_ENABLE_TESTING=False &&\
    catkin build

RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc && \
    echo "source /home/crazyuser/catkin_ws/devel/setup.bash" >> ~/.bashrc

# Fix to a known issue with gazebo and CrazyS
RUN cd /home/crazyuser/catkin_ws/ && \
    cp build/rotors_gazebo_plugins/libmav_msgs.so devel/lib/

# Crazyswarm installation
ENV CSW_PYTHON="python3"

USER root

RUN apt-get install -y ros-noetic-tf ros-noetic-tf-conversions ros-noetic-joy && \
    apt-get install -y libpcl-dev libusb-1.0-0-dev && \
    apt-get install -y swig lib${CSW_PYTHON}-dev ${CSW_PYTHON}-pip && \
    ${CSW_PYTHON} -m pip install numpy --upgrade && \
    ${CSW_PYTHON} -m pip install pytest PyYAML scipy && \
    apt-get install -y python3-tk


RUN ${CSW_PYTHON} -m pip install vispy

USER crazyuser
WORKDIR /home/crazyuser

RUN git clone https://github.com/USC-ACTLab/crazyswarm.git

RUN source /opt/ros/noetic/setup.bash && \
    cd crazyswarm && \
    ./build.sh

# Verify the installation by running the unit tests
# RUN cd crazyswarm/ros_ws/src/crazyswarm/scripts && \
#     source ../../../devel/setup.bash && \
#     $CSW_PYTHON -m pytest

# Make the workspace visible outside the container
VOLUME /home/crazyuser/catkin_ws
VOLUME /home/crazyuser/crazyswarm