# REFERENCES : https://docs.ansible.com/ansible/latest/user_guide/playbooks_prompts.html

# REFERENCES: https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html#the-when-statement

Here we are working on the setup-app.yml file to demonstrate how to use prompts, save the prompts as a variable and to apply conditional logic to the user input.

# We have added 2 prompts as shown below and saved in the upload_var and create_var respectively

        vars_prompt:
      - name: "upload_var"
        prompt: "Upload the index.php file?"

      - name: "create_var"
        prompt: "Create info.php page?"

# Now we are use 'when' module to determine when or not to run the tasks below. If the user enters 'yes' the 'Upload application file' tasks run and so too for 'Create simple info page'. If the user enters 'no' or any other input beside 'yes' the tasks are skipped and do not run

    tasks:
      - name: Upload application file
        copy:
          src: ../index.php
          dest: "{{ path_to_app }}"
          mode: 0755
        when: upload_var == 'yes'
        tags: upload

      - name: Create simple info page
        copy:
          dest: "{{ path_to_app }}/info.php"
          content: "<h1> Info about our webserver {{ ansible_hostname }}. These are changes. </h1>"
        when: create_var == 'yes'
        tags: create

# Now run the playbook, like so:

    ansible-playbook playbooks/setup-app.yml

# It prompts you with the questions "Upload the index.php file?" and "Create info.php page?" sequentially as shown in the code below. You must enter yes if you want anyone of the task assigned that prompt to run. Any other input will skipp the particular task without a 'yes' answer to the prompt
