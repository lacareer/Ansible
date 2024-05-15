# THIS PLAYBOOK WAS NOT TESTED

    In this exercise we will be working on the run-once.yml file to see how asynchronous task is done in Ansible

# All part of the playbook has been used in the various playbooks before this. The only new thing here is the 'run_once: yes"

# "run_once: yes": This task will only run once on only one server no matter how servers there may be. If no server is specified, it runs on the first host in the inventory

# To make "run_once: yes" run a particular server, used the "delegate_to: aParticularServerName" so it does so.

NOTE THE BELOW

# "run_once: yes":

    Will run once for each batch if there is 'serial: value"
    So for each group of server in the batch specified by 'serial', it will run once on one server, the first or the one it is delegate_to
