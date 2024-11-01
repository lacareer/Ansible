<!--Formatting data: YAML and JSON-->
You can switch a data structure in a template from or to JSON or YAML format, with options for formatting, indenting, and loading data. 
The basic filters are occasionally useful for debugging:

***See ansible.builtin.to_json and ansible.builtin.to_yaml for documentation on these filters.***

    {{ some_variable | to_json }}
    {{ some_variable | to_yaml }}
    
***See ansible.builtin.to_nice_json and ansible.builtin.to_nice_yaml for documentation on these filters.***

You can change the indentation of either format:

    {{ some_variable | to_nice_json(indent=2) }}
    {{ some_variable | to_nice_yaml(indent=8) }}
    
***NOTE***

The ansible.builtin.to_yaml and ansible.builtin.to_nice_yaml filters use the PyYAML library which has a default 80 symbol string length limit. 
That causes an unexpected line break after 80th symbol (if there is a space after 80th symbol) 
To avoid such behavior and generate long lines, use the width option. You must use a hardcoded number to define the width

    {{ some_variable | to_yaml(indent=8, width=1337) }}
    {{ some_variable | to_nice_yaml(indent=8, width=1337) }}
    
If you are reading in some already formatted data:

    {{ some_variable | from_json }}
    {{ some_variable | from_yaml }}
    
for example:

    tasks:
      - name: Register JSON output as a variable
        ansible.builtin.shell: cat /some/path/to/file.json
        register: result
        
      - name: Set a variable
        ansible.builtin.set_fact:
          myvar: "{{ result.stdout | from_json }}"
          
*** Filter to_json and Unicode support**

By default ansible.builtin.to_json and ansible.builtin.to_nice_json will convert data received to ASCII, so:

    {{ 'München'| to_json }}
    
will return:

    'M\u00fcnchen'
    
To keep Unicode characters, pass the parameter ensure_ascii=False to the filter:

    {{ 'München'| to_json(ensure_ascii=False) }}

will return:

    'München'
    
To parse multi-document YAML strings, the ansible.builtin.from_yaml_all filter is provided. The ansible.builtin.from_yaml_all filter will return a generator of parsed YAML documents.

for example:

    tasks:
      - name: Register a file content as a variable
        ansible.builtin.shell: cat /some/path/to/multidoc-file.yaml
        register: result
        
      - name: Print the transformed variable
        ansible.builtin.debug:
          msg: '{{ item }}'
        loop: '{{ result.stdout | from_yaml_all | list }}'
        
Below is an exampe of multi-document YAML strings:

    ---
    # First document
    name: Document 1
    value: 42
    ---
    # Second document
    name: Document 2
    items:
      - apple
      - banana
    ---
    # Third document
    name: Document 3
    nested:
      key: value
    ...
    
