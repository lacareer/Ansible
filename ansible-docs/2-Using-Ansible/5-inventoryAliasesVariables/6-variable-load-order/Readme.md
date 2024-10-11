<!--Managing inventory variable load order-->

When using multiple inventory sources, keep in mind that any variable conflicts are resolved according to the rules described in How variables are merged and Variable precedence: Where should I put a variable?. 

You can control the merging order of variables in inventory sources to get the variable value you need.

When you pass multiple inventory sources at the command line, Ansible merges variables in the order you pass those parameters. 

If [all:vars] in staging inventory defines myvar = 1 and production inventory defines myvar = 2, then:

- Pass -i staging -i production to run the playbook with myvar = 2.

- Pass -i production -i staging to run the playbook with myvar = 1.


When you put multiple inventory sources in a directory, Ansible merges them in ASCII order according to the file names. 

You can control the load order by adding prefixes to the files:

<!---->
inventory/
  01-openstack.yml          # configure inventory plugin to get hosts from Openstack cloud
  02-dynamic-inventory.py   # add additional hosts with dynamic inventory script
  03-static-inventory       # add static hosts
  group_vars/
    all.yml                 # assign variables to all hosts
<!---->

If 01-openstack.yml defines myvar = 1 for the group all, 02-dynamic-inventory.py defines myvar = 2, and 03-static-inventory defines myvar = 3, the playbook will be run with myvar = 3.