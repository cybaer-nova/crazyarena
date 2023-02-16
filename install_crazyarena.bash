echo "Inside Container"

source /opt/ros/noetic/setup.bash

mkdir -p /home/crazyuser/catkin_ws/src
cd /home/crazyuser/catkin_ws/src
catkin_init_workspace
cd /home/crazyuser/catkin_ws/
catkin init
cd /home/crazyuser/catkin_ws/src
git clone -b dev/ros-noetic https://github.com/gsilano/CrazyS.git
git clone -b med18_gazebo9 https://github.com/gsilano/mav_comm.git
cd /home/crazyuser/catkin_ws/

rosdep install --from-paths src -i -r -y
rosdep update
catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -DCATKIN_ENABLE_TESTING=False
catkin build

echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
echo "source /home/crazyuser/catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

cp build/rotors_gazebo_plugins/libmav_msgs.so devel/lib/

echo "Installation Complete"
