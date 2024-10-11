<!--How variables are merged-->

By default, variables are merged/flattened to the specific host before a play is run. 

This keeps Ansible focused on the Host and Task, so groups do not survive outside of inventory and host matching. 

By default, Ansible overwrites variables including the ones defined for a group and/or host (see DEFAULT_HASH_BEHAVIOUR). 

The order/precedence is (from lowest to highest):

- 'all' group (because it is the ‘parent’ of all other groups)

- parent group

- child group

- host

By default, Ansible merges groups at the same parent/child level in ASCII order, and variables from the last group loaded overwrite variables from the previous groups. 

For example, an a_group will be merged with b_group and b_group vars that match will overwrite the ones in a_group.


***Note

Ansible merges variables from different sources and applies precedence to some variables over others according to a set of rules. 

For example, variables that occur higher in an inventory can override variables that occur lower in the inventory. 

See Variable precedence: Where should I put a variable? for more information.


You can change this behavior by setting the group variable ansible_group_priority to change the merge order for groups of the same level (after the parent/child order is resolved). 

The larger the number, the later it will be merged, giving it higher priority. 

This variable defaults to 1 if not set. For example:

<!---->

a_group:
  vars:
    testvar: a
    ansible_group_priority: 10
b_group:
  vars:
    testvar: b

<!---->

n this example, if both groups have the same priority, the result would normally have been testvar == b, but since we are giving the a_group a higher priority the result will be testvar == a.

***Note

ansible_group_priority can only be set in the inventory source and not in group_vars/, as the variable is used in the loading of group_vars.