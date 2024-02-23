docker stop crazyarena
docker rm crazyarena

docker image rm crazyarena
docker image rm base-cuda

docker volume rm crazyarena_datalogs_volume
docker volume rm crazyarena_catkin_ws_volume
docker volume rm crazyarena_crazyswarm_volume
