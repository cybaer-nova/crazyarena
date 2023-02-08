

if [[ $* == -b ]] || [[ $* == -bi ]]
then
    docker build -t crazyarena .
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
    --volume="$(pwd):/crazyarena" \
    --net=host \
    --privileged \
    crazyarena:latest \
    bash

if [[ $* == -i ]] || [[ $* == -bi ]]
then
    docker exec -w /crazyarena crazyarena bash -c "./install_crazyarena.bash"
fi