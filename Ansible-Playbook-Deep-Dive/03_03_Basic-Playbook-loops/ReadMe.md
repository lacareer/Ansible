# Make sure to run playbook loop.yml to install the softwares before running loop-2.yml which starts the software services and uncomment the commented services

# Also note that the below services can not be started so it throws and error after the httpd, Apache, service has started. This services that throws the error and cannot be started are :

        - elinks
        - nmap-ncat
        - bind-utils

# Remove the above error service from the list or look in vars.yml if you dont want to see the error

# loop.yml

# name: "{{ item }}"

    Represents each item in the list

# The list to loop through

    loop:
        - elinks
        - nmap-ncat
        - bind-utils

# - name: Install softwares

    installs all the software in the list by looping throught the list and installing each

# loop-2.yml

    Uses loop like in lop.yml but this time uses the 'service' module, check for services, and starts the services in the list ran by the loop(the loop uses the a vriable called service_list defined in the imported var.yml file)
