<!--Handling undefined variables-->
Filters can help you manage missing or undefined variables by providing defaults or making some variables optional. 
If you configure Ansible to ignore most undefined variables, you can mark some variables as requiring values with the 'mandatory' filter.

 ***** Providing default values *****
You can provide default values for variables directly in your templates using the Jinja2 ‘default’ filter. 
This is often a better approach than failing if a variable is not defined:

    {{ some_variable | default(5) }}
    
In the above example, if the variable ‘some_variable’ is not defined, Ansible uses the default value 5, rather than raising an “undefined variable” error and failing. 
If you are working within a role, you can also add role defaults to define the default values for variables in your role

Beginning in version 2.8, attempting to access an attribute of an Undefined value in Jinja will return another Undefined value, rather than throwing an error immediately. 
This means that you can now simply use a default with a value in a nested data structure (in other words, {{ foo.bar.baz | default('DEFAULT') }}) when you do not know if the intermediate values are defined.

If you want to use the default value when variables evaluate to false or an empty string you have to set the second parameter to true:

    {{ lookup('env', 'MY_USER') | default('admin', true) }}

This code snippet above checks for the MY_USER environment variable. If it is set and has a value, that value is used. If it is not set or is empty, the default value 'admin' is used instead.

<!--Making variables optional-->
By default, Ansible requires values for all variables in a templated expression. However, you can make specific module variables optional. 
For example, you might want to use a system default for some items and control the value for others. To make a module variable optional, set the default value to the special variable omit:

    - name: Touch files with an optional mode
      ansible.builtin.file:
        dest: "{{ item.path }}"
        state: touch
        mode: "{{ item.mode | default(omit) }}"
      loop:
        - path: /tmp/foo
        - path: /tmp/bar
        - path: /tmp/baz
          mode: "0444"
          
In this example, the default mode for the files /tmp/foo and /tmp/bar is determined by the umask of the system. 
Ansible does not send a value for mode. Only the third file, /tmp/baz, receives the mode=0444 option.

<!--Defining mandatory values-->
If you configure Ansible to ignore undefined variables, you may want to define some values as mandatory. By default, Ansible fails if a variable in your playbook or command is undefined. 
You can configure Ansible to allow undefined variables by setting DEFAULT_UNDEFINED_VAR_BEHAVIOR to false. In that case, you may want to require some variables to be defined. You can do this with:

    {{ variable | mandatory }}

The variable value will be used as is, but the template evaluation will raise an error if it is undefined.

A convenient way of requiring a variable to be overridden is to give it an undefined value using the undef() function.

    galaxy_url: "https://galaxy.ansible.com"
    galaxy_api_key: "{{ undef(hint='You must specify your Galaxy API key') }}"
    
<!--Defining different values for true/false/null (ternary)-->
    
You can create a test, then define one value to use when the test returns true and another when the test returns false (new in version 1.9):

    {{ (status == 'needs_restart') | ternary('restart', 'continue') }}
    
In addition, you can define one value to use on true, one value on false and a third value on null (new in version 2.8):

    {{ enabled | ternary('no shutdown', 'shutdown', omit) }}