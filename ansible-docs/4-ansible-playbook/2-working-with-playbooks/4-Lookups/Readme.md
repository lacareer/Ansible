<!--Lookups-->
Lookup plugins retrieve data from outside sources such as files, databases, key/value stores, APIs, and other services. 
Like all templating, lookups execute and are evaluated on the Ansible control machine. 
Ansible makes the data returned by a lookup plugin available using the standard templating system. 
Before Ansible 2.5, lookups were mostly used indirectly in with_<lookup> constructs for looping. 
Starting with Ansible 2.5, lookups are used more explicitly as part of Jinja2 expressions fed into the loop keyword.

***Using lookups in variables***
You can populate variables using lookups. Ansible evaluates the value each time it is executed in a task (or template).

    vars:
      motd_value: "{{ lookup('file', '/etc/motd') }}"
    tasks:
      - debug:
          msg: "motd value is {{ motd_value }}"
          
For more details and a list of lookup plugins in ansible-core, see Working with plugins. 
You may also find lookup plugins in collections. You can review a list of lookup plugins 
installed on your control machine with the command:

    ansible-doc -l -t lookup.          