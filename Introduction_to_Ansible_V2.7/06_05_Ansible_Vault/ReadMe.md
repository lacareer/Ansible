Ansible vault is used to encrypt/decrypt sensitive data that should not be be in plaintext, eg password, keys, secrets.

**\*\*\*** NOTE, THIS FILE MUST BE CREATED ON THE MACHINE. AN ALREADY ENCRYPTED FILE COPIED TO THIS DIRECTORY/MACHINE CAN NOT BE USED TO RUN A PLAYBOOK OR EDITED **\***

# We have first created a vars directory

# Then create an encrypted file, secret-variables.yml, in the the vars directory using Ansible vault like so:

    ansible-vault create vars/secret-variables.yml

# It now prompts you to choose a password for the file

# It now prompts you to confirm the password for the file

# It now open the default environment editor for your machine

# Go ahead and enter the content you want in the soon to be created file,secret-variables.yml, that will have it's content encrypted, eg:

    secret_password : "supersecretpassword123"

# Now press the esc on the keyboard

# press ':wq' to quit and save. This saves the content in the secret-variables.yml file in the vars directory

Edit the Encrypted file in the vars directory

# To edit the encrypted file run:

    ansible-vault edit vars/secret-variables.yml

# Enter the password you created for the file

# If correct, the default editor opens again with the raw content of the file. Edit as needed and close as stated above

Now added the secret password to the setup-app.yml makes sure that the password is provide by the user before the task can be ran.

# To add this secret to the setup-app.yml, the below was added

    vars_files:
      - ../vars/secret-varibles.yml

# If you run the below it returns an error because the file is password protected

    ansible-playbook playbooks/setup-app.yml

To run without error

# Now if you run the below, it prompts you for the password and print the value of the the key 'secret_password' in the encrypted file in plaintext using the 'debug' module to standard output under the task "- name: Use secret password here":

    ansible-playbook playbooks/setup-app.yml --ask-vault-pass

# Enter your password and the tasks in the 'setup-app.yml' playbook will now run and print the password in plaintext

# To view the encrypted file in plaintext run:

    ansible-vault view vars/secret-variables.yml
