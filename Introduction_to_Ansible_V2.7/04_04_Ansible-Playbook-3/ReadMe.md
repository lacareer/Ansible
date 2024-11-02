<!-- MAKE SURE YOU ARE IN THE PARENT DIRECTORY BEFORE RUNNING ANY OF THE ANSIBLE COMMAND ON THE COMMAND LINE -->

<!-- BEFORE RUUNING THE COMMAND BELOW MAKE SURE THE AWS EC2 INSTANCES ARE IN RUNNING MODE -->
# Discovering variables: facts and magic variables: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html

# https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#ansible-variable-precedence

# Reference for handlers: https://docs.ansible.com/ansible/latest/user_guide/playbooks_handlers.html

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

# By state=latest (Note that 'state' can be either 'present', 'install', 'latest', and 'absent' or 'remove') we want Ansible to

# By become: true in yum-update.yml playbook, we want Ansible to run the command as a root user (sudo). Without it the command below will fail and create a 'retry' file named using the syntax playbookFileName.retry. In this case it will be 'yum-update.retry'. You can set ansible not to save this file or to do so in a specific location usingthe ansible.cfg file

# To set Ansible not to save the 'retry' file we add the below to the 'ansible.cfg' file

    retry_files_enabled = False

# on the webservers and loadbalancers remote servers to get the latest packages using the command:

    ansible-playbook playbooks/yum-update.yml

# There are different states for packages updates and may include:

# 'present' = checks to see if it is present

# 'install' = installs it if not installed

# 'remove' = removes the package if installed

# 'absent' = removes the package if installed

Note that the following playbook files are same as the previous chapter, 04-03, but for the 'handler' line and the 'notify: restart apache' that has been added to setup-app.yml and setup-lb.yml . This lines make sure that a named service, in this case restart apache (which restarts Apache), only runs if changes are detected

Notes for install-services.yml

# On the loadbalancer remote server this playbook uses root authorization (become: true) and yum to install Apache (httpd), make sure it is present, starts it, and enabled it (name=httpd state=started enabled=yes), i.e start httpd with each rebook and start of the server.

# Does exactly the same for the webservers with the addition of installing PHP also on them

# To install all the servives in the playbook, run:

    ansible-playbook playbooks/install-services.yml

# After running the above command, navigate to the ip address of each remote server on the browser and see the default Apache home page

Notes for setup-app.yml

# 1. Essentially,

        - hosts: webservers
            become: true
            tasks:
            - name: Upload application file
                copy:
                src: ../index.php
                dest: /var/www/html
                mode: 0755

# the above uses root access to copy the index.php file in the parent directory to the var/ww/html directory of the installed Apache aand giver the webservers the required permission for 0755 for users, groups and others

# Now if you paste the ip address of one of your wwebserver, the index.php page is displayed

# 2. Now remove the 'php' on line 1 in <?php (should be just <?) and now if you paste the ip address of one of your wwebserver, the index.php page is displayed but it is broken becuase PHP does not permit short_open_tag, <?.

# To change the PHP configuration to accomodate short_open_tag, we will read and write to a single line using the lineinfile module of Ansible ashown below:

        - name: Configure php.ini file
            lineinfile:
                path: /etc/php.ini
                regexp: ^short_open_tag
                line: 'short_open_tag=On'
            notify: restart apache

        - name: restart apache
            service: name=httpd state=restarted

# What the lineinfile does is:

    path: path of the file you want to read and write to

    regexp: uses the wildcard, ^, symbol to search for the line that  starts with short_open_tag

    line: what to write on the line in a file. In this case set 'short_open_tag=on'

Notes for config/lb-config.j2

# # This Jinja2 uses configuration for the load balancer is dynamic as it looks through the webserver array/group to get the the ip address of each as shown below. In {{hostvars[hosts]['ansible_host']}} concern yourself with only 'host' as this refers to the webserver group discovered by Ansible when it runs - 'hostvars' and 'ansible_host' are generated at run time by Ansible

    ProxyRequests off

    <Proxy balancer://webcluster >
    {% for hosts in groups['webservers'] %}
        BalancerMember http://{{hostvars[hosts]['ansible_host']}}
    {% endfor %}

        ProxySet lbmethod=byrequests

    </Proxy>

    # Optional
    <Location /balancer-manager>
    SetHandler balancer-manager
    </Location>

    ProxyPass /balancer-manager !

# The optional part of the code above above makes it takes advantage of Apache to display load sharing information of the webservers when the loadbalancer redirect traffic to them. To see this page, in your browser, paste:

    loadbalancerIpAdress/balancer-manager

# To run the playbook:

    ansible-playbook playbooks/setup-app.yml

# And if you change this line the the file 'line: 'short_open_tag=On' to 'line: 'short_open_tag=Off' the '/etc/php.ini' changes and Apache will restart if you run the playbook again. But if nothing changes in the ' /etc/php.ini ' Apache will mot restart because of the thsi line notify: restart apache

Notes for setup-lb.yml

# Our load balancer receives request and proxy it to one of the two webservers

# It does so by coping our dynamic load balancer file, lb-config_dynamicallyTheBest.j2, from our local machine source to the a specific location, /etc/httpd/conf.d/lb.conf, in our Apache remote server

# Now run:

    ansible-playbook playbooks/setup-lb.yml

# If no error is returned, it means our load balancer is now configured correctly and all request received by the load balancer will be proxied either of the two webservers

# Remember that we did not copy the index.php to the loadbalancer server. But if we got to the loadbalancer server on the browser, paste the loadbalancer ip in the browser, you would see the index.ph being page being served. Thanks to the proxy setup in config/lb-config_dynamicallyTheBest.j2

Notes for all-playbooks.yml

# Runs all the playbooks in the order list in this file

     ansible-playbook playbooks/all-playbooks.yml

Notes for check-status.yml

# Checks for the status of Apache whether it is running or not using the 'command' instruction, run:

    ansible-playbook playbooks/check-status.yml

# To stop Apache on the loadbalancers server run below which runs as a root user:

    ansible -m service -a "name=httpd state=stopped" --become loadbalancers

# Now if you rerun the check-status.yml playbook and you would see that Apache is now stopped. Restart Apache by run:

    ansible -m service -a "name=httpd state=started" --become loadbalancers

# Now if you rerun the check-status.yml playbook and you would see that Apache is now running.
