# Similar to the ' amazon.aws.ec2_instance_info', this playbook uses the 'amazon.aws.ec2_metadata_facts:'

# task: Get instances info by tag

    Gets the metadata of a specific ec2 instance by tag and registers the reult with the 'register' module

# task: Output IP address of instances

    loops throup all available ec2 instance retrived from the previous task and using the debug module prints their IP address to the terminal

# task: Add host to inventory

    creates an inventory, loop through the ec2 instances available and add their ip to the inventory

# demogroup inventory: note that gather_fact should be set to 'no' if you are trying to ssh into a newly created instance or to prevent an error that arises because gather_facts returns with no result which kills the playbook

    - hosts: demogroup
    gather_facts: no
    remote-user: ec2-user

# task: Wait for ssh connection

    Waits and connects to the ec2 instance via ssh

# task: Collect instance facts

    Gets all the metadata of the instance using "amazon.aws.ec2_metadata_facts' and saves it using the register module

# task: Checkout gathered facts

    Prints to the terminal the instance id using ansible debug module and magic varibales

    debug:
      var: hostvars[group['demogroup'][0]['ansible_ec2_instance_id']]

# task: Change instances state by tag

    stops the ec2 instance using its tag and saves it using the register module
