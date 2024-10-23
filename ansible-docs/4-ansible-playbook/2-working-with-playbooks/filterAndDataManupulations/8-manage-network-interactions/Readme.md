<!--Managing network interactions-->

These filters help you with common network tasks.

***Note
These filters have migrated to the ansible.utils collection. 
Follow the installation instructions to install that collection.

***IP address filters***
New in version 1.9.

To test if a string is a valid IP address:

    {{ myvar | ansible.utils.ipaddr }}
    
You can also require a specific IP protocol version:

    {{ myvar | ansible.utils.ipv4 }}
    {{ myvar | ansible.utils.ipv6 }}
    
IP address filter can also be used to extract specific information from an IP address. 
For example, to get the IP address itself from a CIDR, you can use:

    {{ '192.0.2.1/24' | ansible.utils.ipaddr('address') }}
    
# => 192.0.2.1

*** READ UP MORE ON NETWORK HERE: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_filters.html#managing-network-interactions