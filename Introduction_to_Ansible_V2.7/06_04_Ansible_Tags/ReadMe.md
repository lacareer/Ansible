You can use tags to run or skip a particular task/s in our playbook.

In this exercise we will be working with the setup-app.yml file in the playbook directory.

# We have added tags to this two Ansible task as shown below. Also note that a task can have more than one tag.

     tasks:
      - name: Upload application file
        copy:
          src: ../index.php
          dest: "{{ path_to_app }}"
          mode: 0755
        tags: upload

      - name: Create simple info page
        copy:
          dest: "{{ path_to_app }}/info.php"
          content: "<h1> Info about our webserver {{ ansible_hostname }}. These are changes. </h1>"
        tags: create

# Now to run only the 'upload' task using tag, run:

    ansible-playbook playbooks/setup-app.yml --tag upload (OR)
    ansible-playbook playbooks/setup-app.yml --t upload (SAME ABBREVIATION OF TAGS CAN BE USE FOR ALL COMMANDS BELOW)

# Now to run only the 'create' task using tag, run:

    ansible-playbook playbooks/setup-app.yml --tag create

# Note that because a task can have more than one tag, If you add the tag 'create' to the task 'Upload application file' it will also run if we run the above command

# To run the 'create' and 'upload' tags, run:

    ansible-playbook playbooks/setup-app.yml --tag upload, create

# Skipping task using tags. This runs all task but the task with the specified tag. To skipp the Ansible task with the 'upload' tag run:

    ansible-playbook playbooks/setup-app.yml --skip-tags upload

# Skipping task using tags. This runs all task but the task with the specified tag. To skipp the Ansible task with the 'create' tag run:

    ansible-playbook playbooks/setup-app.yml --skip-tags create
