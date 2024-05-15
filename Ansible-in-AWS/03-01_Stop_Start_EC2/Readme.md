# Before beginning the set up below ensure the folowing dependencies are installed on your machine - Linux is easier and used here:

    Make sure Python and pip (Python3 and pip3 for Linux) are installed on the control/local machine and AWS collection, amazon.aws, for interacting with AWS.
    Use python3 --version and pip3 --version to check for Python and Pip respectively on Linux systems. Make sure Python3+ is install on remote and host

    Install python-boto and python-boto3 if you intend to use anisble with AWS using pip (pip3 install botocore, pip3 install boto, and pip3 install boto3). Make sure to use 'pip3' for the installation of botocore, boto or boto3 and not just 'pip'

# amazon.aws.ec2 module – create, terminate, start or stop an instance in ec2

    This module is part of the amazon.aws collection (version 2.2.0).
    You might already have this collection installed if you are using the ansible package. It is not included in ansible-core. To check whether it is installed, run ansible-galaxy collection list.
    To install it, use: ansible-galaxy collection install amazon.aws.
    To use it in a playbook, specify: amazon.aws.AWSResourceName.

# References

    https://docs.ansible.com/ansible/latest/collections/amazon/aws/ec2_vpc_net_module.html#notes

    https://docs.ansible.com/ansible/latest/collections/amazon/aws/ec2_module.html#examples

    https://adamtheautomator.com/ansible-ec2/

    https://linuxize.com/post/how-to-install-pip-on-ubuntu-18.04/

# ec2-change-state-to-stopped.yml AND ec2-change-state-to-running.yml

    starts and stop the Ec2 instance using the AWS keys that were imported from the var_files

    Note that the host to stop the ec2 is the remote host (loadbalancers). If gather_facts is set to true, you should see a failed to connect error when the EC2 is stopped by the playbook because it can nologer connect to it because it has been stopped

    Note that the host to start the ec2 is the localhost

# ec2-change-state-shell-to-running.yml: Starts teh EC2

    Note that the host to start the ec2 is the localhost

    Starts the EC2. To get it to run do the following from the project directory:
    1.  source ./keys.sh : Executes the bash script keys.sh and addd the AWS key/value pairs to the environment
    2.  env | grep AWS : Returns the AWS keys, showing that they are now part of the environment variables for the current session
    3.  ansible-playbook ec2-change-state-shell-to-running.yml : Runs the playbook
