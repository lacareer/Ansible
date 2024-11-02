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

# 2. Move the keypair to the .ssh folder:

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
