These is the same exercise as in 05_03 but for some changes to the setup-app.yml. A few lines of code was just remove to test the use of 'check' mode

# '--check' mode is a way of running a playbook to detect if changes will be made wihout actually making those changes.

# With those changes made, run:

    ansible-playbook playbooks/setup-app.yml --check

# Now go to the ipAddress/info.php to see that the changes to the info.php task was not applied becuase we were using the --check flag
