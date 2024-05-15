# ami-facts-1.yml

    Gets the ami information of all RedHat ami's in an account  using a filter module and the wild card "*redhat*".
    It stores/register the result of the task in 'ami_facts'

    - name: Get AMI facts
        amazon.aws.ec2_ami_info:
            aws_access_key: "{{AWS_ACCESS_KEY_ID}}"
            aws_secret_key: "{{AWS_SECRET_ACCESS_KEY}}"
            ec2_region: "{{AWS_REGION}}"
            filters:
            description: "*redhat*"
        register: ami_facts

# ami-facts-2.yml

    Loops through the ami's displaying their id and description using the label and debug module

    - name: Output the facts info
      debug:
        msg: "{{item.description}}"
      loop_control:
        label: "{{item.image_id}}"
      loop: "{{ami_facts.images}}"
