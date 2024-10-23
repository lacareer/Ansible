
***Managing list variables***

You can search for the minimum or maximum value in a list, or flatten a multi-level list.

To get the minimum value from the list of numbers:

    {{ list1 | min }}
    
New in version 2.11.

To get the minimum value in a list of objects:

    {{ [{'val': 1}, {'val': 2}] | min(attribute='val') }}
    
To get the maximum value from a list of numbers:

    {{ [3, 4, 2] | max }}
    
New in version 2.11.

To get the maximum value in a list of objects:

    {{ [{'val': 1}, {'val': 2}] | max(attribute='val') }}
    
New in version 2.5.

Flatten a list (same thing the flatten lookup does):

    {{ [3, [4, 2] ] | flatten }}
    
# => [3, 4, 2]

Flatten only the first level of a list (akin to the items lookup):

    {{ [3, [4, [2]] ] | flatten(levels=1) }}

# => [3, 4, [2]]

New in version 2.11.

Preserve nulls in a list, by default flatten removes them. :

    {{ [3, None, [4, [2]] ] | flatten(levels=1, skip_nulls=False) }}
    
# => [3, None, 4, [2]]

