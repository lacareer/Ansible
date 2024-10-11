<!--Ansible CLI cheatsheet-->

This page shows one or more examples of each Ansible command line utility with some common flags added and a link to the full documentation for the command. 
This page offers a quick reminder of some common use cases only - it may be out of date or incomplete or both. For canonical documentation, follow the links to the CLI pages.

- ansible-playbook

- ansible-galaxy

    * Installing collections
    
    * Installing roles

- ansible

    * Running ad-hoc commands

- ansible-doc


<!--ansible-playbook-->

        ansible-playbook -i /path/to/my_inventory_file -u my_connection_user -k -f 3 -T 30 -t my_tag -M /path/to/my_modules -b -K my_playbook.yml
        
Loads my_playbook.yml from the current working directory and:

-i - uses my_inventory_file in the path provided for inventory to match the pattern.

-u - connects over SSH as my_connection_user.

-k - asks for password which is then provided to SSH authentication.

-f - allocates 3 forks.

-T - sets a 30-second timeout.

-t - runs only tasks marked with the tag my_tag.

-M - loads local modules from /path/to/my/modules.

-b - executes with elevated privileges (uses become).

-K - prompts the user for the become password.      

See ansible-playbook (https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html#ansible-playbook) for detailed documentation.


<!--ansible-galaxy-->

*** Install a single collection:

    ansible-galaxy collection install mynamespace.mycollection
    
Downloads mynamespace.mycollection from the configured Galaxy server (galaxy.ansible.com by default).

*** Install a list of collections:

    ansible-galaxy collection install -r requirements.yml
    
Downloads the list of collections specified in the requirements.yml file.

*** List all installed collections:

    ansible-galaxy collection list    
    
<!--Installing roles-->

*** Install a role named example.role:  

    ansible-galaxy role install example.role

    # SNIPPED_OUTPUT
    - extracting example.role to /home/user/.ansible/roles/example.role
    - example.role was installed successfully
    
*** List all installed roles:

    ansible-galaxy role list
    
    
See ansible-galaxy (https://docs.ansible.com/ansible/latest/cli/ansible-galaxy.html#ansible-galaxy) for detailed documentation.


<!--ansible-->

Running ad-hoc commands


*** Install a package

    ansible localhost -m ansible.builtin.apt -a "name=apache2 state=present" -b -K
    
Runs ansible localhost- on your local system. 
- "name=apache2 state=present" installs the apache2 package on a Debian-based system. 
-b - uses become to execute with elevated privileges. 
-m - specifies a module name. 
-K - prompts for the privilege escalation password.


    localhost | SUCCESS => {
    "cache_update_time": 1709959287,
    "cache_updated": false,
    "changed": false
    #...
    
<!--ansible-doc-->
Show plugin names and their source files:

    ansible-doc -F
    #...