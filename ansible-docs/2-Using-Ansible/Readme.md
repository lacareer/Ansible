<!--NOTE THAT THIS FILES ARE BASICALLY FOR NOTE TAKING. NO commands was ran as the host do not exist-->

The simplest inventory is a single file with a list of hosts and groups. 
The default location for this file is /etc/ansible/hosts. 
You can specify a different inventory file at the command line using the -i <path> option or in configuration using inventory.

Ansible Inventory plugins supports a range of formats and sources to make your inventory flexible and customizable. 
As your inventory expands, you may need more than a single file to organize your hosts and groups. 
Here are three options beyond the /etc/ansible/hosts file:

You can create a directory with multiple inventory files. See Organizing inventory in a directory. 
These can use different formats (YAML, ini, and so on).

You can pull inventory dynamically. 
For example, you can use a dynamic inventory plugin to list resources in one or more cloud providers. See Working with dynamic inventory.

You can use multiple sources for inventory, including both dynamic inventory and static files. 
See Passing multiple inventory sources.

