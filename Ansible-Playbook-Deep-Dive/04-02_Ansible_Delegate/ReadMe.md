# THIS PLAYBOOK WAS NOT TESTED

This playbook is similar to the the async.yml in 04-01 directory but for this addition of the "delegate_to" module used here

    In this exercise we will be working on the async.yml file to see how asynchronous task is done in Ansible

# "async: 60": Set the execution of the playbook task to 60 second. If the task has not finished within the alloted time it is terminated.

# "poll: 10": Checks on the status of the task being executed every 10 seconds while keeping the cmd in busy mode. It returns a status, to the command line, only when there is a failed or success status

        if the execution is completed within the alloted 'async' time successfully a 'success' status is returned
        if the execution is fails within the alloted 'async' time a 'failed' status is returned
        if there is an 'async' timeout a 'failed' status is returned

# 'poll: 0' can be used to free the command line while the execution runs in the background and stop the cmd from being in busy mode

# "delegate_to: aParticularServerName": Runs only on this specific/particular server and not on anyone else or other servers in the same group

        - name: Run sleep.sh
        command: ./sleep.sh
        async: 60
        poll: 0
        delegate_to: aParticularServerName

# Runs the task on all server in the group

    - name: Install mariaDB
      package:
        name: mariadb
        state: latest
        become: yes
