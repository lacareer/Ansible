# Ansible error handling documentation: https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html

# THIS PLAYBOOK WAS NOT TESTED

    In this exercise we will be working on the error-1.yml file to see how error handling is done in Ansible

# error-1.yml: Error handling has been added as shown below:

# 'ignore_errors: yes': This task fails because there is no package called "broke" but the playbook will continue to run because of the 'ignore_errors: yes'

    - name: Install Software
        yum:
        name: broke
        state: latest
        ignore_errors: yes

# Creating a custom definition for 'changed_when' and 'failed_when'

    - name: Run Utility
        command: ./do-stuff.sh what
        register: cmd_output
        changed_when: " 'CHANGED' in the cmd_output.stout "
        failed_when: " 'FAIL' in the cmd_output.stout "

# changed_when: " 'CHANGED' in the cmd_output.stout ": Return a changed status when the word 'CHANGED' is in the standard output after running the bash script in the location './do-stuff.sh' without passing any argument.

# failed_when: " 'FAIL' in the cmd_output.stout ": Return a failed status when the word 'FAIL' is in the standard output after running the bash script in the location './do-stuff.sh' and passing the argument 'what'.

# Run the check-status.yml:

    ansible-playbook playbooks/error-1.yml

# If there is a failure when the above playbook is ran a '.retry' file is created with a name corresonding to the playbook file name, in this case 'check-status.retry'

# In case there are many servers and in the event of failure as shown above in only certain servers, you can make the playbook run on the host where the failure occurred for a certain/max number of times until it succeeds. It will not run on the host where it successfully ran before, just on the host where it failed (where limit recieved the host where the retry should be done)

# Limit and rerey reference: https://ansible-tips-and-tricks.readthedocs.io/en/latest/ansible/commands/

    ansible-playbook --limit playbooks/error-1.yml --limit "host1, host2, etc"
