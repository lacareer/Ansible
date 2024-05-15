# Ansible error handling documentation: https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html

# THIS PLAYBOOK WAS NOT TESTED

    In this exercise we will be working on the error-2.yml file to see how error handling is done in Ansible

# "block", "rescue", and "always": This is Ansible's "try and catch" system.

# The code in the 'BLOCK' section runs first. If there is an error, execution moves to the 'rescue' block and if not it goes to the 'always' block if there is one

    if the service in "{{target_service}}" is installed, this section runs without throwing an error and the 'rescue' section is skipped and 'always' section is executed afterward

    Otherwise, if not installed, it throws an error and moves into the 'rescue' section and then the 'always' section

# The code in the 'RESCUE' only runs if there is an error in the 'BLOCK' section after which execution goes to the 'always' block if there is one

    if the service in "{{target_service}}" is not installed, the 'block' section throws an error and the 'rescue' section is executed and 'always' section is executed afterward

    Otherwise, if  installed, the 'block' section does not throw an error and 'rescue' section is skipped and execution moves into the 'always' section

# The code in the 'ALWAYS' section runs last if there is one. Runs only after the 'block' or 'rescue' portion has been executed.

ps -ef | grep sleep
