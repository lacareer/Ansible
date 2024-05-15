<!-- MAKE SURE YOU ARE IN THE PARENT DIRECTORY BEFORE RUNNING ANY OF THE ANSIBLE COMMAND ON THE COMMAND LINE -->

<!-- BEFORE RUUNING THE COMMAND BELOW MAKE SURE THE AWS EC2 INSTANCES ARE IN RUNNING MODE -->

# Reference for Ansible Varobales: https://docs.ansible.com/ansible/latest/user_guide/playbooks_vars_facts.html

# To see all metadata, in json format, gathered by Ansible that could be used as a variable for each server or group of servers run any of the below from any directory:

    ansible -m setup app1
    ansible -m setup app2
    ansible -m setup lb1
    ansible -m setup webservers
    ansible -m setup loadbalancers

Notes on setup-app.yml (default variables)

# Now that we can see some metadata for each remote server, we can create a variable with it. This file is same as in the previous lab, 05_01, but with this new line that makes use of Ansible 'path_to_app' self-created variable and default variable called 'ansible_hostname'.

    vars:
    path_to_app: "/var/www/html"

    - name: Upload application file
      copy:
        src: ../index.php
        dest: "{{ path_to_app }}"
        mode: 0755

    - name: Create simple info page
        copy:
          dest: /var/www/html/info.php
          content: "<h1> Info about our webserver {{ ansible_hostname }} </h1>"

# Other default variable could include stuff like shown below that is in the metadata command above

    "{{hostvars['serverAlias OR name']['localhost]['ansible_default_ipv4']['address']}}"

    Other magic variables will are groups, group_name, and inventory_hostname

# Now run

    ansible-playbook playbooks/setup-app.yml

# On your browser paste loadbalancerIpAddress/info.php and you will the the content of the html copied to info.php displayed. Each time you refresh the page the IP address changes between the two webservers
