<!-- MAKE SURE YOU ARE IN THE CURRENT DIRECTORY BEFORE RUNNING ANY OF THE ANSIBLE COMMAND ON THE COMMAND LINE -->

<!-- BEFORE RUUNING THE COMMAND BELOW MAKE SURE THE AWS EC2 INSTANCES ARE IN RUNNING MODE -->

# hosts-dev is an Ansible inventory file created by the me. I will have to tell Ansible where to locate this file. Alternatively, you can configure the the ansible 'vi /etc/ansible/hosts' file(where you can now add the hosts as shown in hosts-dev file) so Ansible automatically locates this file without you specifying it

# Before creating this file run:

    ansible --list-host all

# which returns an error saying the provided host list is empty.

# Now after creating this list run the same above command with the '-i' (inventory) flag and inventory file name and the list, with the IP addresses, of all the servers but the local host is returned. The line 'control ansible_connection=local' in the inventory file is telling ansible not to ssh into the local host. If you want to ssh into the local host, remove this line.

# MAKE SURE TO BE IN THE DIRECTORY OF THE hosts-dev file on the command line before running the command below

     ansible -i hosts-dev --list-host all
