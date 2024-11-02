<!--NOTE THAT THE ansible.cfg CONTAINS THE SETTINGS FOR CONNECTION TO YOUR AWS EC2 INSTANCES-->

<!-- MAKE SURE YOU ARE IN THE CURRENT DIRECTORY BEFORE RUNNING ANY OF THE ANSIBLE COMMAND ON THE COMMAND LINE -->

<!-- BEFORE RUUNING THE COMMAND BELOW MAKE SURE THE AWS EC2 INSTANCES ARE IN RUNNING MODE -->

<!--HERE WE USE TWO INVENTORY FILES hosts-dev  nad inventory.ini. You can use anyone to test -->


Work through this documentation with hands-on practice to fully understand Ansible

# Reference for Ansible Variables: https://docs.ansible.com/ansible/latest/user_guide/playbooks_vars_facts.html

# Before beginning the set up below ensure the folowing depending on your machine - Linux is easier and used here:

    Make sure Python(python3) and pip(pip3) are installed on the control/local machine.
    Use python3 --version and pip3 --version to check for Python and Pip respectively on Linux systems
    Install python-boto and python-boto3 if you intend to use anisble with AWS using pip 
    (pip3 install botocore, pip3 install boto, and pip3 install boto3). Make sure to use 'pip3' for the installation of botocore, boto or boto3 and not just 'pip'

# Once Python or Pip is installed, then proceed to install Ansible:

    sudo pip install ansible

# 1. Create a keypair on AWS

# 2. Move the keypair (DOWNLOADED WHEN YOU CREATED AN EC2 INSTANCE KEYPAIR ON AWS) to the .ssh folder:

    mv ~/Downloads/keypairName.pem ~/.ssh

                    OR

    In /etc/ansible/ansible.cfg add the path by uncommenting the private_key_file line
        private_key_file = /mnt/c/Users/coguk/downloads/ansiblekey.pem

# 3. Change the read permission on the keypair file:

    chmod 400 ~/.ssh/keypairname.pem

# 4. Create an AWS stack using the setup-env.yml file

<!-- BEFORE RUUNING THE COMMAND BELOW MAKE SURE THE AWS EC2 INSTANCES ARE IN RUNNING MODE -->

# 5. SSH into one/all of the instance created by the stack:

    ssh -i ~/.ssh/keypairName.pem ec2-user@ec2intanceIpAddress

# if ssh was successful, it opens the command line of each server when do. This is a confirmation that set up is good to go
# make sure the Security group of the EC2 instances allow ingress from your control node or vpc cidr if uou are using cloud9


# hosts-dev is an Ansible inventory file created by the me. I will have to tell Ansible where to locate this file. 
Alternatively, you can configure the the ansible 'vi /etc/ansible/hosts' file(where you can now add the hosts as shown in hosts-dev/inventory.ini file) 
So Ansible automatically locates this file without you specifying it

# Before creating this file run:

    ansible --list-host all

# which returns an error saying the provided host list is empty.

# Even after the file is created, it still returns thesame error because the inventory flag, -i, was not passed

# Now after creating this list run the same above command with the '-i' (inventory) flag and inventory file name and the list, with the IP addresses, of all the servers but the local host is returned. The line 'control ansible_connection=local' in the inventory file is telling ansible not to ssh into the local host. If you want to ssh into the local host, remove this line.

# MAKE SURE TO BE IN THE DIRECTORY OF THE hosts-dev (no extention required) or inventory-1.ini 0r inventory.yaml (note that the inventory file aside can have .ini or yaml extention) file on the command line before running any of the command below

    ansible -i hosts-dev --list-host all
     
    ansible -i inventory-1.ini --list-host all
    
    ansible -i inventory-2.yaml --list-host all

    ansible-inventory -i hosts-dev --list
    
    ansible-inventory -i inventory-1.ini --list
    
    ansible-inventory -i inventory-2.yaml --list
    
    ansible --list-host all
    
<!--Note that the inventory-3.yaml is not used but used to show node/server groupings using the shown syntax. The above commands work as well for it.
Why not try it out:  ansible-inventory -i inventory-3.yaml --list
-->
    
# TO BE ABLE TO PING THE HOST IN THE INVENTORY LIST DO BELOW

  Add the ansible.cfg file with the settings to connect to the EC2 instances using the private stored in ~/.ssh directory
  The ansible.cfg makes it possible to add your inventory list by just importing the file/ssh
  This allows you to run ansible commands without passing the inventory to use, as shown below.
  
# E.g Try pinging the server now (Make sure the instances are up and running) and make sure to enter "yes" if prompted
( like this: "Are you sure you want to continue connecting (yes/no)? [WARNING]:" )
  
    ansible myhosts -m ping (pings only the node "myhosts" in the inventory list)
  
    ansible -m ping all (pings all host in the inventory)
  
<!---->
    
