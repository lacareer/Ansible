Work through this documentation with hands-on practice to fully understand Ansible

# Reference for Ansible Varibales: https://docs.ansible.com/ansible/latest/user_guide/playbooks_vars_facts.html

# Reference to notes used in the course

    https://lucid.app/lucidchart/a84dc946-b1e3-4da2-9e8b-c44eb0a87cff/view?page=xvHRm.qhwOQq#

# YAML SYNTAX

# Creating a list in yaml

    user:
        -bob
        -john
        -cindy
        -grey

# Creating a dictionary

    user:
        name: bob
        job: engineer
        salary: 60000

# Outputing text on a new line

    include_newlines: |
        This texts will be on a new line
        This texts will be on a new line
        This texts will be on a new line

In total there will be 3 new lines of text with regards to the above using the pipe (|) symbol

# Concatenating text:

    folde_newlines: >
        This texts will all be concatenated on the same line
        This texts will all be concatenated on the same line
        This texts will all be concatenated on the same line

In total there will just 1 line of text with regards to the above using the greater than (>) symbol

# Special characters in yaml are:

    [], {}, :, >, |

# When to use double, "", quotes

    1.  If a colon ends a line or is followed by a space
    2.  Contains special character that are meant to be literals like when used to enclosed a variable
    3.  When using  special characters to enclose a variable

# Ansible variables are indicated with curly braces and because the braces are special characters in yaml, they are enclosed in double quotes

    "{{variable}}"

**\*\*\*\***\*\***\*\*\*\***\*\***\*\*\*\***\*\***\*\*\*\*** PLAYBOOKS **\*\*\*\***\*\***\*\*\*\***\*\*\*\***\*\*\*\***\*\***\*\*\*\***

# To see ansible-playbook command options run:

    man ansible-playbook

# To run the playbooks, for example ping.yml. Same applies for all other playbooks, you just replace the file ping.yml with the actual file

    ansible-playbook -i inv playbooks/ping.yml (used only when server is localhost)

# OR

    ansible-playbook playbooks/ping.yml (works for remote or locahost servers)
