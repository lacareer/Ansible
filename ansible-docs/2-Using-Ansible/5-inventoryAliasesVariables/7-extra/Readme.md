<!--Example: One inventory per environment -->
If you need to manage multiple environments it is sometimes prudent to have only hosts of a single environment defined per inventory. 

This way, it is harder to, for example, accidentally change the state of nodes inside the “test” environment when you wanted to update some “staging” servers.

For the example mentioned above you could have an inventory_test file:

<!---->
[dbservers]
db01.test.example.com
db02.test.example.com

[appservers]
app01.test.example.com
app02.test.example.com
app03.test.example.com
<!---->

That file only includes hosts that are part of the “test” environment. Define the “staging” machines in another file called inventory_staging:

<!---->
[dbservers]
db01.staging.example.com
db02.staging.example.com

[appservers]
app01.staging.example.com
app02.staging.example.com
app03.staging.example.com
<!---->

To apply a playbook called site.yml to all the app servers in the test environment, use the following command (where "-l" or "--limit" targets a specific group or host):

    ansible-playbook -i inventory_test -l appservers site.yml
    
<!--Example: Group by location-->
Other tasks might be focused on where a certain host is located. 
Let’s say that db01.test.example.com and app01.test.example.com are located in DC1 while db02.test.example.com is in DC2:   

<!---->
[dc1]
db01.test.example.com
app01.test.example.com

[dc2]
db02.test.example.com
<!---->

In practice, you might even end up mixing all these setups as you might need to, on one day, 
update all nodes in a specific data center while, on another day, update all the application servers no matter their location.