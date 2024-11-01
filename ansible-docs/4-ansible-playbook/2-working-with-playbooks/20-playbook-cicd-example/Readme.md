<!--Site deployment-->
Let’s start with site.yml. This is our site-wide deployment playbook. It can be used to initially deploy the site, as well as push updates to all of the servers:

            ---
            # This playbook deploys the whole application stack in this site.
            
            # Apply common configuration to all hosts
            - hosts: all
            
              roles:
              - common
            
            # Configure and deploy database servers.
            - hosts: dbservers
            
              roles:
              - db
            
            # Configure and deploy the web servers. Note that we include two roles
            # here, the 'base-apache' role which simply sets up Apache, and 'web'
            # which includes our example web application.
            
            - hosts: webservers
            
              roles:
              - base-apache
              - web
            
            # Configure and deploy the load balancer(s).
            - hosts: lbservers
            
              roles:
              - haproxy
            
            # Configure and deploy the Nagios monitoring node(s).
            - hosts: monitoring
            
              roles:
              - base-apache
              - nagios
 
Note: If you’re not familiar with terms like playbooks and plays, you should review Working with playbooks.

In this playbook we have 5 plays. The first one targets all hosts and applies the common role to all of the hosts. This is for site-wide things like yum repository configuration, firewall configuration, 
and anything else that needs to apply to all of the servers.

The next four plays run against specific host groups and apply specific roles to those servers. Along with the roles for Nagios monitoring, the database, and the web application, we’ve implemented a 
base-apache role that installs and configures a basic Apache setup. This is used by both the sample web application and the Nagios hosts.

***Reusable content: roles***
By now you should have a bit of understanding about roles and how they work in Ansible. Roles are a way to organize content: tasks, handlers, templates, and files, into reusable components.

This example has six roles: common, base-apache, db, haproxy, nagios, and web. How you organize your roles is up to you and your application, but most sites will have one or more common roles 
that are applied to all systems, and then a series of application-specific roles that install and configure particular parts of the site.

Roles can have variables and dependencies, and you can pass in parameters to roles to modify their behavior. You can read more about roles in the Roles section.

***Configuration: group variables***
hey are stored in a directory called group_vars in the same location as your inventory. Here is lamp_haproxy’s group_vars/all file. As you might expect, these variables are applied to all of the machines in your inventory:

            ---
            httpd_port: 80
            ntpserver: 192.0.2.23

This is a YAML file, and you can create lists and dictionaries for more complex variable structures. In this case, we are just setting two variables, one for the port for the web server, 
and one for the NTP server that our machines should use for time synchronization.

Here’s another group variables file. This is group_vars/dbservers which applies to the hosts in the dbservers group:

            ---
            mysqlservice: mysqld
            mysql_port: 3306
            dbuser: root
            dbname: foodb
            upassword: usersecret

If you look in the example, there are group variables for the webservers group and the lbservers group, similarly.

These variables are used in a variety of places. You can use them in playbooks, like this, in roles/db/tasks/main.yml:

            - name: Create Application Database
              mysql_db:
                name: "{{ dbname }}"
                state: present
            
            - name: Create Application DB User
              mysql_user:
                name: "{{ dbuser }}"
                password: "{{ upassword }}"
                priv: "*.*:ALL"
                host: '%'
                state: present

You can also use these variables in templates, like this, in roles/common/templates/ntp.conf.j2:

            driftfile /var/lib/ntp/drift
            
            restrict 127.0.0.1
            restrict -6 ::1
            
            server {{ ntpserver }}
            
            includefile /etc/ntp/crypto/pw
            
            keys /etc/ntp/keys
            
You can see that the variable substitution syntax of {{ and }} is the same for both templates and variables. The syntax inside the curly braces is Jinja2, and you can do all sorts of operations and apply different filters to the data inside. 
In templates, you can also use for loops and if statements to handle more complex situations, like this, in roles/common/templates/iptables.j2:

        {% if inventory_hostname in groups['dbservers'] %}
        -A INPUT -p tcp  --dport 3306 -j  ACCEPT
        {% endif %}

This is testing to see if the inventory name of the machine we’re currently operating on (inventory_hostname) exists in the inventory group dbservers. If so, that machine will get an iptables ACCEPT line for port 3306.

Here’s another example, from the same template:

        {% for host in groups['monitoring'] %}
        -A INPUT -p tcp -s {{ hostvars[host].ansible_default_ipv4.address }} --dport 5666 -j ACCEPT
        {% endfor %}

This loops over all of the hosts in the group called monitoring, and adds an ACCEPT line for each monitoring hosts’ default IPv4 address to the current machine’s iptables configuration, so that Nagios can monitor those hosts.

You can learn a lot more about Jinja2 and its capabilities here, and you can read more about Ansible variables in general in the Using Variables section.       

***The rolling upgrade***
Now you have a fully-deployed site with web servers, a load balancer, and monitoring. How do you update it?

Looking at the playbook, you can see it is made up of two plays. The first play is very simple and looks like this:

        - hosts: monitoring
          tasks: []

What’s going on here, and why are there no tasks? You might know that Ansible gathers “facts” from the servers before operating upon them. 
These facts are useful for all sorts of things: networking information, OS/distribution versions, and so on. 
In our case, we need to know something about all of the monitoring servers in our environment before we perform the update, 
so this simple play forces a fact-gathering step on our monitoring servers. You will see this pattern sometimes, and it is a useful trick to know.

The next part is the update play. The first part looks like this:

        - hosts: webservers
          user: root
          serial: 1
          
This is just a normal play definition, operating on the webservers group. The serial keyword tells Ansible how many servers to operate on at once. 
If it is not specified, Ansible will parallelize these operations up to the default “forks” limit specified in the configuration file. 
But for a zero-downtime rolling upgrade, you may not want to operate on that many hosts at once. If you had just a handful of webservers, you may want to set serial to 1, for one host at a time. 
If you have 100, maybe you could set serial to 10, for ten at a time.

Here is the next part of the update play:

            pre_tasks:
            - name: disable nagios alerts for this host webserver service
              nagios:
                action: disable_alerts
                host: "{{ inventory_hostname }}"
                services: webserver
              delegate_to: "{{ item }}"
              loop: "{{ groups.monitoring }}"
            
            - name: disable the server in haproxy
              shell: echo "disable server myapplb/{{ inventory_hostname }}" | socat stdio /var/lib/haproxy/stats
              delegate_to: "{{ item }}"
              loop: "{{ groups.lbservers }}"  
              
The pre_tasks keyword just lets you list tasks to run before the roles are called. This will make more sense in a minute. If you look at the names of these tasks, 
you can see that we are disabling Nagios alerts and then removing the webserver that we are currently updating from the HAProxy load balancing pool.

The delegate_to and loop arguments, used together, cause Ansible to loop over each monitoring server and load balancer, and perform that operation (delegate that operation) 
on the monitoring or load balancing server, “on behalf” of the webserver. In programming terms, the outer loop is the list of web servers, and the inner loop is the list of monitoring servers.

Note that the HAProxy step looks a little complicated. We’re using HAProxy in this example because it is freely available, though if you have (for example) an F5 or Netscaler 
in your infrastructure (or maybe you have an AWS Elastic IP setup?), you can use Ansible modules to communicate with them instead. 
You might also wish to use other monitoring modules instead of nagios, but this just shows the main goal of the ‘pre tasks’ section – take the server out of monitoring, and take it out of rotation.

The next step simply re-applies the proper roles to the web servers. This will cause any configuration management declarations in web and base-apache roles to be applied to the web servers, including an update of the web application code itself. 
We don’t have to do it this way–we could instead just purely update the web application, but this is a good example of how roles can be used to reuse tasks:

            roles:
            - common
            - base-apache
            - web

Finally, in the post_tasks section, we reverse the changes to the Nagios configuration and put the web server back in the load balancing pool:

            post_tasks:
            - name: Enable the server in haproxy
              shell: echo "enable server myapplb/{{ inventory_hostname }}" | socat stdio /var/lib/haproxy/stats
              delegate_to: "{{ item }}"
              loop: "{{ groups.lbservers }}"
            
            - name: re-enable nagios alerts
              nagios:
                action: enable_alerts
                host: "{{ inventory_hostname }}"
                services: webserver
              delegate_to: "{{ item }}"
              loop: "{{ groups.monitoring }}"
              
Again, if you were using a Netscaler or F5 or Elastic Load Balancer, you would just substitute in the appropriate modules instead.

