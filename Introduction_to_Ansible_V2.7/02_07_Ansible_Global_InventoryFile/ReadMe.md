<!-- MAKE SURE YOU ARE IN THE CURRENT DIRECTORY BEFORE RUNNING ANY OF THE ANSIBLE COMMAND ON THE COMMAND LINE -->

<!-- BEFORE RUUNING THE COMMAND BELOW MAKE SURE THE AWS EC2 INSTANCES ARE IN RUNNING MODE -->

# Setting up 'ansible.cfg'

# Ansible will look for this file, ansible.cfg, in the following order

# 1. ANSIBLE_CONFIG (an environment variable if set)

# 2. ansible.cfg (the current directory)

# 3. ~/.ansible.cfg (in the home directory)

# 4. /etc/ansible/ansible.cfg (in this path)

# Note that: 'inventory = ./hosts-dev' means override any other ansible command or use this file hosts-dev in the currentory as the inventory file. This means that we do not need to specify the file name when trying to ssh into the remote servers.

# Also we have added aliases to the servers like so: aliasName ansible_host=IP_addressOfServer

# Now run the below to ssh into all the remote servers

    ansible --list-host all (returns app1, app2, lb1, local node [control])

    ansible --list-host "*" (usings ansible patterns and returns app1, app2, lb1, local node [control])

    ansible --list-host webservers:loadbalancers (usings ansible patterns and returns app1, app2, lb1)

    ansible --list-host \!control (usings ansible patterns and returns app1, app2, lb1 but not the 'control' local host. The \! is used to escape the ! used)

# To ssh into the webservers only, run:

    ansible --list-host webservers (returns app1, app2)

    ansible --list-host app* (usings ansible patterns and returns app1, app2)

    ansible --list-host webservers[0] (usings ansible patterns and returns app1)

    ansible --list-host webservers[1] (usings ansible patterns and returns app2)

# To ssh into the loadbalancer only, run:

    ansible --list-host loadbalancers (returns lb1)

    ansible --list-host lb* (usings ansible patterns and returns lb1)

    ansible --list-host loadbalancers[0] (usings ansible patterns and returns lb1)
