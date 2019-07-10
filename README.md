# Docker image for regression testing

docker run --rm -ti --network=host -v `pwd`:`pwd` -w `pwd` luckyraul/docker-regression:latest codecept run

