echo "Inside Container"

source /opt/ros/noetic/setup.bash

mkdir -p /crazyarena/catkin_ws/src
cd /crazyarena/catkin_ws/src
catkin_init_workspace
cd /crazyarena/catkin_ws/
catkin init
cd /crazyarena/catkin_ws/src
git clone -b dev/ros-noetic https://github.com/gsilano/CrazyS.git
git clone -b med18_gazebo9 https://github.com/gsilano/mav_comm.git
cd /crazyarena/catkin_ws/

rosdep install --from-paths src -i -r -y
rosdep update
catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -DCATKIN_ENABLE_TESTING=False
catkin build

echo "source /crazyarena/catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

cp build/rotors_gazebo_plugins/libmav_msgs.so devel/lib/

echo "Installation Complete"