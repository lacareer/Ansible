# Ansible error handling documentation: https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html

In this exercise we will be working on the check-status.yml file to see how error handling is done in Ansible

# Error handling has been added to the check-status.yml file. Originally, this file just checks the status of the Apache on the servers - whether running or not. The error handling added is shown below:

    tasks:
      - name: Check status of apache
        command: service httpd status
        args:
            warn: no
        changed_when: false

      - name: This will not fail
        command: /bin/false
        ignore_errors: yes

# 'changed_when: false' : Dont return a changed status when nothing has changed about the installed Apache on the server. By default it returns a 'changed' status whether or not it has changed

# 'args: warn: no': Tells ansible to surpress any warning by Ansible. The 'command' module returns a warning asking us to use the 'service module' hence our use of the 'args: warn: no'.

# 'ignore_errors: yes' : The 'command: /bin/false' by default returns a non-zero or failed status. But with this added, the playbook continues to run by ignoing the error instead of stopping

# Run the check-status.yml:

    ansible-playbook playbooks/check-status.yml

# If there is a failure when the above playbook is ran a '.retry' file is created with a name corresonding to the playbook file name, in this case 'check-status.retry'

# In case there are many servers and in the event of failure as shown above in only certain servers, you can make the playbook run on the host where the failure occurred for a certain/max number of times until it succeeds. 
  It will not run on the host where it successfully ran before, just on the host where it failed (where limit recieved the host where the retry should be done)

# Limit and retry reference: https://ansible-tips-and-tricks.readthedocs.io/en/latest/ansible/commands/

    ansible-playbook --limit error.yml --limit "host1, host2, etc"
