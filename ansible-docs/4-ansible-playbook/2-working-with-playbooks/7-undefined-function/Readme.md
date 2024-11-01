<!--The undef function: add hint for undefined variables-->
New in version 2.12.

The Jinja2 undef() function returns a Python AnsibleUndefined object, derived from jinja2.StrictUndefined. 
Use undef() to undefine variables of lesser precedence. For example, a host variable can be overridden for a block of tasks:

    ---
    - hosts: localhost
      gather_facts: no
      module_defaults:
        group/ns.col.auth: "{{ vaulted_credentials | default({}) }}"
      tasks:
        - ns.col.module1:
        - ns.col.module2:

        - name: override host variable
          vars:
            vaulted_credentials: "{{ undef() }}"
          block:
            - ns.col.module1:

The undef function accepts one optional argument:

hint: Give a custom hint about the undefined variable if DEFAULT_UNDEFINED_VAR_BEHAVIOR is configured to give an error.            