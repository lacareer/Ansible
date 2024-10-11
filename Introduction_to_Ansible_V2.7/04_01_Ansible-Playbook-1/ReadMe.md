<!-- MAKE SURE YOU ARE IN THE PARENT DIRECTORY, 04_01_Ansible_Playbook-1, BEFORE RUNNING ANY OF THE ANSIBLE COMMAND ON THE COMMAND LINE -->

<!-- BEFORE RUUNING THE COMMAND BELOW MAKE SURE THE AWS EC2 INSTANCES ARE IN RUNNING MODE -->

Notes for ping.yml playbook

# This play when ran pings 'all' the servers listed on the inventory file hosts-dev. To run the playbook, run the command:

    ansible-playbook playbooks/ping.yml

# If ping was successful, an OK with server aliases are returned

Notes for uname.yml playbook

# Gets the uname, OS, of the webservers and the loadbalancer using the ansible 'shell'. To run the playbook, run the command:

    ansible-playbook playbooks/uname.yml

# The above command command is same as when you run the command below although the former does not output the OS name like the command below:

     ansible -m shell -a "uname" webservers:loadbalancers

Notes for yum-update.yml playbook

# This playbook runs a yum (there are different kind of packages like 'yum' for Mac, 'apt' for Ubuntu etc.) package update

# (in this case all yum packages as indicated by "'name' equals ' asterik'") with the latest version on webservers:loadbalancers

# By state=latest (Note that 'state' can be either 'present', 'install', 'latest', and 'absent' or 'remove') we want Ansible to install

# By become: true in yum-update.yml playbook, we want Ansible to run the command as a root user (sudo). Without it the command below will fail and create a 'retry' file named using the syntax playbookFileName.retry. In this case it will be 'yum-update.retry'. You can set ansible not to save this file or to do so in a specific location using the ansible.cfg file

# To set Ansible not to save the 'retry' file we add the below to the 'ansible.cfg' file

    retry_files_enabled = False

# on the webservers and loadbalancers remote servers to get the latest packages using the command:

    ansible-playbook playbooks/yum-update.yml

# There are different states for packages updates and may include:

# 'present' = checks to see if it is present

# 'install' = installs it if not installed

# 'remove' = removes the package if installed

# 'absent' = removes the package if installed


Whether to install (present or installed, latest), or remove (absent or removed) a package.

"present" and "installed" will simply ensure that a desired package is installed.

"latest" will update the specified package if it’s not of the latest available version.

"absent" and "removed" will remove the specified package.

Default is None, however in effect the default action is present unless the autoremove option is enabled for this module, then absent is inferred.

Choices:

    "absent"
    
    "installed"
    
    "latest"
    
    "present"
    
    "removed"
