You can apply variables to parent groups (nested groups or groups of groups) as well as to child groups. 

The syntax is the same: :vars for INI format and vars: for YAML format

A child group’s variables will have higher precedence (override) than a parent group’s variables.

Organizing host


<!--Organizing host and group variables-->
Although you can store variables in the main inventory file, storing separate host and group variables files may help you organize your variable values more easily. 

You can also use lists and hash data in host and group variables files, which you cannot do in your main inventory file.

Host and group variable files must use YAML syntax. 

Valid file extensions include ‘.yml’, ‘.yaml’, ‘.json’, or no file extension. See YAML Syntax if you are new to YAML.

Ansible loads host and group variable files by searching paths relative to the inventory file or the playbook file. 

If your inventory file at /etc/ansible/hosts contains a host named ‘foosball’ that belongs to two groups, ‘raleigh’ and ‘webservers’, that host will use variables in YAML files at the following locations:

<!---->

/etc/ansible/group_vars/raleigh # can optionally end in '.yml', '.yaml', or '.json'

/etc/ansible/group_vars/webservers

/etc/ansible/host_vars/foosball

<!---->

For example, if you group hosts in your inventory by datacenter, and each datacenter uses its own NTP server and database server, 

you can create a file called /etc/ansible/group_vars/raleigh to store the variables for the raleigh group:

<!---->

ntp_server: acme.example.org
database_server: storage.example.org

<!---->

You can also create directories named after your groups or hosts. Ansible will read all the files in these directories in lexicographical order. 

An example with the ‘raleigh’ group:

<!---->

/etc/ansible/group_vars/raleigh/db_settings
/etc/ansible/group_vars/raleigh/cluster_settings

<!---->

An example with the ‘raleigh’ (alias i suppose) host:

<!---->

/etc/ansible/host_vars/raleigh/db_settings
/etc/ansible/host_vars/raleigh/cluster_settings

<!---->



All hosts in the ‘raleigh’ group will have the variables defined in these files available to them. 

This can be very useful to keep your variables organized when a single file gets too big, or when you want to use Ansible Vault on some group variables.

For ansible-playbook you can also add group_vars/ and host_vars/ directories to your playbook directory. 

Other Ansible commands (for example, ansible, ansible-console, and so on) will only look for group_vars/ and host_vars/ in the inventory directory. 

If you want other commands to load group and host variables from a playbook directory, you must provide the --playbook-dir option on the command line. 

If you load inventory files from both the playbook directory and the inventory directory, variables in the playbook directory will override variables set in the inventory directory.

Keeping your inventory file and variables in a git repo (or other version control) is an excellent way to track changes to your inventory and host variables.
