# THIS PLAYBOOK WAS NOT TESTED

    In this exercise we will be working on the async.yml file to see how asynchronous task is done in Ansible

# "async: 60": Set the execution of the playbook task to 60 second. If the task has not finished within the alloted time it is terminated.

# "poll: 10": Checks on the status of the task being executed every 10 seconds while keeping the cmd in busy mode. It returns a status, to the command line, only when there is a failed or success status

        if the execution is completed within the alloted 'async' time successfully a 'success' status is returned
        if the execution is fails within the alloted 'async' time a 'failed' status is returned
        if there is an 'async' timeout a 'failed' status is returned

# 'poll: 0' can be used to free the command line while the execution runs in the background and stop the cmd from being in busy mode
