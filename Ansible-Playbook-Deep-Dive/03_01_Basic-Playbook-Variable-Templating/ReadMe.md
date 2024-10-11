This playbook uses Ansible templating to replace variable placeholders with the actual value

# config.j2 is a jinja2 file that has the variable name to be substitude with the actual variable values, where 'code_name' and 'version' are the variables

    name={{code_name}}
    version={{version}}

# template.yml contains the actual value of the variables

    vars:
    code_name: whisky
    version: 4.2

# and copies the config.j2 file after the variables are replaced with their actual value to the config directory using the 'template' module

    task:
        - name: deploy t config file
          template:
          src: config.j2
          dest: config

# Ansible 'delegate_to' allows you to delegate a task to a particular host/server

          delegate_to: localhost

# Ansible also allows you to stipulate how many time you want the a task to run

          run_once: true
