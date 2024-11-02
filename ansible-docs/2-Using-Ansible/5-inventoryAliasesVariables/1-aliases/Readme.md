<!--INI Inventory-->
The host in the group uses the 'jumper01' alias

<!--YAML Inventory-->
The host in the group uses the 'jumper02' alias

<!--Run the below to connect to the host and notice that the alias is displayed not hostnames or ip addresses-->

ansible -i 1a-inventoryAliasesVariables.ini --list-host dbserver01 (displays the alias 'jumper01' as host)


ansible -i 1b-inventoryAliasesVariables.yaml --list-host dbserver02  (displays the alias 'jumper02' as host)