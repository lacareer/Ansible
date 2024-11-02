<!--Roles-->
Roles let you automatically load related vars, files, tasks, handlers, and other Ansible artifacts based on a known file structure. 
After you group your content into roles, you can easily reuse them and share them with other users.

- Role directory structure

- Storing and finding roles

- Using roles

    * Using roles at the play level
    
    * Including roles: dynamic reuse
    
    * Importing roles: static reuse

- Role argument validation

    * Specification format
    
    * Sample specification

- Running a role multiple times in one play

    * Passing different parameters
    
    * Using allow_duplicates: true

- Using role dependencies

    * Running role dependencies multiple times in one play

- Embedding modules and plugins in roles

- Sharing roles: Ansible Galaxy

***Role directory structure***
An Ansible role has a defined directory structure with seven main standard directories. 
You must include at least one of these directories in each role. You can omit any directories the role does not use. 
For example:

# playbooks

        site.yml
        webservers.yml
        fooservers.yml

#one of the playbook above can have a role, called 'common', with the below directory structure

        roles/
            common/               # this hierarchy represents a "role"
                tasks/            #
                    main.yml      #  <-- tasks file can include smaller files if warranted
                handlers/         #
                    main.yml      #  <-- handlers file
                templates/        #  <-- files for use with the template resource
                    ntp.conf.j2   #  <------- templates end in .j2
                files/            #
                    bar.txt       #  <-- files for use with the copy resource
                    foo.sh        #  <-- script files for use with the script resource
                vars/             #
                    main.yml      #  <-- variables associated with this role
                defaults/         #
                    main.yml      #  <-- default lower priority variables for this role
                meta/             #
                    main.yml      #  <-- role dependencies
                library/          # roles can also include custom modules
                module_utils/     # roles can also include custom module_utils
                lookup_plugins/   # or other types of plugins, like lookup in this case
        
            webtier/              # same kind of structure as "common" was above, done for the webtier role
            monitoring/           # same kind of structure as "common" was above, done for the monitoring role
            fooapp/               # same kind of structure as "common" was above, done for the fooapp role
            
By default, Ansible will look in most role directories for a main.yml file for relevant content (also main.yaml and main):

- tasks/main.yml - A list of tasks that the role provides to the play for execution.

- handlers/main.yml - handlers that are imported into the parent play for use by the role or other roles and tasks in the play.

- defaults/main.yml - very low precedence values for variables provided by the role (see Using Variables for more information). 
  A role’s own defaults will take priority over other role’s defaults, but any/all other variable sources will override this.

- vars/main.yml - high precedence variables provided by the role to the play (see Using Variables for more information).

- files/stuff.txt - one or more files that are available for the role and it’s children.

- templates/something.j2 - templates to use in the role or child roles.

- meta/main.yml - metadata for the role, including role dependencies and optional Galaxy metadata such as platforms supported. 
  This is required for uploading into galaxy as a standalone role, but not for using the role in your play.    

You can add other YAML files in some directories, but they won’t be used by default. They can be included/imported directly or specified when using include_role/import_role. 
For example, you can place platform-specific tasks in separate files and refer to them in the tasks/main.yml file:

        # roles/example/tasks/main.yml (the actual file the roles looks for and runs)
        - name: Install the correct web server for RHEL
          import_tasks: redhat.yml
          when: ansible_facts['os_family']|lower == 'redhat'
        
        - name: Install the correct web server for Debian
          import_tasks: debian.yml
          when: ansible_facts['os_family']|lower == 'debian'
        
        # roles/example/tasks/redhat.yml (your added files which are not loaded by default when the role is called)
        - name: Install web server
          ansible.builtin.yum:
            name: "httpd"
            state: present
        
        # roles/example/tasks/debian.yml (your added files which are not loaded by default when the role is called)
        - name: Install web server
          ansible.builtin.apt:
            name: "apache2"
            state: present
            
Or call those tasks directly when loading the role, which bypasses the main.yml files and loads your custom  file apt.yml:

        - name: include apt tasks
          include_role:
              name: package_manager_bootstrap
              tasks_from: apt.yml
          when: ansible_facts['os_family'] == 'Debian'            
          
Directories defaults and vars may also include nested directories. If your variables file is a directory, Ansible reads all 
variables files and directories inside in alphabetical order. If a nested directory contains variables files as well as directories, 
Ansible reads the directories first. Below is an example of a vars/main directory:

        roles/
            common/          # this hierarchy represents a "role"
                vars/
                    main/    #  <-- variables associated with this role
                        first_nested_directory/
                            first_variables_file.yml
                        second_nested_directory/
                            second_variables_file.yml
                        third_variables_file.yml   
                        
***Storing and finding roles***
By default, Ansible looks for roles in the following locations:

- in collections, if you are using them

- in a directory called roles/, relative to the playbook file

- in the configured roles_path. The default search path is ~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles.

- in the directory where the playbook file is located

If you store your roles in a different location, set the roles_path configuration option so Ansible can find your roles. 
Checking shared roles into a single location makes them easier to use in multiple playbooks. 
See Configuring Ansible for details about managing settings in ansible.cfg.

Alternatively, you can call a role with a fully qualified path:

        ---
        - hosts: webservers
          roles:
            - role: '/path/to/my/roles/common'  
            
***Using roles***
You can use roles in the following ways:

- at the play level with the roles option: This is the classic way of using roles in a play.

- at the tasks level with include_role: You can reuse roles dynamically anywhere in the tasks section of a play using include_role.

- at the tasks level with import_role: You can reuse roles statically anywhere in the tasks section of a play using import_role.

- as a dependency of another role (see the dependencies keyword in meta/main.yml in this same page).

***Using roles at the play level***   
The classic (original) way to use roles is with the roles option for a given play:

        ---
        - hosts: webservers
          roles:
            - common
            - webservers
            
When you use the roles option at the play level, each role ‘x’ looks for a main.yml (also main.yaml and main) in the following directories:

- roles/x/tasks/

- roles/x/handlers/

- roles/x/vars/

- roles/x/defaults/

- roles/x/meta/

- Any copy, script, template or include tasks (in the role) can reference files in roles/x/{files,templates,tasks}/ (dir depends on task) 
  without having to path them relatively or absolutely.            

Note: If you use include_role/import_role, you can specify a custom file name instead of main. The meta directory is an exception because it does not allow for customization.

When you use the roles option at the play level, Ansible treats the roles as static imports and processes them during playbook parsing. 
Ansible executes each play in this order:

- Any pre_tasks defined in the play.

- Any handlers triggered by pre_tasks.

- Each role listed in roles:, in the order listed. Any role dependencies defined in the role’s meta/main.yml run first, subject to tag filtering and conditionals. See Using role dependencies for more details.

- Any tasks defined in the play.

- Any handlers triggered by the roles or tasks.

- Any post_tasks defined in the play.

- Any handlers triggered by post_tasks.

Note:

If using tags with tasks in a role, be sure to also tag your pre_tasks, post_tasks, and role dependencies and pass those along as well, 
especially if the pre/post tasks and role dependencies are used for monitoring outage window control or load balancing. 

You can pass other keywords to the 'roles' option:

        ---
        - hosts: webservers
          roles:
            - common
            - role: foo_app_instance
              vars:
                dir: '/opt/a'
                app_port: 5000
              tags: typeA
            - role: foo_app_instance
              vars:
                dir: '/opt/b'
                app_port: 5001
              tags: typeB

When you add a tag to the role option, Ansible applies the tag to ALL tasks within the role.

Note:
Prior to ansible-core 2.15, vars: within the roles: section of a playbook are added to the play variables, 
making them available to all tasks within the play before and after the role. On more recent versions, vars: do not leak into the play’s variable scope. 

***Including roles: dynamic reuse***
You can reuse roles dynamically anywhere in the tasks section of a play using include_role. 
While roles added in a roles section run before any other tasks in a play, included roles run in the order they are defined. 
If there are other tasks before an include_role task, the other tasks will run first.

To include a role:

        ---
        - hosts: webservers
          tasks:
            - name: Print a message
              ansible.builtin.debug:
                msg: "this task runs before the example role"
        
            - name: Include the example role
              include_role:
                name: example
        
            - name: Print a message
              ansible.builtin.debug:
                msg: "this task runs after the example role"
        
You can pass other keywords, including variables and tags, when including roles:

        ---
        - hosts: webservers
          tasks:
            - name: Include the foo_app_instance role
              include_role:
                name: foo_app_instance
              vars:
                dir: '/opt/a'
                app_port: 5000
              tags: typeA
          ...

When you add a tag to an include_role task, Ansible applies the tag only to the include itself. 
This means you can pass --tags to run only selected tasks from the role, if those tasks themselves have the same tag as the include statement.

You can conditionally include a role:

        ---
        - hosts: webservers
          tasks:
            - name: Include the some_role role
              include_role:
                name: some_role
              when: "ansible_facts['os_family'] == 'RedHat'"

***Importing roles: static reuse***
You can reuse roles statically anywhere in the tasks section of a play using import_role. The behavior is the same as using the roles keyword. 
For example:

        ---
        - hosts: webservers
          tasks:
            - name: Print a message
              ansible.builtin.debug:
                msg: "before we run our role"
        
            - name: Import the example role
              import_role:
                name: example
        
            - name: Print a message
              ansible.builtin.debug:
                msg: "after we ran our role"
        
You can pass other keywords, including variables and tags when importing roles:

        ---
        - hosts: webservers
          tasks:
            - name: Import the foo_app_instance role
              import_role:
                name: foo_app_instance
              vars:
                dir: '/opt/a'
                app_port: 5000
          ...
          
When you add a tag to an import_role statement, Ansible applies the tag to all tasks within the role. 
See Tag inheritance: adding tags to multiple tasks for details.

***Role argument validation***

See argument_spec.yml

Beginning with version 2.11, you may choose to enable role argument validation based on an argument specification. 
This specification is defined in the meta/argument_specs.yml file (or with the .yaml file extension). 
When this argument specification is defined, a new task is inserted at the beginning of role execution that will validate 
the parameters supplied for the role against the specification. If the parameters fail validation, the role will fail execution.

Notes:

- Ansible also supports role specifications defined in the role meta/main.yml file, as well. 
  However, any role that defines the specs within this file will not work on versions below 2.11. 
  For this reason, we recommend using the meta/argument_specs.yml file to maintain backward compatibility.
- When role argument validation is used on a role that has defined dependencies, then validation on those dependencies 
  will run before the dependent role, even if argument validation fails for the dependent role.
- Ansible tags the inserted role argument validation task with always. If the role is statically imported this task runs unless you use the --skip-tags flag.

***Running a role multiple times in one play***
Ansible only executes each role once in a play, even if you define it multiple times unless the parameters defined on the role are different for each definition. 
For example, Ansible only runs the role foo once in a play like this:

        ---
        - hosts: webservers
          roles:
            - foo
            - bar
            - foo
    
You have two options to force Ansible to run a role more than once.

***Passing different parameters***
If you pass different parameters in each role definition, Ansible runs the role more than once. 
Providing different variable values is not the same as passing different role parameters. 
You must use the roles keyword for this behavior, since import_role and include_role do not accept role parameters.

This play runs the foo role twice:

        ---
        - hosts: webservers
          roles:
            - { role: foo, message: "first" }
            - { role: foo, message: "second" }
        This syntax also runs the foo role twice;
        
        ---
        - hosts: webservers
          roles:
            - role: foo
              message: "first"
            - role: foo
              message: "second"

In these examples, Ansible runs foo twice because each role definition has different parameters.

***Using 'allow_duplicates: true' ***

Add allow_duplicates: true to the meta/main.yml file for the role:

# playbook.yml

        ---
        - hosts: webservers
          roles:
            - foo
            - foo

# roles/foo/meta/main.yml

        ---
        allow_duplicates: true

In this example, Ansible runs foo twice because we have explicitly enabled it to do so.

***Using role dependencies***
Role dependencies let you automatically pull in other roles when using a role.

Role dependencies are prerequisites, not true dependencies. The roles do not have a parent/child relationship. 
Ansible loads all listed roles, runs the roles listed under dependencies first, then runs the role that lists them. 
The play object is the parent of all roles, including roles called by a dependencies list.

Role dependencies are stored in the meta/main.yml file within the role directory. This file should contain a list of roles and parameters to insert before the specified role. For example:

# roles/myapp/meta/main.yml

        ---
        dependencies:
          - role: common
            vars:
              some_parameter: 3
          - role: apache
            vars:
              apache_port: 80
          - role: postgres
            vars:
              dbname: blarg
              other_parameter: 12
              
Ansible always executes roles listed in dependencies before the role that lists them. 
Ansible executes this pattern recursively when you use the roles keyword. 
For example, if you list role foo under roles:, role foo lists role bar under dependencies 
in its meta/main.yml file, and role bar lists role baz under dependencies in its meta/main.yml, Ansible executes baz, then bar, then foo.

***Running role dependencies multiple times in one play***    
Ansible treats duplicate role dependencies like duplicate roles listed under roles.
Ansible only executes role dependencies once, even if defined multiple times, unless the parameters, tags, or when clause defined on the role are different for each definition. 
If two roles in a play both list a third role as a dependency, Ansible only runs that role dependency once, 
unless you pass different parameters, tags, when clause, or use allow_duplicates: true in the role you want to run multiple times.

For example, a role named car depends on a role named wheel as follows:

# roles/car/meta/main.yml

        ---
        dependencies:
          - role: wheel
            n: 1
          - role: wheel
            n: 2
          - role: wheel
            n: 3
          - role: wheel
            n: 4

And the wheel role depends on two roles: tire and brake. The meta/main.yml for wheel would then contain the following:

# roles/wheel/meta/main.yml

        ---
        dependencies:
          - role: tire
          - role: brake

And the meta/main.yml for tire and brake would contain the following:

        ---
        allow_duplicates: true
        
The resulting order of execution would be as follows:

        tire(n=1)
        brake(n=1)
        wheel(n=1)
        tire(n=2)
        brake(n=2)
        wheel(n=2)
        ...
        car

To use allow_duplicates: true with role dependencies, you must specify it for the role listed under dependencies, not for the role that lists it. 
In the example above, allow_duplicates: true appears in the meta/main.yml of the tire and brake roles. 
The wheel role does not require allow_duplicates: true, because each instance defined by car uses different parameter values.