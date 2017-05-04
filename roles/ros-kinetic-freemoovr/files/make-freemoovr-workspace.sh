#!/bin/bash -x
set -o errexit

if [ "$ROS_ROOT" != "" ]; then
    echo "ERROR: cannot run within existing ROS environment"
    exit 1
fi

UNDERLAY="/opt/ros/kinetic"
VR_CATKIN_TARGET="$HOME/ros/freemoovr-kinetic"

source ${UNDERLAY}/setup.bash
CATKIN_MAKE_PATH=$(which catkin_make)
if [ "$CATKIN_MAKE_PATH" == "" ]; then
    echo "ERROR: cannot find catkin_make"
    exit 1
fi

# Initialize an empty catkin workspace in
# ${VR_CATKIN_TARGET}/.rosinstall . This sits on top of ${UNDERLAY}.
if [  ! -d ${VR_CATKIN_TARGET} ]; then
  # taken from http://wiki.ros.org/wstool
  mkdir -p ${VR_CATKIN_TARGET}
  cd ${VR_CATKIN_TARGET}
  wstool init src
  wstool merge -t src /etc/ros/freemoovr-engine-kinetic.rosinstall
  wstool merge -t src /etc/ros/flydra-kinetic.rosinstall
  wstool merge -t src /etc/ros/freemoovr-kinetic.rosinstall
  wstool update -t src

  # `catkin_make` is installed with the `ros-kinetic-catkin` package.
  # `source ${UNDERLAY}/setup.bash` puts this on the PATH. (Do not
  # install from the Ubuntu `catkin` package.)
  catkin_make --pkg freemoovr_engine || echo 'OK' # we expect this to fail but we need it to initialize catkin workspace (install setup.bash)
  rosdep update
  catkin_make
  source devel/setup.bash
else
  echo "The directory at ${VR_CATKIN_TARGET} already exists, doing nothing."
fi
