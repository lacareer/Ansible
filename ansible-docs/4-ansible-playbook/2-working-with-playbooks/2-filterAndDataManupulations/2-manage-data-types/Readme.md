<!--Managing data types-->
You might need to know, change, or set the data type on a variable. For example, a registered variable might contain a dictionary when your next task needs a list, or a user prompt might 
return a string when your playbook needs a boolean value. Use the ansible.builtin.type_debug, ansible.builtin.dict2items, and ansible.builtin.items2dict filters to manage data types. 
You can also use the data type itself to cast a value as a specific data type.

*** Discovering the data type ***

New in version 2.3.

If you are unsure of the underlying Python type of a variable, you can use the ansible.builtin.type_debug filter to display it. This is useful in debugging when you need a particular type of variable:

    {{ myvar | type_debug }}
    
You should note that, while this may seem like a useful filter for checking that you have the right type of data in a variable, 
you should often prefer type tests (https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tests.html#type-tests), which will allow you to test for specific data types

<!--Transforming strings into lists-->

Use the ansible.builtin.split filter to transform a character/string delimited string into a list of items suitable for looping. For example, if you want to split a string variable fruits by commas, you can use:

    {{ fruits | split(',') }}

String data (before applying the ansible.builtin.split filter):

    fruits: apple,banana,orange
    
List data (after applying the ansible.builtin.split filter):

    - apple
    - banana
    - orange
    
***Transforming dictionaries into lists***

New in version 2.6.

Use the ansible.builtin.dict2items filter to transform a dictionary into a list of items suitable for looping:

    {{ dict | dict2items }}
    
Dictionary data (before applying the ansible.builtin.dict2items filter):

    tags:
      Application: payment
      Environment: dev

List data (after applying the ansible.builtin.dict2items filter):

    - key: Application
      value: payment
    - key: Environment
      value: dev

New in version 2.8.


If you want to configure the names of the keys, the ansible.builtin.dict2items filter accepts 2 keyword arguments. Pass the key_name and value_name arguments to configure the names of the keys in the list output:

    {{ files | dict2items(key_name='file', value_name='path') }}
    
Dictionary data (before applying the ansible.builtin.dict2items filter):

    files:
      users: /etc/passwd
      groups: /etc/group
      
List data (after applying the ansible.builtin.dict2items filter):

    - file: users
      path: /etc/passwd
    - file: groups
      path: /etc/group
      
The ansible.builtin.dict2items filter is the reverse of the ansible.builtin.items2dict filter.
      
*** Transforming lists into dictionaries ***

New in version 2.7.

Use the ansible.builtin.items2dict filter to transform a list into a dictionary, mapping the content into key: value pairs:

    {{ tags | items2dict }}
    
List data (before applying the ansible.builtin.items2dict filter):

    tags:
      - key: Application
        value: payment
      - key: Environment
        value: dev
        
Dictionary data (after applying the ansible.builtin.items2dict filter):

    Application: payment
    Environment: dev
    
The ansible.builtin.items2dict filter is the reverse of the ansible.builtin.dict2items filter.

Not all lists use key to designate keys and value to designate values. For example, data without using keys and values:

    fruits:
      - fruit: apple
        color: red
      - fruit: pear
        color: yellow
      - fruit: grapefruit
        color: yellow
In this example, you must pass the key_name and value_name arguments to configure the transformation. For example:

    {{ fruits | items2dict(key_name='fruit', value_name='color') }}

If you do not pass these arguments, or do not pass the correct values for your list, you will see KeyError: key or KeyError: my_typo

Data after applying the {{ fruits | items2dict(key_name='fruit', value_name='color') }} to data without key/value names:

    apple: red
    pear: yellow
    grapefruit: yellow

***Forcing the data type***

You can cast values as certain types. For example, if you expect the input “True” from a vars_prompt and you want Ansible to recognize it as a boolean value instead of a string:

    - ansible.builtin.debug:
         msg: test
      when: some_string_value | bool
      
If you want to perform a mathematical comparison on a fact and you want Ansible to recognize it as an integer instead of a string:

    - shell: echo "only on Red Hat 6, derivatives, and later"
      when: ansible_facts['os_family'] == "RedHat" and ansible_facts['lsb']['major_release'] | int >= 6