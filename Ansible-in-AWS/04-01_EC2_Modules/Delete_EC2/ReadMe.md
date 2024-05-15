# task: Get instances info

    This task gather info on the ec2 to be terminated (just the first if they are more than one as indicated by the array index 0), captures it in 'register: ec2_facts', and stores it in a variable using the debug module (var: ec2_facts.instances[0].instance_id)

# task: Remove tags

    Removes the tag of a specific resource with the help of the register  module in the previous task

# task: Terminate instances

    terminate the instance by setting below and specifying the resource to delete

state: absent
instance_id: - "{{ec2_facts.instances[0].instance_id}}"

        it store the info of the deleted instances using the register module and saves it to a varibale using the debug module which prints it it the terminal when the playbook is ran
