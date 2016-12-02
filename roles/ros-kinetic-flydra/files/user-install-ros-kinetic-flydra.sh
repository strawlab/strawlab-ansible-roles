#!/bin/bash -x
set -o errexit

if [ "$ROS_ROOT" != "" ]; then
    echo "ERROR: cannot run within existing ROS environment"
    exit 1
fi

export UNDERLAY="/opt/ros/kinetic"
export FLYDRA_CATKIN_TARGET="$HOME/ros/flydra-kinetic"
export FLYDRA_ROSBUILD_TARGET="$HOME/ros/flydra-kinetic-rosbuild"

source ${UNDERLAY}/setup.bash

# Initialize an empty catkin workspace in
# ${FLYDRA_CATKIN_TARGET}/.rosinstall . This sits on top of ${UNDERLAY}.
if [  ! -d ${FLYDRA_CATKIN_TARGET} ]; then
  # taken from http://wiki.ros.org/wstool
  mkdir -p ${FLYDRA_CATKIN_TARGET}
  cd ${FLYDRA_CATKIN_TARGET}
  wstool init src
  wstool merge -t src /etc/ros/flydra-kinetic-catkin.rosinstall
  wstool update -t src
  catkin_make --pkg ros_flydra || echo 'OK' # we expect this to fail but we need it to initialize catkin workspace (install setup.bash)
else
  echo "The directory at ${FLYDRA_CATKIN_TARGET} already exists, doing nothing."
fi

# Initialize an empty rosbuild workspace in
# ${FLYDRA_ROSBUILD_TARGET}/.rosinstall . This is an overlay on
# ${FLYDRA_CATKIN_TARGET}
if [  ! -d ${FLYDRA_ROSBUILD_TARGET} ]; then
  # taken from http://wiki.ros.org/catkin/Tutorials/using_rosbuild_with_catkin
  mkdir -p ${FLYDRA_ROSBUILD_TARGET}
  cd ${FLYDRA_ROSBUILD_TARGET}
  rosws init . ${FLYDRA_CATKIN_TARGET}/devel
fi

cd ${FLYDRA_ROSBUILD_TARGET}
rosws merge /etc/ros/flydra-kinetic-rosbuild.rosinstall
rosws update

#sudo rosdep init || echo 'rosdep already initialized'
rosdep update

source ${FLYDRA_ROSBUILD_TARGET}/setup.bash

# Make rosbuild packages
rosmake ros_fview_fmf_saver
rosmake motmot_ros_stack

# Make catkin packages
roscd ros_flydra/../..
catkin_make
