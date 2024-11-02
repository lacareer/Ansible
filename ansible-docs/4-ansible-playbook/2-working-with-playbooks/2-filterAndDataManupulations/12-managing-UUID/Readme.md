<!--Managing UUIDs-->

To create a namespaced UUIDv5:

    {{ string | to_uuid(namespace='11111111-2222-3333-4444-555555555555') }}
    
New in version 2.10.

To create a namespaced UUIDv5 using the default Ansible namespace ‘361E6D51-FAEC-444A-9079-341386DA8E2E’:

    {{ string | to_uuid }}
    
New in version 1.9.

To make use of one attribute from each item in a list of complex variables, use the Jinja2 map filter:

# get a comma-separated list of the mount points (for example, "/,/mnt/stuff") on a host

    {{ ansible_mounts | map(attribute='mount') | join(',') }}