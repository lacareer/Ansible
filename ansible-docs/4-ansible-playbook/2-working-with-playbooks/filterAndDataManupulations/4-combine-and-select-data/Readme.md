<!--Combining and selecting data-->

You can combine data from multiple sources and types, and select values from large data structures, giving you precise control over complex data.

***Combining items from multiple lists: zip and zip_longest**

New in version 2.3.
To get a list combining the elements of other lists use ansible.builtin.zip:    

    - name: Give me list combo of two lists
      ansible.builtin.debug:
        msg: "{{ [1,2,3,4,5,6] | zip(['a','b','c','d','e','f']) | list }}"

# Results in => [[1, "a"], [2, "b"], [3, "c"], [4, "d"], [5, "e"], [6, "f"]]

    - name: Give me the shortest combo of two lists
      ansible.builtin.debug:
        msg: "{{ [1,2,3] | zip(['a','b','c','d','e','f']) | list }}"

# Result in => [[1, "a"], [2, "b"], [3, "c"]]

To always exhaust all lists use ansible.builtin.zip_longest:

    - name: Give me the longest combo of three lists, fill with X
      ansible.builtin.debug:
        msg: "{{ [1,2,3] | zip_longest(['a','b','c','d','e','f'], [21, 22, 23], fillvalue='X') | list }}"

# Resultin => [[1, "a", 21], [2, "b", 22], [3, "c", 23], ["X", "d", "X"], ["X", "e", "X"], ["X", "f", "X"]]

Similarly to the output of the ansible.builtin.items2dict filter mentioned above, these filters can be used to construct a dict:

    {{ dict(keys_list | zip(values_list)) }}
    
List data (before applying the ansible.builtin.zip filter):

    keys_list:
      - one
      - two
    values_list:
      - apple
      - orange
      
Dictionary data (after applying the ansible.builtin.zip filter):

    one: apple
    two: orange
    
*** Combining objects and subelements***
New in version 2.7.

The ansible.builtin.subelements filter produces a product of an object and the subelement values of that object, similar to the ansible.builtin.subelements lookup. 
This lets you specify individual subelements to use in a template. For example, this expression:

    {{ users | subelements('groups', skip_missing=True) }}

Data before applying the ansible.builtin.subelements filter:

    users:
    - name: alice
      authorized:
      - /tmp/alice/onekey.pub
      - /tmp/alice/twokey.pub
      groups:
      - wheel
      - docker
    - name: bob
      authorized:
      - /tmp/bob/id_rsa.pub
      groups:
      - docker
      
Data after applying the ansible.builtin.subelements filter:

    -
      - name: alice
        groups:
        - wheel
        - docker
        authorized:
        - /tmp/alice/onekey.pub
        - /tmp/alice/twokey.pub
      - wheel
    -
      - name: alice
        groups:
        - wheel
        - docker
        authorized:
        - /tmp/alice/onekey.pub
        - /tmp/alice/twokey.pub
      - docker
    -
      - name: bob
        authorized:
        - /tmp/bob/id_rsa.pub
        groups:
        - docker
      - docker
      
You can use the transformed data with loop to iterate over the same subelement for multiple objects:

    - name: Set authorized ssh key, extracting just that data from 'users'
      ansible.posix.authorized_key:
        user: "{{ item.0.name }}"
        key: "{{ lookup('file', item.1) }}"
      loop: "{{ users | subelements('authorized') }}"
      
Sample playbook uisng subelements:

    ---
    - name: Example playbook using subelements
      hosts: localhost
      vars:
        users:
          - name: alice
            authorized:
              - /tmp/alice/onekey.pub
              - /tmp/alice/twokey.pub
          - name: bob
            authorized:
              - /tmp/bob/id_rsa.pub
      tasks:
        - name: Set authorized ssh key for users
          ansible.posix.authorized_key:
            user: "{{ item.0.name }}"
            key: "{{ lookup('file', item.1) }}"
          loop: "{{ query('ansible.builtin.subelements', users, 'authorized') }}"
          
***Combining hashes/dictionaries***

New in version 2.0.

The ansible.builtin.combine filter allows hashes to be merged. For example, the following would override keys in one hash:

    {{ {'a':1, 'b':2} | combine({'b':3}) }}
    
The resulting hash would be:    

    {'a':1, 'b':3}
    
The filter can also take multiple arguments to merge:

    {{ a | combine(b, c, d) }}
    {{ [a, b, c, d] | combine }}
    
In this case, keys in d would override those in c, which would override those in b, and so on.

The filter also accepts two optional parameters: recursive and list_merge. 

<!--recursive-->
Is a boolean, default to False. Should the ansible.builtin.combine recursively merge nested hashes. 
Note: It does not depend on the value of the hash_behaviour setting in ansible.cfg.

<!--list_merge-->
Is a string, its possible values are replace (default), keep, append, prepend, append_rp or prepend_rp. 
It modifies the behavior of ansible.builtin.combine when the hashes to merge contain arrays/lists.

e.g data to illustrate

    default:
      a:
        x: default
        y: default
      b: default
      c: default
    patch:
      a:
        y: patch
        z: patch
      b: patch

If recursive=False (the default), nested hash aren’t merged using above datat:

    {{ default | combine(patch) }}
    
This would result in:

    a:
      y: patch
      z: patch
    b: patch
    c: default
    
If recursive=True, recurse into a nested hash and merge their keys:

    {{ default | combine(patch, recursive=True) }}
    
This would result in:  

    a:
      x: default
      y: patch
      z: patch
    b: patch
    c: default
    
If list_merge='replace' (the default), arrays from the right hash will “replace” the ones in the left hash:

    default:
      a:
        - default
    patch:
      a:
        - patch
        
Using the 'combine' filter in  default mode

    {{ default | combine(patch) }}
    
This would result in:

    a:
      - patch

If list_merge='keep', arrays from the left hash will be kept:

    {{ default | combine(patch, list_merge='keep') }}

This would result in:

    a:
      - default 
      
If list_merge='append', arrays from the right hash will be appended to the ones in the left hash:

    {{ default | combine(patch, list_merge='append') }}

This would result in:

    a:
      - default
      - patch

If list_merge='prepend', arrays from the right hash will be prepended to the ones in the left hash:

    {{ default | combine(patch, list_merge='prepend') }}

This would result in:

    a:
      - patch
      - default

If list_merge='append_rp', arrays from the right hash will be appended to the ones in the left hash. 
Elements of arrays in the left hash that are also in the corresponding array of the right hash will be removed (“rp” stands for “remove present”). 
Duplicate elements that aren’t in both hashes are kept:

    {{ default | combine(patch, list_merge='append_rp') }}
    
This would result in:

    a:
      - 1
      - 1
      - 2
      - 3
      - 4
      - 5
      - 5
      
If list_merge='prepend_rp', the behavior is similar to the one for append_rp, but elements of arrays in the right hash are prepended:

    {{ default | combine(patch, list_merge='prepend_rp') }}
    
This would result in:

    a:
      - 3
      - 4
      - 5
      - 5
      - 1
      - 1
      - 2

recursive and list_merge can be used together:

    default:
      a:
        a':
          x: default_value
          y: default_value
          list:
            - default_value
      b:
        - 1
        - 1
        - 2
        - 3
    patch:
      a:
        a':
          y: patch_value
          z: patch_value
          list:
            - patch_value
      b:
        - 3
        - 4
        - 4
        - key: value      

Using the combine filter plugin

    {{ default | combine(patch, recursive=True, list_merge='append_rp') }}

This would result in:

    a:
      a':
        x: default_value
        y: patch_value
        z: patch_value
        list:
          - default_value
          - patch_value
    b:
      - 1
      - 1
      - 2
      - 3
      - 4
      - 4
      - key: value
      
<!--Selecting values from arrays or hashtables-->
New in version 2.1.

The extract filter is used to map from a list of indices to a list of values from a container (hash or array):      

    {{ [0,2] | map('extract', ['x','y','z']) | list }}
    {{ ['x','y'] | map('extract', {'x': 42, 'y': 31}) | list }}
    
The results of the above expressions would be respectively:

    ['x', 'z']
    [42, 31]
    
The filter can take another argument:

    {{ groups['x'] | map('extract', hostvars, 'ec2_ip_address') | list }}
    
This takes the list of hosts in group ‘x’, looks them up in hostvars, and then looks up the ec2_ip_address of the result. 
The final result is a list of IP addresses for the hosts in group ‘x’.

The third argument to the filter can also be a list, for a recursive lookup inside the container:

    {{ ['a'] | map('extract', b, ['x','y']) | list }}
    
This would return a list containing the value of b[‘a’][‘x’][‘y’].

<!--Combining lists   -->

Combinations always require a set size:

    - name: Give me combinations for sets of two
      ansible.builtin.debug:
        msg: "{{ [1,2,3,4,5] | ansible.builtin.combinations(2) | list }}"
        
<!--products-->
The product filter returns the cartesian product of the input iterables. This is roughly equivalent to nested for-loops in a generator expression.

For example:

    - name: Generate multiple hostnames
      ansible.builtin.debug:
        msg: "{{ ['foo', 'bar'] | product(['com']) | map('join', '.') | join(',') }}"

This would result in:

    { "msg": "foo.com,bar.com" }  
    
<!--Selecting JSON data: JSON queries-->
To select a single element or a data subset from a complex data structure in JSON format (for example, Ansible facts), use the community.general.json_query filter. 
The community.general.json_query filter lets you query a complex JSON structure and iterate over it using a loop structure. 

***Note**

- This filter has migrated to the community.general collection. Follow the installation instructions to install that collection.
- You must manually install the jmespath dependency on the Ansible control node before using this filter. This filter is built upon jmespath, 
and you can use the same syntax. For examples, see jmespath examples.

Consider this data structure:

    {
        "domain": {
            "cluster": [
                {
                    "name": "cluster1"
                },
                {
                    "name": "cluster2"
                }
            ],
            "server": [
                {
                    "name": "server11",
                    "cluster": "cluster1",
                    "port": "8080"
                },
                {
                    "name": "server12",
                    "cluster": "cluster1",
                    "port": "8090"
                },
                {
                    "name": "server21",
                    "cluster": "cluster2",
                    "port": "9080"
                },
                {
                    "name": "server22",
                    "cluster": "cluster2",
                    "port": "9090"
                }
            ],
            "library": [
                {
                    "name": "lib1",
                    "target": "cluster1"
                },
                {
                    "name": "lib2",
                    "target": "cluster2"
                }
            ]
        }
    }
    
To extract all clusters from this structure, you can use the following query:

    - name: Display all cluster names
      ansible.builtin.debug:
        var: item
      loop: "{{ domain_definition | community.general.json_query('domain.cluster[*].name') }}"

To extract all server names:

    - name: Display all server names
      ansible.builtin.debug:
        var: item
      loop: "{{ domain_definition | community.general.json_query('domain.server[*].name') }}"

To extract ports from cluster1, using a variable to make the query more readable.:

    - name: Display all ports from cluster1
      ansible.builtin.debug:
        var: item
      loop: "{{ domain_definition | community.general.json_query(server_name_cluster1_query) }}"
      vars:
        server_name_cluster1_query: "domain.server[?cluster=='cluster1'].port"
        
To print out the ports from cluster1 in a comma-separated string:
***Note
In the example below, quoting literals using backticks avoids escaping quotes and maintains readability.

    - name: Display all ports from cluster1 as a string
      ansible.builtin.debug:
        msg: "{{ domain_definition | community.general.json_query('domain.server[?cluster==`cluster1`].port') | join(', ') }}"
        
You can use YAML single quote escaping to achieve same:

    - name: Display all ports from cluster1
      ansible.builtin.debug:
        var: item
      loop: "{{ domain_definition | community.general.json_query('domain.server[?cluster==''cluster1''].port') }}"  

Note that escaping single quotes within single quotes in YAML is done by doubling the single quote as shown above.

To get a hash map with all ports and names of a cluster:

    - name: Display all server ports and names from cluster1
      ansible.builtin.debug:
        var: item
      loop: "{{ domain_definition | community.general.json_query(server_name_cluster1_query) }}"
      vars:
        server_name_cluster1_query: "domain.server[?cluster=='cluster1'].{name: name, port: port}"

***Note

while using starts_with and contains, you have to use `` to_json | from_json `` filter for correct parsing of data structure.

To extract ports from all clusters with the name starting with ‘server1’:

    - name: Display ports from all clusters with the name starting with 'server1'
      ansible.builtin.debug:
        msg: "{{ domain_definition | to_json | from_json | community.general.json_query(server_name_query) }}"
      vars:
        server_name_query: "domain.server[?starts_with(name,'server1')].port"

To extract ports from all clusters with the name containing ‘server1’:

    - name: Display ports from all clusters with the name containing 'server1'
      ansible.builtin.debug:
        msg: "{{ domain_definition | to_json | from_json | community.general.json_query(server_name_query) }}"
      vars:
        server_name_query: "domain.server[?contains(name,'server1')].port"