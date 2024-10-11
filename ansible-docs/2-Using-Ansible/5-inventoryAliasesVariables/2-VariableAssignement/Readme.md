<!--Defining variables in INI format-->
Values passed in the INI format using the key=value syntax are interpreted differently depending on where they are declared:

1. When declared inline with the host, INI values are interpreted as Python literal structures (strings, numbers, tuples, lists, dicts, booleans, None). 
Host lines accept multiple key=value parameters per line. Therefore they need a way to indicate that a space is part of a value rather than a separator. 
Values that contain whitespace can be quoted (single or double). See the Python shlex parsing rules for details.

2. When declared in a :vars section, INI values are interpreted as strings. For example var=FALSE would create a string equal to ‘FALSE’. 
Unlike host lines, :vars sections accept only a single entry per line, so everything after the = must be the value for the entry.

If a variable value set in an INI inventory must be a certain type (for example, a string or a boolean value), always specify the type with a filter in your task. 
Do not rely on types set in INI inventories when consuming variables.

Consider using YAML format for inventory sources to avoid confusion on the actual type of a variable. 
The YAML inventory plugin processes variable values consistently and correctly.


<!--Assigning a variable to many machines: group variables-->
If all hosts in a group share a variable value, you can apply that variable to an entire group at once.

<!--In INI:-->

[atlanta]
host1
host2

[atlanta:vars]
ntp_server=ntp.atlanta.example.com
proxy=proxy.atlanta.example.com

<!--In YAML:-->

atlanta:
  hosts:
    host1:
    host2:
  vars:
    ntp_server: ntp.atlanta.example.com
    proxy: proxy.atlanta.example.com
    
<!--Variable merging-->
Group variables are a convenient way to apply variables to multiple hosts at once. 
Before executing, however, Ansible always flattens variables, including inventory variables, to the host level. If a host is a member of multiple groups, Ansible reads variable values from all of those groups. 
If you assign different values to the same variable in different groups, Ansible chooses which value to use based on internal rules for merging (https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#how-we-merge).

