<!--THIS EXAMPLE WAS FROM MICROSOFT COPILOT-->
<!--DID NOT TEST IT BUT LOOKS ABOUT RIGHT WITH WORKS ANSIBLEHUB SETUP-->

***Prerequisites***

        - AWS CLI: Ensure you have the AWS CLI installed and configured.
        - Ansible: Ensure Ansible is installed on your control machine.
        - SSM Agent: Ensure the SSM Agent is installed and running on your EC2 instances (most Amazon Linux AMIs have this pre-installed).

Steps

1. Create an IAM Role for EC2 Instances:

  * Go to the IAM console and create a new role.
  * Select AWS service as the trusted entity and choose EC2.
  * Attach the AmazonSSMManagedInstanceCore policy to the role.
  * Name the role and create it.
  
2. Attach the IAM Role to Your EC2 Instances:

  * Go to the EC2 console, select your instance, and choose Actions > Security > Modify IAM Role.
  * Attach the IAM role you created.
  
3. Install the AWS SSM Session Manager Plugin:

  * On your control machine, install the Session Manager plugin for the AWS CLI. Follow the official AWS documentation for installation instructions.
e.g
        sudo yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm
  
4. Install the community.aws Collection:

  * Install the community.aws collection if you haven’t already:
e.g
        ansible-galaxy collection install community.aws

5. Create an Ansible Inventory File:

  * Create a YAML inventory file to use the aws_ssm connection plugin. Here’s an example:
e.g  
        plugin: community.aws.aws_ssm
        regions:
          - us-west-2
        filters:
          tag:Environment: Production
        hostnames:
          - tag:Name

6. Configure Ansible to Use the SSM Connection Plugin:

  * Update your Ansible configuration to use the aws_ssm connection plugin. Here’s an example inventory file:
e.g

            [ssm_instances]
            my-ec2-instance ansible_host=i-0123456789abcdef0
            
            [ssm_instances:vars]
            ansible_connection=community.aws.aws_ssm
            ansible_aws_ssm_region=us-west-2

7. Create an Ansible Playbook: Write a playbook to perform tasks on your EC2 instances. Here’s a simple example:
e.g

            - name: Test connection to EC2 instances via SSM
              hosts: ssm_instances
              tasks:
                - name: Ping the instances
                  ansible.builtin.ping:

***Example Playbook Execution***
Run the playbook with the following command:
e.g

    ansible-playbook -i inventory.yml playbook.yml

This setup allows you to manage your EC2 instances securely using AWS SSM, eliminating the need for SSH keys12.

