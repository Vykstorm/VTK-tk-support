
OUTPUT_DIR=.
DOCKER_IMAGE_NAME=vtk_tk_support
docker build . -t $DOCKER_IMAGE_NAME
docker run vtk_tk_support
DOCKER_CONTAINER=$(docker ps -l -q)
docker cp $DOCKER_CONTAINER:/dist ./
docker rm $DOCKER_CONTAINER
echo "Succesfully created wheels for vtk! ( check dist/ subdirectory )"
ls dist
