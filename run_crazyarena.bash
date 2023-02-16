

if [[ $* == -b ]] || [[ $* == -bi ]]
then
    docker build -t crazyarena .
    mkdir catkin_ws
    docker volume create --driver local -o o=bind -o type=none -o device="$(pwd)/catkin_ws" crazyarena_catkin_ws_volume 
    mkdir crazyswarm
    docker volume create --driver local -o o=bind -o type=none -o device="$(pwd)/crazyswarm" crazyarena_crazyswarm_volume 
fi

xhost local:root
XAUTH=/tmp/.docker.xauth

docker run -i -d \
    --name=crazyarena \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    --volume="crazyarena_catkin_ws_volume:/home/crazyuser/catkin_ws:rw" \
    --volume="crazyarena_crazyswarm_volume:/home/crazyuser/crazyswarm:rw" \
    --net=host \
    --privileged \
    --user crazyuser \
    --workdir /home/crazyuser \
    crazyarena:latest \
    bash

if [[ $* == -i ]] || [[ $* == -bi ]]
then
    docker exec -w /home/crazyuser crazyarena bash -c "./install_crazyarena.bash"
fi


#--volume="$(pwd)/catkin_ws:/home/crazyuser/catkin_ws:rw" \