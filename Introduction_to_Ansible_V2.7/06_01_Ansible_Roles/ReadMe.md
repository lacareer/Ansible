<!-- MAKE SURE YOU ARE IN THE PARENT DIRECTORY BEFORE RUNNING ANY OF THE ANSIBLE COMMAND ON THE COMMAND LINE -->

<!-- BEFORE RUUNING THE COMMAND BELOW MAKE SURE THE AWS EC2 INSTANCES ARE IN RUNNING MODE -->

# References on Ansible roles: https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html

# Ansible galaxy for creating roles: https://galaxy.ansible.com/

Ansible has a predefined folder structure for roles. These folders includes: default(contains default variables), files(contains the required files like the index.php in our case), handlers, meta, task(contains all the task for the role in main.yml), tests, and vars(contains other variables) folders.

# To create a webserver role in the 06-01 folder, run the command below. We have already copied the index.php, host-dev and ansible-cfg files into the directory:

    ansible-galaxy role roles/webserver init

# Note that the setup-app.yml has now being changed to use roles. All variable have been moved into the variabale folder, all task into the task folder, and all handlers into the handlers folder.

# The setup-app.yml only has the the below to call the roles and run the playbook

    ---
    - hosts: webservers
        become: true
        roles:
        - webservers

# Now run the playbook with:

    ansible-playbook setup-app.yml

# Anisble is going to call the webserver role and and run all the task using the files, variable etc.
