# Make sure you create the file 'hostname' in the app1 remote server. To create the file do:

    ssh into the server from the command line or aws console
    cd into the tmp directory: cd /tmp
    create the file: touch hostname
    Enter content: After running the above press 'i' to start insertion and 'esc' when you are done
    Press: ':wq' to quit and save or ':q' to just quit

# when: fileName.stat.exists

    Uses the 'when' condition to determine whether to run the task or not. In this case the task runs only if the file exist and does not run if it does not exist

# 'when' conditions could be:

    same as our condition used in playbook: hostname['stat']['exists']
    Can also do other conditions like:  not fileName.stat.exists
    Can also do other conditions like:  is defined fileName.stat.exists
    You ca also use: equal(==), >=, <=, >, <, etc

# You would notice that the task skips or is not executed on app2 because the file does not exit there but is executed on app1

# The playbook will skipp app1 and app2 if you run it a second time because the file 'hostname' does not exist in that location anymore after it has been moved.

    command: mv "{{target_file}}" /tmp/copied

# To run again recreate the file in the path shown in the playbook and give it a new name if you want to move it to the same '/tmp' so that there is no name clash
