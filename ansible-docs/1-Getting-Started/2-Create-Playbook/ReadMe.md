<!--Playbooks-->
    Playbooks are automation blueprints, in YAML format, that Ansible uses to deploy and configure managed nodes.

    Playbook: A list of plays that define the order in which Ansible performs operations, from top to bottom, to achieve an overall goal.
    
    Play: An ordered list of tasks that maps to managed nodes in an inventory.
    
    Task: A reference to a single module that defines the operations that Ansible performs.
    
    Module: A unit of code or binary that Ansible runs on managed nodes. Ansible modules are grouped in collections with a Fully Qualified Collection Name (FQCN) for each module.

<!--Creating a playbook-->

1.  Complete the following steps to create a playbook that pings your hosts and prints a “Hello world” message:

    Create a file named playbook.yaml in your ansible_quickstart directory, that you created earlier, with the following content:

- name: My first play
  hosts: myhosts
  tasks:
   - name: Ping my hosts
     ansible.builtin.ping:

   - name: Print message
     ansible.builtin.debug:
      msg: Hello world

2.  Run your playbook:

        ansible-playbook -i inventory.ini playbook.yaml
        
        
3. In this output you can see:

    The names that you give the play and each task. You should always use descriptive names that make it easy to verify and troubleshoot playbooks.
    
    The “Gathering Facts” task runs implicitly. By default, Ansible gathers information about your inventory that it can use in the playbook.
    
    The status of each task. Each task has a status of ok which means it ran successfully.
    
    The play recap that summarizes results of all tasks in the playbook per host. In this example, there are three tasks so ok=3 indicates that each task ran successfully.
    

Congratulations, you have started using Ansible!