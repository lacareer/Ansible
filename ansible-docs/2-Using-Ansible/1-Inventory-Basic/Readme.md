 <!-- MAKE SURE TO BE IN THE DIRECTORY OF THE 1a-Inventory-Basic.ini and 1b-Inventory-Basic.yaml -->
 <!-- Run the following command: -->


    ansible -i 1a-Inventory-Basic.ini --list-host all
    ansible -i 1b-Inventory-Basic.yaml --list-host all


    ansible -i 1a-Inventory-Basic.ini --list-host webservers
    ansible -i 1b-Inventory-Basic.yaml --list-host dbservers
    
 
    ansible-inventory -i 1a-Inventory-Basic.ini --list
    ansible-inventory -i 1b-Inventory-Basic.yaml --list
    
    ansible --list-host all