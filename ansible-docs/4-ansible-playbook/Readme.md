<!--Using Ansible playbooks-->

Welcome to the Ansible playbooks guide. Playbooks are automation blueprints, in YAML format, that Ansible uses to deploy and configure nodes in an inventory. This guide introduces you to playbooks and then covers different use cases for tasks and plays, such as:

Executing tasks with elevated privileges or as a different user.

Using loops to repeat tasks for items in a list.

Delegating playbooks to execute tasks on different machines.

Running conditional tasks and evaluating conditions with playbook tests.

Using blocks to group sets of tasks.

You can also learn how to use Ansible playbooks more effectively by using collections, creating reusable files and roles, including and importing playbooks, and running selected parts of a playbook with tags.

*** Ansible playbooks
    - Playbook syntax
    - Playbook execution
    - Ansible-Pull
    - Verifying playbooks


*** Working with playbooks
    - Templating (Jinja2)
    - Using filters to manipulate data
    - Tests
    - Lookups
    - Python3 in templates
    - The now function: get the current time
    - The undef function: add hint for undefined variables
    - Loops
    - Controlling where tasks run: delegation and local actions
    - Conditionals
    - Blocks
    - Handlers: running operations on change
    - Error handling in playbooks
    - Setting the remote environment
    - Working with language-specific version managers
    - Re-using Ansible artifacts
    - Roles
    - Module defaults
    - Interactive input: prompts
    - Using Variables
    - Discovering variables: facts and magic variables
    - Playbook Example: Continuous Delivery and Rolling Upgrades


*** Executing playbooks
    - Validating tasks: check mode and diff mode
    - Understanding privilege escalation: become
    - Tags
    - Executing playbooks for troubleshooting
    - Debugging tasks
    - Asynchronous actions and polling
    - Controlling playbook execution: strategies and more
    
    
*** Advanced playbook syntax
    - Unsafe or raw strings
    - YAML anchors and aliases: sharing variable values
    
    
*** Manipulating data
    Loops and list comprehensions
    Complex Type transformations