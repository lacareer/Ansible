<!-- MAKE SURE YOU ARE IN THE PARENT DIRECTORY BEFORE RUNNING ANY OF THE ANSIBLE COMMAND ON THE COMMAND LINE -->

<!-- BEFORE RUUNING THE COMMAND BELOW MAKE SURE THE AWS EC2 INSTANCES ARE IN RUNNING MODE -->

# Reference for Ansible Varobales: https://docs.ansible.com/ansible/latest/user_guide/playbooks_vars_facts.html

Notes on setup-app.yml (default variables)

# This file is same as in the previous lab, 05_02, but uses the 'register' and 'debug' module as show below

    - name: See directory contents
        command: ls -la {{ path_to_app }}
        register: dir_contents

    - name: Debug directory contents
        debug:
        msg: "{{ dir_contents }}"

# "command: ls -la {{ path_to_app }} ": List all files and directory in the variable path ("/var/www/html") and 'registers' them to the 'dir_contents' variable

# "debug": used to print out content to standard output, command line in this case, the 'msg' variable for viewing. The 'debug' module is great for troubleshooting on the command line

# "msg": a variable that holds the content the content of 'dir_content'
