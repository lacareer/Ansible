# This playbook uses the 'amazon.aws.ec2_instance_info' to get information on ec instances

    it registers/saves the info using the 'register' module as 'ec2_facts' which is stored in a variable, var, using the 'debug' module
