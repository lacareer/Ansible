<!--Manipulating strings-->

To add quotes for shell usage:

    - name: Run a shell command
      ansible.builtin.shell: echo {{ string_value | quote }}
      
(Documentation: ansible.builtin.quote)

To concatenate a list into a string:

    {{ list | join(" ") }}
    
To split a string into a list:

    {{ csv_string | split(",") }}
    
New in version 2.11.

To work with Base64 encoded strings:

    {{ encoded | b64decode }}
    {{ decoded | string | b64encode }}
    
(Documentation: ansible.builtin.b64encode)

As of version 2.6, you can define the type of encoding to use, the default is utf-8:

    {{ encoded | b64decode(encoding='utf-16-le') }}
    {{ decoded | string | b64encode(encoding='utf-16-le') }}    