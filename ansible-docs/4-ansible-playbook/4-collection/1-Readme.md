***Using Ansible collections***

Collections are a distribution format for Ansible content that can include playbooks, roles, modules, and plugins. 
You can install and use collections through a distribution server, such as Ansible Galaxy, or a Pulp 3 Galaxy server.

***Installing collections with ansible-galaxy***

To install a collection hosted in Galaxy:

        ansible-galaxy collection install my_namespace.my_collection

To upgrade a collection to the latest available version from the Galaxy server you can use the --upgrade option:

        ansible-galaxy collection install my_namespace.my_collection --upgrade
        
***Removing a collection***
If you no longer need a collection, simply remove the installation directory from your filesystem. 
The path can be different depending on your operating system:

        rm -rf ~/.ansible/collections/ansible_collections/community/general
        
        rm -rf ./venv/lib/python3.9/site-packages/ansible_collections/community/general
        
***Downloading collections***
To download a collection and its dependencies for an offline install, run ansible-galaxy collection download. 
This downloads the collections specified and their dependencies to the specified folder and creates a requirements.yml 
file which can be used to install those collections on a host without access to a Galaxy server.        

To download a single collection and its dependencies:

        ansible-galaxy collection download my_namespace.my_collection

To download a single collection at a specific version:

        ansible-galaxy collection download my_namespace.my_collection:1.0.0
        
To download multiple collections either specify multiple collections as command line arguments as shown above or use a requirements file 
in the format documented with Install multiple collections with a requirements file.

        ansible-galaxy collection download -r requirements.yml

You can also download a source collection directory. The collection is built with the mandatory galaxy.yml file.

        ansible-galaxy collection download /path/to/collection
        
        ansible-galaxy collection download git+file:///path/to/collection/.git

You can download multiple source collections from a single namespace by providing the path to the namespace.

        ns/
        ├── collection1/
        │   ├── galaxy.yml
        │   └── plugins/
        └── collection2/
            ├── galaxy.yml
            └── plugins/
    
    
        ansible-galaxy collection install /path/to/ns


All the collections are downloaded by default to the ./collections folder but you can use -p or --download-path to specify another path:

        ansible-galaxy collection download my_namespace.my_collection -p ~/offline-collections

Once you have downloaded the collections, the folder contains the collections specified, their dependencies, and a requirements.yml file. 
You can use this folder as is with ansible-galaxy collection install to install the collections on a host without access to a Galaxy server.

        # This must be run from the folder that contains the offline collections and requirements.yml file downloaded
        # by the internet-connected host
        cd ~/offline-collections
        ansible-galaxy collection install -r requirements.yml
        
<!--Listing collections-->
To list installed collections, run ansible-galaxy collection list. This shows all of the installed collections found in the configured collections search paths. 
It will also show collections under development that contain a galaxy.yml file instead of a MANIFEST.json.         

        ansible-galaxy collection list

should have output like below        

        # /home/astark/.ansible/collections/ansible_collections
        Collection                 Version
        -------------------------- -------
        cisco.aci                  0.0.5
        cisco.mso                  0.0.4
        sandwiches.ham             *
        splunk.es                  0.0.5
        
        # /usr/share/ansible/collections/ansible_collections
        Collection        Version
        ----------------- -------
        fortinet.fortios  1.0.6
        pureport.pureport 0.0.8
        sensu.sensu_go    1.3.0
        
Run with -vvv to display more detailed information. You may see additional collections here that were added as dependencies of your installed collections. 
Only use collections in your playbooks that you have directly installed.

To list a specific collection, pass a valid fully qualified collection name (FQCN) to the command ansible-galaxy collection list. All instances of the collection will be listed.

         ansible-galaxy collection list fortinet.fortios

output like below

        # /home/astark/.ansible/collections/ansible_collections
        Collection       Version
        ---------------- -------
        fortinet.fortios 1.0.1
        
        # /usr/share/ansible/collections/ansible_collections
        Collection       Version
        ---------------- -------
        fortinet.fortios 1.0.6

To search other paths for collections, use the -p option. Specify multiple search paths by separating them with a :. 
he list of paths specified on the command line will be added to the beginning of the configured collections search paths.

        ansible-galaxy collection list -p '/opt/ansible/collections:/etc/ansible/collections'

output like below

        # /opt/ansible/collections/ansible_collections
        Collection      Version
        --------------- -------
        sandwiches.club 1.7.2
        
        # /etc/ansible/collections/ansible_collections
        Collection     Version
        -------------- -------
        sandwiches.pbj 1.2.0
        
        # /home/astark/.ansible/collections/ansible_collections
        Collection                 Version
        -------------------------- -------
        cisco.aci                  0.0.5
        cisco.mso                  0.0.4
        fortinet.fortios           1.0.1
        sandwiches.ham             *
        splunk.es                  0.0.5
        
        # /usr/share/ansible/collections/ansible_collections
        Collection        Version
        ----------------- -------
        fortinet.fortios  1.0.6
        pureport.pureport 0.0.8
        sensu.sensu_go    1.3.0       
        
Once installed, you can verify that the content of the installed collection matches the content of the collection on the server. 
This feature expects that the collection is installed in one of the configured collection paths and that the collection exists on one of the configured galaxy servers.

        ansible-galaxy collection verify my_namespace.my_collection

The output of the ansible-galaxy collection verify command is quiet if it is successful. 
If a collection has been modified, the altered files are listed under the collection name.

command with output be like:

        ansible-galaxy collection verify my_namespace.my_collection
        
        Collection my_namespace.my_collection contains modified content in the following files:
        my_namespace.my_collection
            plugins/inventory/my_inventory.py
            plugins/modules/my_module.py        