<!--Discovering variables: facts and magic variables-->
With Ansible you can retrieve or discover certain variables containing information about your remote systems or about Ansible itself. 
Variables related to remote systems are called facts. With facts, you can use the behavior or state of one system as a configuration on other systems. 
For example, you can use the IP address of one system as a configuration value on another system. Variables related to Ansible are called magic variables.

***Ansible facts***
Ansible facts are data related to your remote systems, including operating systems, IP addresses, attached filesystems, and more. 
You can access this data in the ansible_facts variable. By default, you can also access some Ansible facts as top-level variables with the ansible_ prefix. 
You can disable this behavior using the INJECT_FACTS_AS_VARS setting. To see all available facts, add this task to a play:

            - name: Print all available facts
              ansible.builtin.debug:
                var: ansible_facts

To see the ‘raw’ information as gathered, run this command at the command line:

            ansible <hostname> -m ansible.builtin.setup
            
Facts include a large amount of variable data, which may look like thosin facts.json file in this directory   

You can reference the model of the first disk in the facts shown above in a template or playbook as:

            {{ ansible_facts['devices']['xvda']['model'] }}

To reference the system hostname:

            {{ ansible_facts['nodename'] }}
            
***Package requirements for fact gathering***
On some distros, you may see missing fact values or facts set to default values because the packages that support gathering those facts are not installed by default. 
You can install the necessary packages on your remote hosts using the OS package manager. Known dependencies include:

- Linux Network fact gathering - Depends on the ip binary, commonly included in the iproute2 package.

***Disabling facts***
By default, Ansible gathers facts at the beginning of each play. If you do not need to gather facts (for example, if you know everything about your systems centrally), 
you can turn off fact gathering at the play level to improve scalability. Disabling facts may particularly improve performance in push mode with very large numbers of systems, 
or if you are using Ansible on experimental platforms. To disable fact gathering:

            - hosts: whatever
              gather_facts: false          
              
***Information about Ansible: magic variables***
You can access information about Ansible operations, including the Python version being used, the hosts and groups in inventory, 
and the directories for playbooks and roles, using “magic” variables. Like connection variables, magic variables are Special Variables. 
Magic variable names are reserved - do not set variables with these names. The variable environment is also reserved.

The most commonly used magic variables are hostvars, groups, group_names, and inventory_hostname. 
With hostvars, you can access variables defined for any host in the play, at any point in a playbook. 
You can access Ansible facts using the hostvars variable too, but only after you have gathered (or cached) facts. 
Note that variables defined at play objects are not defined for specific hosts and therefore are not mapped to hostvars.

If you want to configure your database server using the value of a ‘fact’ from another node, or the value of an inventory variable assigned to another node, 
you can use hostvars in a template or on an action line:

            {{ hostvars['test.example.com']['ansible_facts']['distribution'] }}

With groups, a list of all the groups (and hosts) in the inventory, you can enumerate all hosts within a group. For example:

            {% for host in groups['app_servers'] %}
               # something that applies to all app servers.
            {% endfor %}

You can use groups and hostvars together to find all the IP addresses in a group.

            {% for host in groups['app_servers'] %}
               {{ hostvars[host]['ansible_facts']['eth0']['ipv4']['address'] }}
            {% endfor %}

You can use this approach to point a frontend proxy server to all the hosts in your app servers group, to set up the correct firewall rules between servers, and so on. 
You must either cache facts or gather facts for those hosts before the task that fills out the template.

With group_names, a list (array) of all the groups the current host is in, you can create templated files that vary based on the group membership (or role) of the host:

            {% if 'webserver' in group_names %}
               # some part of a configuration file that only applies to webservers
            {% endif %}

You can use the magic variable inventory_hostname, the name of the host as configured in your inventory, as an alternative to ansible_hostname when fact-gathering is disabled. 
If you have a long FQDN, you can use inventory_hostname_short, which contains the part up to the first period, without the rest of the domain.

Other useful magic variables refer to the current play or playbook. These vars may be useful for filling out templates with multiple hostnames or for injecting the list into the rules for a load balancer.

        - ansible_play_hosts is the list of all hosts still active in the current play.
        
        - ansible_play_batch is a list of hostnames that are in scope for the current ‘batch’ of the play.

The batch size is defined by serial, when not set it is equivalent to the whole play (making it the same as ansible_play_hosts).

        - ansible_playbook_python is the path to the Python executable used to invoke the Ansible command line tool.
        
        - inventory_dir is the pathname of the directory holding Ansible’s inventory host file.
        
        - inventory_file is the pathname and the file name pointing to the Ansible’s inventory host file.
        
        - playbook_dir contains the playbook base directory.
        
        - role_path contains the current role’s pathname and only works inside a role.
        
        - ansible_check_mode is a boolean, set to True if you run Ansible with --check.

***Ansible version***
New in version 1.8.

To adapt playbook behavior to different versions of Ansible, you can use the variable ansible_version, which has the following structure:

        {
            "ansible_version": {
                "full": "2.10.1",
                "major": 2,
                "minor": 10,
                "revision": 1,
                "string": "2.10.1"
            }
        }              