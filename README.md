# strawlab-ansible-roles - recipes to install strawlab software

Tested on Ubuntu xenial (16.04) amd64.

# Installation

To install prerequisites:

    sudo apt-get install ansible

To run the playbook (installs flydra and freemovr):

    sudo ansible-playbook -i "localhost," -c local playbook.yml

# Now, to create a ROS workspace for FreemoVR

    # Do this as a normal user
    /opt/ros/workspace-installers/kinetic/make-freemovr-workspace.sh

    # Now you should have new directories in `~/ros` with everything installed.
    # The top-level workspace is at `~/ros/freemovr-kinetic`.
    # You can initiate your ROS environment with
    source ~/ros/freemovr-kinetic/devel/setup.bash

    # After this, you can run commands such as
    roslaunch freemovr_engine demo_display_server.launch
