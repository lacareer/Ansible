***Using collections in a playbook***
Once installed, you can reference a collection content by its fully qualified collection name (FQCN):

        - name: Reference a collection content using its FQCN
          hosts: all
          tasks:
        
            - name: Call a module using FQCN
              my_namespace.my_collection.my_module:
                option1: value
        
This works for roles or any type of plugin distributed within the collection:

        - name: Reference collections contents using their FQCNs
          hosts: all
          tasks:
        
            - name: Import a role
              ansible.builtin.import_role:
                name: my_namespace.my_collection.role1
        
            - name: Call a module
              my_namespace.mycollection.my_module:
                option1: value
        
            - name: Call a debug task
              ansible.builtin.debug:
                msg: '{{ lookup("my_namespace.my_collection.lookup1", 'param1')| my_namespace.my_collection.filter1 }}'
                
***Using collections in playbooks***
In a playbook, you can control the collections Ansible searches for modules and action plugins to execute. 
However, any roles you call in your playbook define their own collections search order; they do not inherit the calling playbook’s settings. 
This is true even if the role does not define its own collections keyword.

            - name: Run a play using the collections keyword
              hosts: all
              collections:
                - my_namespace.my_collection
            
              tasks:
            
                - name: Import a role
                  ansible.builtin.import_role:
                    name: role1
            
                - name: Run a module not specifying FQCN
                  my_module:
                    option1: value
            
                - name: Run a debug task
                  ansible.builtin.debug:
                    msg: '{{ lookup("my_namespace.my_collection.lookup1", "param1")| my_namespace.my_collection.filter1 }}'
        
The collections keyword merely creates an ordered ‘search path’ for non-namespaced plugins and role references. 
It does not install content or otherwise change Ansible’s behavior around the loading of plugins or roles.                 

***Using a playbook from a collection***
New in version 2.11.

You can also distribute playbooks in your collection and invoke them using the same semantics you use for plugins:

            ansible-playbook my_namespace.my_collection.playbook1 -i ./myinventory

From inside a playbook:

            - name: Import a playbook
              ansible.builtin.import_playbook: my_namespace.my_collection.playbookX

A few recommendations when creating such playbooks, hosts: should be generic or at least have a variable input.

            - hosts: all  # Use --limit or customized inventory to restrict hosts targeted
            
            - hosts: localhost  # For things you want to restrict to the control node
            
            - hosts: '{{target|default("webservers")}}'  # Assumes inventory provides a 'webservers' group, but can also use ``-e 'target=host1,host2'``
            
This will have an implied entry in the collections: keyword of my_namespace.my_collection just as with roles.