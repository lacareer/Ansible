<!--Randomizing data-->
When you need a randomly generated value, use one of these filters.

***Random MAC addresses***

New in version 2.6.

This filter can be used to generate a random MAC address from a string prefix.

Note

This filter has migrated to the community.general collection. Follow the installation instructions to install that collection.

To get a random MAC address from a string prefix starting with ‘52:54:00’:

    "{{ '52:54:00' | community.general.random_mac }}"
    
    # => '52:54:00:ef:1c:03'
    
Note that if anything is wrong with the prefix string, the filter will issue an error.

New in version 2.9.

As of Ansible version 2.9, you can also initialize the random number generator from a seed to create random-but-idempotent MAC addresses:

    "{{ '52:54:00' | community.general.random_mac(seed=inventory_hostname) }}

***Random items or numbers***
The ansible.builtin.random filter in Ansible is an extension of the default Jinja2 random filter, and can be used to return a random item from a sequence of items or to generate a random number based on a range.

To get a random item from a list:

    "{{ ['a','b','c'] | random }}"
    
    # => 'c'
    
To get a random number between 0 (inclusive) and a specified integer (exclusive):

    "{{ 60 | random }} * * * * root /script/from/cron"

    
    # => '21 * * * * root /script/from/cron'
    
To get a random number from 0 to 100 but in steps of 10:

    {{ 101 | random(step=10) }}
    
    # => 70

To get a random number from 1 to 100 but in steps of 10:

    {{ 101 | random(1, 10) }}
    
    # => 31

And

    {{ 101 | random(start=1, step=10) }}
    
    # => 51    
    
You can initialize the random number generator from a seed to create random-but-idempotent numbers:

    "{{ 60 | random(seed=inventory_hostname) }} * * * * root /script/from/cron"
    
***Shuffling a list***

The ansible.builtin.shuffle filter randomizes an existing list, giving a different order for every invocation.

To get a random list from an existing list:

    {{ ['a','b','c'] | shuffle }}
    
# => ['c','a','b']

    {{ ['a','b','c'] | shuffle }}
    
# => ['b','c','a']

You can initialize the shuffle generator from a seed to generate a random-but-idempotent order:

    {{ ['a','b','c'] | shuffle(seed=inventory_hostname) }}
    
# => ['b','a','c']

The shuffle filter returns a list whenever possible. If you use it with a non ‘listable’ item, the filter does nothing.
