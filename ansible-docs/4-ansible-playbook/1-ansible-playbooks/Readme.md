<!--Playbook-->
Ansible Playbooks offer a repeatable, reusable, simple configuration management and multi-machine deployment system, 
one that is well suited to deploying complex applications. 
If you need to execute a task with Ansible more than once, write a playbook and put it under source control. 
Then you can use the playbook to push out new configuration or confirm the configuration of remote systems.

Playbooks can:

- declare configurations

- orchestrate steps of any manual ordered process, on multiple sets of machines, in a defined order

- launch tasks synchronously or asynchronously

<!--Playbook syntax-->
Playbooks are expressed in YAML format with a minimum of syntax. 

<!--Playbook execution-->
A playbook runs in order from top to bottom. Within each play, tasks also run in order from top to bottom. 
Playbooks with multiple ‘plays’ can orchestrate multi-machine deployments, running one play on your webservers, 
then another play on your database servers, then a third play on your network infrastructure, and so on. At a minimum, each play defines two things:

- the managed nodes to target, using a pattern

- at least one task to execute

<!--Note-->
In Ansible 2.10 and later, we recommend you use the fully-qualified collection name in your playbooks to ensure the correct module is selected, 
because multiple collections can contain modules with the same name (for example, user).

In the playbook.yaml example file in this directory (did not run the playbook and has no host and ansible.cfg file for this directory), 
the first play targets the web servers; the second play targets the database servers.

Your playbook can include more than just a hosts line and tasks. For example, the playbook above sets a remote_user for each play. This is the user account for the SSH connection. 
You can add other Playbook Keywords (https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html#playbook-keywords) at the playbook, play, or task level to influence how Ansible behaves. 

<!--Task execution-->
By default, Ansible executes each task in order, one at a time, against all machines matched by the host pattern. 
Each task executes a module with specific arguments. When a task has executed on all target machines, Ansible moves on to the next task. 
You can use strategies to change this default behavior. Within each play, Ansible applies the same task directives to all hosts. 
If a task fails on a host, Ansible takes that host out of the rotation for the rest of the playbook.

When you run a playbook, Ansible returns information about connections, the name lines of all your plays and tasks, whether each task has succeeded or failed on each machine, and whether each task has made a change on each machine. 
At the bottom of the playbook execution, Ansible provides a summary of the nodes that were targeted and how they performed. General failures and fatal “unreachable” communication attempts are kept separate in the counts.

<!--Desired state and ‘idempotency-->
Most Ansible modules check whether the desired final state has already been achieved, and exit without performing any actions if that state has been achieved, so that repeating the task does not change the final state. 
Modules that behave this way are often called ‘idempotent.’ Whether you run a playbook once, or multiple times, the outcome should be the same. However, not all playbooks and not all modules behave this way. 
If you are unsure, test your playbooks in a sandbox environment before running them multiple times in production.

<!--Running playbooks-->
To run your playbook, use the ansible-playbook command.

    ansible-playbook playbook.yml -f 10
    
Use the --verbose flag when running your playbook to see detailed output from successful modules as well as unsuccessful ones.

<!--Running playbooks in check mode-->
Ansible’s check mode allows you to execute a playbook without applying any alterations to your systems. 
You can use check mode to test playbooks before implementing them in a production environment.

To run a playbook in check mode, you can pass the -C or --check flag to the ansible-playbook command:

    ansible-playbook --check playbook.yaml
    
Executing this command will run the playbook normally, but instead of implementing any modifications, Ansible will simply provide a report on the changes it would have made. 
This report encompasses details such as file modifications, command execution, and module calls.

Check mode offers a safe and practical approach to examine the functionality of your playbooks without risking unintended changes to your systems. 
Moreover, it is a valuable tool for troubleshooting playbooks that are not functioning as expected.

<!--Ansible-Pull-->
Should you want to invert the architecture of Ansible, so that nodes check in to a central location, instead of pushing configuration out to them, you can.
The ansible-pull is a small script that will checkout a repo of configuration instructions from git, and then run ansible-playbook against that content.
Assuming you load balance your checkout location, ansible-pull scales essentially infinitely.

For details run:

    ansible-pull --help 
    
Other example are:

This command pulls the playbook from the specified repository URL:

    ansible-pull -U <repository_url>

This command pulls the specified playbook from the repository and executes it. Replace <playbook> with the name of the playbook you want to run:

    ansible-pull -U <repository_url> <playbook>
    
This option runs the playbook in check mode, showing what changes would be made without actually applying them: 
    
    ansible-pull -U <repository_url> --check
    
This command pulls the playbook from a specific branch of the repository and executes the specified playbook. Replace <branch> with the branch name:   

    ansible-pull -U <repository_url> -C <branch> <playbook>

<!--Verifying playbooks-->
You may want to verify your playbooks to catch syntax errors and other problems before you run them. 
The ansible-playbook command offers several options for verification, including --check, --diff, --list-hosts, --list-tasks, and --syntax-check
The Tools for validating playbooks (https://docs.ansible.com/ansible/latest/community/other_tools_and_programs.html#validate-playbook-tools) describes other tools for validating and testing playbooks.

Ansible-lint is highly recommended (https://ansible.readthedocs.io/projects/lint/). To see how to install, click on the Setup tab

<!--ansible-lint-->
You can use ansible-lint for detailed, Ansible-specific feedback on your playbooks before you execute them. 
For example, if you run ansible-lint on the playbook called playbook.yaml near the top of this page, you should get the following results:

    $ ansible-lint playbook.yml
    [403] Package installs should not use latest
    verify-apache.yml:8
    Task/Handler: ensure apache is at the latest version
    
The ansible-lint default rules page describes each error. For [403], the recommended fix is to change state: latest to state: present in the playbook.