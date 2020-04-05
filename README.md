# strawlab-ansible-roles - recipes to install strawlab software

Tested on Ubuntu xenial (16.04) amd64.

# Installation

To install prerequisites:

    sudo apt-get install git ansible

Clone the strawlab-ansible-roles repository into your local drive. We recommend:

    cd ~/
    git clone https://github.com/strawlab/strawlab-ansible-roles.git

To run the playbook (installs flydra and freemovr):

    cd strawlab-ansible-roles/
    sudo ansible-playbook -i "localhost," -c local playbook.yml

This may take more than one hour to complete, aborting will result in errors.
Sometimes running this command will return an error which may be due to events
on a remote server. If this happens - try again later.

After the installation is complete, you can remove the strawlab-ansible-roles folder:

    rm -rf ~/strawlab-ansible-roles/

# Now, to create a ROS workspace for FreemoVR

Do this as a normal user

    /opt/ros/workspace-installers/kinetic/make-freemovr-workspace.sh

Now you should have new directories in `~/ros` with everything installed.
The top-level workspace is at `~/ros/freemovr-kinetic`.
You can initiate your ROS environment with

    source ~/ros/freemovr-kinetic/devel/setup.bash

NOTE: You have to initiate your ROS environment with the above command every time
you open a new terminal window otherwise you will get an error when trying
to start Flydra or FreemoVR.

After this, you can run Flydra and FreemoVR commands such as

    roslaunch freemovr_engine demo_display_server.launch

OPTIONAL: You can shorten `~/ros/freemovr-kinetic/devel/setup.bash` command
by adding an alias in your home directory. For example:

    cd ~/
    echo "source ~/ros/freemovr-kinetic/devel/setup.bash" >> myros

This will allow you to initiate the ROS environment using a shorter command:

    source myros

# License

The files in this repository are licensed under the BSD 3-clause license. See
`LICENSE.txt` for more information.
