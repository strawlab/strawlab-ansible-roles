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
VR_CATKIN_TARGET="$HOME/ros/freemovr-kinetic"

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
  wstool merge -t src /etc/ros/freemovr-engine-kinetic.rosinstall
  wstool merge -t src /etc/ros/flydra-kinetic.rosinstall
  wstool merge -t src /etc/ros/freemovr-kinetic.rosinstall
  wstool update -t src

  # `catkin_make` is installed with the `ros-kinetic-catkin` package.
  # `source ${UNDERLAY}/setup.bash` puts this on the PATH. (Do not
  # install from the Ubuntu `catkin` package.)
  catkin_make --pkg freemovr_engine || echo 'OK' # we expect this to fail but we need it to initialize catkin workspace (install setup.bash)
  rosdep update
  catkin_make
  source devel/setup.bash
else
  echo "The directory at ${VR_CATKIN_TARGET} already exists, doing nothing."
fi
