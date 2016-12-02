FROM ubuntu:xenial

# build with
#   sudo docker build -t vr-installr .
# run with
#   sudo docker run -it --name vr-test -v `pwd`:/ansible:ro vr-installr

RUN apt-get update
RUN apt-get upgrade --yes

RUN apt-get install --yes ansible

VOLUME /ansible

CMD ansible-playbook -i "localhost," -c local /ansible/playbook.yml
