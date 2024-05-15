# Key argument when using the Ansible EC2 Module are:

    key_name = aws keypair name to use for the instance

    instance_type = Type of instance to provision

    image = AMI to use when provisioning a new EC2 instance

    wait = Keeps the module info from returning until a target state is reached

    count = How many instances to create everytime the playbook runs

    exact_count = How many instances to create and should exist after the the playbook finish running

    count_tag = The tag to assign to a created EC2 Instance
    wait_timeout = How long the module will wait for work to complete( default is 300 seconds)

    assigne_public_ip = If yes, a public ip address is assined to the instance

    vpc_subnet_id = VPC to which a new instance will be provisioned

# tasks: "Provision ec2_instance"

    Creates an EC2 instance using all the paramters used this task. The 'register' module captures all data about the EC2.
    The 'debug' module stores the data captured by the 'register' module in a variable called 'var' a nd dumps it to the terminal  when the playbook runs

- name: Provision ec2_instance
  amazon.aws.ec2_instance:
  aws_access_key: "{{AWS_ACCESS_KEY_ID}}"
  aws_secret_key: "{{AWS_SECRET_ACCESS_KEY}}"
  ec2_region: "{{AWS_REGION}}"
  instance_type: t2.micro
  keypair: ansiblekey
  image: ami-0022f774911c1d690
  assign_public_ip: yes
  vpc_subnet_id: subnet-4fc7c502
  group: jenkins-master
  wait: True
  exact_count: 1
  count_tags:
  Name: Ansible-Provisioned-instance
  register: ec2
  - debug:
    var: ec2

# tasks: "- name: Add host to Inventory"

    Creates an inventory file called "demogroup" by looping through the instances created by the first task (Provision ec2_instance) and adding their ips to the demogroup inventory file using the keypair.pem file from AWS downloaded onto the control machine/host

- name: Add host to Inventory
  add_host:
  hostname: "{{item.public_ip}}"
  groupname: demogroup
  ansible_ssh_common_args: "-o StrickHostKeyChecking=no"
  ansible_ssh_private_key_file: ~/.ssh/ansiblekey.pem
  loop: "{{ec2.instances}}

# tasks: "- name: Wait for SSH Connection"

    Attempts to connect to the newly created ec2 instance via ssh. 'gather_facts' should be set to 'no' because the if not the ssh connection will throw an error because the ec2 instance is still booting up and it cannot connect to it via ssh which will stop the playbook from executing.
    When set to 'no' ssh can now be ask to wait for 5-90 second after tring to connect without success b4 throwing an error

- hosts: demogroup
  gather_facts: no
  remote_user: ec2-user

  tasks:

  - name: Wait for SSH Connection
    wait_for_connection:
    delay: 5
    timeout: 90
  - name: Check host status by ping
    ping:

# # tasks: "- name: Wait for SSH Connection"

    Pings the newly created ec2

- name: Check host status by ping
  ping
