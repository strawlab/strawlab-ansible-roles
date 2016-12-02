#!/bin/bash -x
set -o errexit

if [ "$ROS_ROOT" != "" ]; then
    echo "ERROR: cannot run within existing ROS environment"
    exit 1
fi

UNDERLAY="/opt/ros/kinetic"
VR_CATKIN_TARGET="$HOME/ros/freemoovr-kinetic-catkin"
VR_ROSBUILD_TARGET="$HOME/ros/freemoovr-kinetic-rosbuild"

source ${UNDERLAY}/setup.bash

# Initialize an empty catkin workspace in
# ${VR_CATKIN_TARGET}/.rosinstall . This sits on top of ${UNDERLAY}.
if [  ! -d ${VR_CATKIN_TARGET} ]; then
  # taken from http://wiki.ros.org/wstool
  mkdir -p ${VR_CATKIN_TARGET}
  cd ${VR_CATKIN_TARGET}
  wstool init src
  wstool merge -t src /etc/ros/freemoovr-engine-kinetic.rosinstall
  wstool merge -t src /etc/ros/flydra-kinetic-catkin.rosinstall
  wstool merge -t src /etc/ros/freemoovr-kinetic-catkin.rosinstall
  wstool update -t src
  catkin_make --pkg ros_flydra || echo 'OK' # we expect this to fail but we need it to initialize catkin workspace (install setup.bash)
else
  echo "The directory at ${VR_CATKIN_TARGET} already exists, doing nothing."
fi

# Initialize an empty rosbuild workspace in
# ${VR_ROSBUILD_TARGET}/.rosinstall . This is an overlay on
# ${VR_CATKIN_TARGET}
if [  ! -d ${VR_ROSBUILD_TARGET} ]; then
  # taken from http://wiki.ros.org/catkin/Tutorials/using_rosbuild_with_catkin
  mkdir -p ${VR_ROSBUILD_TARGET}
  cd ${VR_ROSBUILD_TARGET}
  rosws init . ${VR_CATKIN_TARGET}/devel
fi

cd ${VR_ROSBUILD_TARGET}
rosws merge /etc/ros/flydra-kinetic-rosbuild.rosinstall
rosws merge /etc/ros/freemoovr-kinetic-rosbuild.rosinstall
rosws update

#sudo rosdep init || echo 'rosdep already initialized'
rosdep update

source ${VR_ROSBUILD_TARGET}/setup.bash

# Make rosbuild packages
rosmake ros_fview_fmf_saver
rosmake motmot_ros_stack

# Make catkin packages
roscd freemoovr/../..
catkin_make
