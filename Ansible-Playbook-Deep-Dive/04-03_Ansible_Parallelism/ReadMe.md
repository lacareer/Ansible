THIS PLAYBOOK WAS NOT TESTED

# This playbook installs elink on all server in a group or on a particular server

# "max_fail_percentage: 10": set the maximum allowable failure to 10% of the total server. If the threshold is exceeded, the play is terminated

# "serial: 1": Installs the elink on the host one at a time. 'serial' can also be in the forms below

        # Install first on one host, then on 3 host, then on 5 host and the rest if any

        serial:
          - 1
          - 3
          - 5

        # Install first on 10% of host, then on 30% of host, then 50% of host and the rest if any

        serial:
          - "10%"
          - "30%"
          - "50%"

        # Install first on 5 host, then on 30% of the host, then on 50% of the host and the rest if any

        serial:
          - 5
          - "30%"
          - "50%"
