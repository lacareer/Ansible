<!--***Selecting from sets or lists (set theory)***-->
You can select or combine items from sets or lists.

New in version 1.4.

To get a unique set from a list:

Given the data list1: [1, 2, 5, 1, 3, 4, 10]

    {{ list1 | unique }}
    
# => [1, 2, 5, 3, 4, 10]

To get a union of two lists:

# list1: [1, 2, 5, 1, 3, 4, 10]
# list2: [1, 2, 3, 4, 5, 11, 99]

    {{ list1 | union(list2) }}
    
# => [1, 2, 5, 1, 3, 4, 10, 11, 99]

To get the intersection of 2 lists (unique list of all items in both):

# list1: [1, 2, 5, 3, 4, 10]
# list2: [1, 2, 3, 4, 5, 11, 99]

    {{ list1 | intersect(list2) }}
    
# => [1, 2, 5, 3, 4]

To get the difference of 2 lists (items in 1 that don’t exist in 2):

# list1: [1, 2, 5, 1, 3, 4, 10]
# list2: [1, 2, 3, 4, 5, 11, 99]

    {{ list1 | difference(list2) }}

# => [10]

To get the symmetric difference of 2 lists (items exclusive to each list):

# list1: [1, 2, 5, 1, 3, 4, 10]
# list2: [1, 2, 3, 4, 5, 11, 99]

    {{ list1 | symmetric_difference(list2) }}
    
# => [10, 11, 99]

<!--***Calculating numbers (math)***-->
New in version 1.9.

You can calculate logs, powers, and roots of numbers with Ansible filters. Jinja2 provides other mathematical functions like abs() and round().

Get the logarithm (default is e):

    {{ 8 | log }}
    
# => 2.0794415416798357

Get the base 10 logarithm:

    {{ 8 | log(10) }}
    
# => 0.9030899869919435

Give me the power of 2! (or 5):

    {{ 8 | pow(5) }}
    
# => 32768.0
Square root, or the 5th:

    {{ 8 | root }}

# => 2.8284271247461903

    {{ 8 | root(5) }}
    
# => 1.5157165665103982
    