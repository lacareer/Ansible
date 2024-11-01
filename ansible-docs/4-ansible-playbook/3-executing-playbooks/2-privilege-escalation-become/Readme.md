<!--Using become-->
You can control the use of become with play or task directives, connection variables, or at the command line. 
If you set privilege escalation properties in multiple ways, review the general precedence rules to understand which settings will be used.

A full list of all become plugins that are included in Ansible can be found in the Plugin List.

***Become directives***

You can set the directives that control become at the play or task level. You can override these by setting connection variables, which often differ from one host to another. 
These variables and directives are independent. For example, setting become_user does not set become.

        - become: set to true to activate privilege escalation.
        
        - become_user: set to user with desired privileges — the user you become, NOT the user you login as. Does NOT imply become: true, to allow it to be set at the host level. The default value is root.
        
        - become_method: (at play or task level) overrides the default method set in ansible.cfg, set to use any of the Become plugins.
        
        - become_flags: (at play or task level) permit the use of specific flags for the tasks or role. One common use is to change the user to nobody when the shell is set to nologin. Added in Ansible 2.2.

For example, to manage a system service (which requires root privileges) when connected as a non-root user, you can use the default value of become_user (root):

        - name: Ensure the httpd service is running
          service:
            name: httpd
            state: started
          become: true

To run a command as the apache user:

        - name: Run a command as the apache user
          command: somecommand
          become: true
          become_user: apache

To do something as the nobody user when the shell is nologin:

        - name: Run a command as nobody
          command: somecommand
          become: true
          become_method: su
          become_user: nobody
          become_flags: '-s /bin/sh'

To specify a password for sudo, run ansible-playbook with --ask-become-pass (-K for short). If you run a playbook utilizing become and the playbook seems to hang, most likely it is stuck at the privilege escalation prompt. 
Stop it with CTRL-c, then execute the playbook with -K and the appropriate password.

***Become connection variables***
You can define different become options for each managed node or group. You can define these variables in inventory or use them as normal variables.

        - ansible_become: overrides the become directive and decides if privilege escalation is used or not.
        
        - ansible_become_method: which privilege escalation method should be used
        
        - ansible_become_user: set the user you become through privilege escalation; does not imply ansible_become: true
        
        - ansible_become_password: set the privilege escalation password. See Using encrypted variables and files for details on how to avoid having secrets in plain text
        
        - ansible_common_remote_group: determines if Ansible should try to chgrp its temporary files to a group if setfacl and chown both fail. See Risks of becoming an unprivileged user for more information. Added in version 2.10.

For example, if you want to run all tasks as root on a server named webserver, but you can only connect as the manager user, you could use an inventory entry like this:

            webserver ansible_user=manager ansible_become=true