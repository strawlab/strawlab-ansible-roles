# strawlab-ansible-roles - recipes to install strawlab software

[![build](https://github.com/strawlab/strawlab-ansible-roles/workflows/build/badge.svg?branch=master)](https://github.com/strawlab/strawlab-ansible-roles/actions?query=branch%3Amaster)

Tested on Ubuntu focal (20.04) amd64.

# Installation

To install prerequisites:

    sudo apt-get install git ansible

Clone the strawlab-ansible-roles repository into your local drive. We recommend:

    cd ~/
    git clone https://github.com/strawlab/strawlab-ansible-roles.git

To run the playbook (installs flydra and freemovr):

    cd strawlab-ansible-roles/
    sudo ansible-playbook -i "localhost," -c local playbook-focal.yml

This may take more than one hour to complete, aborting will result in errors.
Sometimes running this command will return an error which may be due to events
on a remote server. If this happens - try again later.

After the installation is complete, you can remove the strawlab-ansible-roles folder:

    rm -rf ~/strawlab-ansible-roles/

# Now, to create a ROS workspace for FreemoVR Engine

Do this as a normal user

    /opt/ros/workspace-installers/noetic/make-freemovr-engine-workspace.sh

Now you should have new directories in `~/ros` with everything installed.
The top-level workspace is at `~/freemovr-engine-noetic`.
You can initiate your ROS environment with

    source ~/ros/freemovr-engine-noetic/devel/setup.bash

NOTE: You have to initiate your ROS environment with the above command every time
you open a new terminal window otherwise you will get an error when trying
to start Flydra or FreemoVR.

After this, you can run Flydra and FreemoVR commands such as

    roslaunch freemovr_engine demo_display_server.launch

# Testing these recipes

On Linux with bash:

```
docker build -t strawlab-focal --file Dockerfile.focal .
docker run -it -v `pwd`:/ansible:ro strawlab-focal
```

On Windows with powershell:

```
docker build -t strawlab-focal --file Dockerfile.focal .
docker run -it -v ${PWD}:/ansible:ro strawlab-focal
```

# License

The files in this repository are licensed under the BSD 3-clause license. See
`LICENSE.txt` for more information.
