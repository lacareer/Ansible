<!--Using Variables-->

***Creating valid variable names***
Not all strings are valid Ansible variable names. A variable name can only include letters, numbers, and underscores. 
Python keywords or playbook keywords are not valid variable names. A variable name cannot begin with a number.

Variable names can begin with an underscore. In many programming languages, variables that begin with an underscore are private. 
This is not true in Ansible. Variables that begin with an underscore are treated exactly the same as any other variable. 
Do not rely on this convention for privacy or security.

***Defining simple variables***
You can define a simple variable using standard YAML syntax. For example:

        remote_install_path: /opt/my_app_config
        
After you define a variable, use Jinja2 syntax to reference it. Jinja2 variables use double curly braces. 
For example, the expression belwo demonstrates the most basic form of variable substitution. 

        My amp goes to {{ max_amp_value }} 
        
 
You can use Jinja2 syntax in playbooks. For example:

        ansible.builtin.template:
          src: foo.cfg.j2
          dest: '{{ remote_install_path }}/foo.cfg'        
          
In this example, the variable defines the location of a file, which can vary from one system to another.

Note: Ansible allows Jinja2 loops and conditionals in templates but not in playbooks. You cannot create a loop of tasks. Ansible playbooks are pure machine-parseable YAML.

***When to quote variables (a YAML gotcha)***        
If you start a value with {{ foo }}, you must quote the whole expression to create valid YAML syntax. 
If you do not quote the whole expression, the YAML parser cannot interpret the syntax - it might be a variable or it might be the start of a YAML dictionary. 
For guidance on writing YAML, see the YAML Syntax documentation.

If you use a variable without quotes like this:

        - hosts: app_servers
          vars:
            app_path: {{ base_path }}/22
            
You will see: ERROR! Syntax Error while loading YAML. 

If you add quotes, Ansible works correctly:

        - hosts: app_servers
          vars:
            app_path: "{{ base_path }}/22"
            
***Boolean variables***
Ansible accepts a broad range of values for boolean variables: true/false, 1/0, yes/no, True/False and so on. The matching of valid strings is case insensitive. 
While documentation examples focus on true/false to be compatible with ansible-lint default settings, you can use any of the following:   

Valid values                                                    Description
____________________________________________________________________________________
True , 'true' , 't' , 'yes' , 'y' , 'on' , '1' , 1 , 1.0	    Truthy values
____________________________________________________________________________________
False , 'false' , 'f' , 'no' , 'n' , 'off' , '0' , 0 , 0.0	    Falsy values
____________________________________________________________________________________

***List variables****
A list variable combines a variable name with multiple values. The multiple values can be stored as an itemized list or in square brackets [], separated with commas.

***Defining variables as lists***
You can define variables with multiple values using YAML lists. For example:

        region:
          - northeast
          - southeast
          - midwest
or

    region: [northeast,southeast,]midwest

***Referencing list variables***    
When you use variables defined as a list (also called an array), you can use individual, specific fields from that list. 
The first item in a list is item 0, the second item is item 1. For example:

        region: "{{ region[0] }}"
        
The value of this expression would be “northeast”.

***Dictionary variables***   
A dictionary stores the data in key-value pairs. Usually, dictionaries are used to store related data, such as the information contained in an ID or a user profile.

***Defining variables as key:value dictionaries***
You can define more complex variables using YAML dictionaries. A YAML dictionary maps keys to values. For example:

        foo:
          field1: one
          field2: two
          
***Referencing key:value dictionary variables***
When you use variables defined as a key:value dictionary (also called a hash), you can use individual, specific fields from that dictionary using either bracket notation or dot notation:

        foo['field1']
or

        foo.field1
        
Both of these examples reference the same value (“one”). Bracket notation always works. Dot notation can cause problems because some keys collide with attributes and methods of python dictionaries. 
Use bracket notation if you use keys which start and end with two underscores (which are reserved for special meanings in python) or are any of the known public attributes/methods:     

        add, append, as_integer_ratio, bit_length, capitalize, center, clear, conjugate, copy, count, decode, denominator, difference, difference_update, discard, encode, endswith, expandtabs, extend, find, 
        format, fromhex, fromkeys, get, has_key, hex, imag, index, insert, intersection, intersection_update, isalnum, isalpha, isdecimal, isdigit, isdisjoint, is_integer, islower, isnumeric, isspace, issubset, 
        issuperset, istitle, isupper, items, iteritems, iterkeys, itervalues, join, keys, ljust, lower, lstrip, numerator, partition, pop, popitem, real, remove, replace, reverse, rfind, rindex, rjust, rpartition, rsplit, 
        rstrip, setdefault, sort, split, splitlines, startswith, strip, swapcase, symmetric_difference, symmetric_difference_update, title, translate, union, update, upper, values, viewitems, viewkeys, viewvalues, zfill.
        
***Combining list variables***
You can use the set_fact module to combine lists into a new merged_list variable as follows:

            vars:
              list1:
              - apple
              - banana
              - fig
            
              list2:
              - peach
              - plum
              - pear
            
            tasks:
            - name: Combine list1 and list2 into a merged_list var
              ansible.builtin.set_fact:
                merged_list: "{{ list1 + list2 }}"
                
***Combining dictionary variables***
To merge dictionaries use the combine filter, for example:

            vars:
              dict1:
                name: Leeroy Jenkins
                age: 25
                occupation: Astronaut
            
              dict2:
                location: Galway
                country: Ireland
                postcode: H71 1234
            
            tasks:
            - name: Combine dict1 and dict2 into a merged_dict var
              ansible.builtin.set_fact:
                merged_dict: "{{ dict1 | ansible.builtin.combine(dict2) }}"   
                
***Using the merge_variables lookup***
To merge variables that match the given prefixes, suffixes, or regular expressions, you can use the community.general.merge_variables lookup, for example:

        merged_variable: "{{ lookup('community.general.merge_variables', '__my_pattern', pattern_type='suffix') }}"

For more details and example usage, refer to the community.general.merge_variables lookup documentation (https://docs.ansible.com/ansible/latest/collections/community/general/merge_variables_lookup.html).

***Registering variables***  
You can create variables from the output of an Ansible task with the task keyword register. You can use registered variables in any later tasks in your play. For example:

            - hosts: web_servers
            
              tasks:
            
                 - name: Run a shell command and register its output as a variable
                   ansible.builtin.shell: /usr/bin/foo
                   register: foo_result
                   ignore_errors: true
            
                 - name: Run a shell command using output of the previous task
                   ansible.builtin.shell: /usr/bin/bar
                   when: foo_result.rc == 5
                   
***Referencing nested variables***
Many registered variables (and facts) are nested YAML or JSON data structures. You cannot access values from these nested data structures with the simple {{ foo }} syntax. 
You must use either bracket notation or dot notation. For example, to reference an IP address from your facts using the bracket notation:

            {{ ansible_facts["eth0"]["ipv4"]["address"] }}

To reference an IP address from your facts using the dot notation:

            {{ ansible_facts.eth0.ipv4.address }}
            
***Defining variables in included files and roles***
You can define variables in reusable variables files and/or in reusable roles. When you define variables in reusable variable files, the sensitive variables are separated from playbooks. 
This separation enables you to store your playbooks in a source control software and even share the playbooks, without the risk of exposing passwords or other sensitive and personal data. 
For information about creating reusable files and roles, see Re-using Ansible artifacts.

This example shows how you can include variables defined in an external file:

            ---
            
            - hosts: all
              remote_user: root
              vars:
                favcolor: blue
              vars_files:
                - /vars/external_vars.yml
            
              tasks:
            
              - name: This is just a placeholder
                ansible.builtin.command: /bin/echo foo

The contents of each variables file is a simple YAML dictionary. For example:

            ---
            # in the above example, this would be vars/external_vars.yml
            somevar: somevalue
            password: magic    
            
***Defining variables at runtime***
You can define variables when you run your playbook by passing variables at the command line using the --extra-vars (or -e) argument. 
You can also request user input with a vars_prompt (see Interactive input: prompts). When you pass variables at the command line, use a single quoted string, that contains one or more variables, in one of the formats below.

***key=value format***
Values passed in using the key=value syntax are interpreted as strings. Use the JSON format if you need to pass non-string values such as Booleans, integers, floats, lists, and so on.

            ansible-playbook release.yml --extra-vars "version=1.23.45 other_variable=foo"

***JSON string format***

            ansible-playbook release.yml --extra-vars '{"version":"1.23.45","other_variable":"foo"}'
            ansible-playbook arcade.yml --extra-vars '{"pacman":"mrs","ghosts":["inky","pinky","clyde","sue"]}'

When passing variables with --extra-vars, you must escape quotes and other special characters appropriately for both your markup (for example, JSON) and for your shell:

            ansible-playbook arcade.yml --extra-vars "{\"name\":\"Conan O\'Brien\"}"
            ansible-playbook arcade.yml --extra-vars '{"name":"Conan O'\\\''Brien"}'
            ansible-playbook script.yml --extra-vars "{\"dialog\":\"He said \\\"I just can\'t get enough of those single and double-quotes"\!"\\\"\"}"

***vars from a JSON or YAML file***
If you have a lot of special characters, use a JSON or YAML file containing the variable definitions. Prepend both JSON and YAML file names with @.

            ansible-playbook release.yml --extra-vars "@some_file.json"
            ansible-playbook release.yml --extra-vars "@some_file.yaml"            