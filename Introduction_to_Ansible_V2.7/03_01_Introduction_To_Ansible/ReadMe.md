<!-- MAKE SURE YOU ARE IN THE CURRENT DIRECTORY BEFORE RUNNING ANY OF THE ANSIBLE COMMAND ON THE COMMAND LINE -->

<!-- BEFORE RUUNING THE COMMAND BELOW MAKE SURE THE AWS EC2 INSTANCES ARE IN RUNNING MODE -->

# References for ADHOC commands:

    https://docs.ansible.com/ansible/latest/cli/ansible.html
    https://docs.ansible.com/ansible/2.9/modules/modules_by_category.html (go to the command module)

# THESE TASK COMMANDS BELOW ARE USED FOR TROUBLESHOOTING AND CHECKING CONNECTING TO VARIOUS HOST

# If you run:

    ansible -m ping all

# You would realize that ansible can only connect to the local (if you do not have ansible.cfg file configured) host but 
# not to the 3 remote servers as it returns errors for those. Hence the configuration in the ansible.cfg file below

    [defaults]
    inventory = ./hosts-dev
    remote_user = <SSH_USERNAME> (the remote user in this case is "ec2-user" of our aws instances)
    private_key_file = /path_to/keyPairName.pem (absolute path to the ec2 keypair you created and downloaded with the keypair file extension)
    host_key_checking = False (means don't check finger print when ssh-ing into the servers for the first time)

    # Windows only users
    [ssh_connection]
    ssh_args = -o ControlMaster=no

# With the configurations above, the below command returns a successful ping to all servers (except a server is added to the host that does not exist or can't be reached 
# using our aws ssh key) including the local host:

    ansible -m ping all

# To get the type of OS of the remote server/machine run the commands. In this case it returns a result for each showing the the servers are Linux systems. 
# This command is ran on the remote server and not on the local host.

    ansible -m shell -a "uname" webservers:loadbalancers

# The result of the above command is:

    app2 | CHANGED | rc=0 >>
    Linux
    app1 | CHANGED | rc=0 >>
    Linux
    lb1 | CHANGED | rc=0 >>
    Linux

# app1, app2, lb1 are the aliases of the remote servers, rc means return code ( an rc of 0 means success and 1 unsuccessful), and CHANGED means the command was ran on the remote server
