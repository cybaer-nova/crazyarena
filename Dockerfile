FROM osrf/ros:noetic-desktop-full

RUN apt-get update
RUN apt-get install -y git && apt-get install -y python3-pip && apt-get install -y nano && apt-get install -y curl

RUN apt-get install -y ros-noetic-joy ros-noetic-octomap-ros ros-noetic-mavlink
RUN apt-get install -y ros-noetic-octomap-mapping ros-noetic-control-toolbox
RUN apt-get install -y python3-vcstool python3-catkin-tools protobuf-compiler libgoogle-glog-dev
RUN rosdep update
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN apt-get install python3-rosdep python3-wstool ros-noetic-ros libgoogle-glog-dev
