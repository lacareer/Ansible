# This task list all the tags associated with the resource and stores it using the register module

     - name: Delete existing keypair
      amazon.aws.ec2_tag:
        aws_access_key: "{{AWS_ACCESS_KEY_ID}}"
        aws_secret_key: "{{AWS_SECRET_ACCESS_KEY}}"
        ec2_region: "{{AWS_REGION}}"
        resource: i-024b030df5d46c6d1
        state: list # will list all the tags associated with the resource
      register: tags

# Grabs the tags from the register module and pick out tags from th dictionary - tags.tags

    - name: Delete existing keypair
      debug:
        var: tags.tags

# Attaches the tags system and version to an existing snapshot

    - name: Add tags to an existing ec2 snapshot resource
      amazon.aws.ec2_tag:
        aws_access_key: "{{AWS_ACCESS_KEY_ID}}"
        aws_secret_key: "{{AWS_SECRET_ACCESS_KEY}}"
        ec2_region: "{{AWS_REGION}}"
        resource: snap-024b030df5d46c6d1
        tags:
          system: erp
          version: 1.2
        state: present
