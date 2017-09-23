#!/bin/bash -x
set -o errexit

if [ `which python` != "/usr/bin/python" ]; then
  # I have had trouble if Anaconda Python is on the
  # PATH and so here we check for that and abort early if so.
  echo "ERROR: not using system Python, aborting installation"
  exit 1
else
  echo "Using /usr/bin/python"
fi

if [ "$ROS_ROOT" != "" ]; then
    echo "ERROR: cannot run within existing ROS environment"
    exit 1
fi

UNDERLAY="/opt/ros/kinetic"
FLYDRA_CATKIN_TARGET="$HOME/ros/flydra-kinetic"

source ${UNDERLAY}/setup.bash

# Initialize an empty catkin workspace in
# ${FLYDRA_CATKIN_TARGET}/.rosinstall . This sits on top of ${UNDERLAY}.
if [  ! -d ${FLYDRA_CATKIN_TARGET} ]; then
  # taken from http://wiki.ros.org/wstool
  mkdir -p ${FLYDRA_CATKIN_TARGET}
  cd ${FLYDRA_CATKIN_TARGET}
  wstool init src
  wstool merge -t src /etc/ros/flydra-kinetic.rosinstall
  wstool update -t src
  catkin_make --pkg ros_flydra || echo 'OK' # we expect this to fail but we need it to initialize catkin workspace (install setup.bash)

  rosdep update
  source devel/setup.bash
  rosdep install --default-yes --from-paths src --ignore-src

  catkin_make
else
  echo "The directory at ${FLYDRA_CATKIN_TARGET} already exists, doing nothing."
fi
