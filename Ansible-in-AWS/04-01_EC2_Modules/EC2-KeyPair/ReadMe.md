# Deletes an existing keypair on aws called 'my_keypair'

- name: Delete existing keypair
  amazon.aws.ec2_key:
  aws_access_key: "{{AWS_ACCESS_KEY_ID}}"
  aws_secret_key: "{{AWS_SECRET_ACCESS_KEY}}"
  ec2_region: "{{AWS_REGION}}"
  name: my_keypair
  state: absent

# Creates a new keypair on aws with the name 'my_keypair'

- name: Create a new keypair
  amazon.aws.ec2_key:
  aws_access_key: "{{AWS_ACCESS_KEY_ID}}"
  aws_secret_key: "{{AWS_SECRET_ACCESS_KEY}}"
  ec2_region: "{{AWS_REGION}}"
  name: my_keypair
  register: keypair

# Writes the new keypair just created to the download directory

- name: Write the new keypair to a location
  lineinfile:
  create: yes
  path: ~/Downloads/my_keypair.pem
  line: "{{keypair.key.private_key}}"
  mode: 0600
