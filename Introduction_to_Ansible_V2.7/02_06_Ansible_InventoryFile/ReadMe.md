<!-- MAKE SURE YOU ARE IN THE CURRENT DIRECTORY BEFORE RUNNING ANY OF THE ANSIBLE COMMAND ON THE COMMAND LINE -->

<!-- BEFORE RUUNING THE COMMAND BELOW MAKE SURE THE AWS EC2 INSTANCES ARE IN RUNNING MODE -->

# hosts-dev is an Ansible inventory file created by the me. I will have to tell Ansible where to locate this file. 
Alternatively, you can configure the the ansible host in 'vi /etc/ansible/hosts' file(where you can now add the hosts as shown in hosts-dev/inventory.ini file) 
So Ansible automatically locates this file without you specifying it

# Before creating this file run:

    ansible --list-host all

# which returns an error saying the provided host list is empty.

# Create an inventory file like host-dev or inventory.ini (you can name you inventory anything you like. But we will stick to host-dev from subsequent lessons)

# Even after the file is created, it still returns the same error because the inventory flag, -i, was not passed

# Now after creating this list run the same above command with the '-i' (inventory) flag and inventory file name and the list, with the IP addresses, of all the servers but the local host is returned. The line 'control ansible_connection=local' in the inventory file is telling ansible not to ssh into the local host. If you want to ssh into the local host, remove this line.

# MAKE SURE TO BE IN THE DIRECTORY OF THE root file on the command line before running any of the command below which list all your avaible host

    ansible -i hosts-dev --list-host all (List the host in shorthand format)
     
    ansible-inventory -i hosts-dev --list (List all host with more host data than the previous command)
    

  
<!---->
