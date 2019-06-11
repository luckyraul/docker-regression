# Docker image for regression testing

docker run --rm -ti --network=host -v $(pwd):/root/test luckyraul/docker-regression:latest
