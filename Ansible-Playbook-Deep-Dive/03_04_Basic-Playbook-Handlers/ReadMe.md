# I DID NOT RUN THIS PLAYBOOK BECAUSE I DO NOT WANT TO CHANGE MY SERVER CONFIGURATIONS

# This playbook has 2 task after which the handler might run

    install latest httpd
    Move your configuration file to a certain location using the 'template' module

# What is template in Ansible playbook?

    A template is a file that contains all your configuration parameters, but the dynamic values are given as variables in the Ansible. During the playbook execution, it depends on the conditions such as which cluster you are using, and the variables will be replaced with the relevant values.

# 'notify' and 'listen'

    Notify: The 2nd task "update configuration" usings the 'notify' module. This is what calls the handler, using 'listen' that matches service name it wants to notify, in this case 'httpd service'. It will only notify the handle if there is a change in host. Otherwise if no change occurs, it will not notify the handler and the handler will not run.

    Listen: listens to the 'notify' to determine if to run the handler

# A handler only runs once even if there are many task with 'notify' referencing it. So, basically it wants till the last task notifying it to run to finish executing and all task of the playbook completed before it runs
