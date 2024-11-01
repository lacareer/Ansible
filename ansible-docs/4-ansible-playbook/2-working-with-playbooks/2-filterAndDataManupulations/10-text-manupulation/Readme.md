<!--Manipulating text-->
Several filters work with text, including URLs, file names, and path names.

***Adding comments to files***
The ansible.builtin.comment filter lets you create comments in a file from text in a template, with a variety of comment styles. 
By default, Ansible uses # to start a comment line and adds a blank comment line above and below your comment text. For example the following:

    {{ "Plain style (default)" | comment }}
    
produces this output:

    #
    # Plain style (default)
    #
    
Ansible offers styles for comments in C (//...), C block (/*...*/), Erlang (%...) and XML (<!--...-->):

    {{ "C style" | comment('c') }}
    {{ "C block style" | comment('cblock') }}
    {{ "Erlang style" | comment('erlang') }}
    {{ "XML style" | comment('xml') }}
    
You can define a custom comment character. This filter:

    {{ "My Special Case" | comment(decoration="! ") }}

produces:

    !
    ! My Special Case
    !   

You can fully customize the comment style:

    {{ "Custom style" | comment('plain', prefix='#######\n#', postfix='#\n#######\n   ###\n    #') }}
    
That creates the following output:

    #######
    #
    # Custom style
    #
    #######
       ###
        #
        
The filter can also be applied to any Ansible variable. For example, to make the output of the ansible_managed variable more readable, we can change the definition in the ansible.cfg file to this:

    [defaults]
    ansible_managed = This file is managed by Ansible.%n
      template: {file}
      date: %Y-%m-%d %H:%M:%S
      user: {uid}
      host: {host}
      
and then use the variable with the comment filter:

    {{ ansible_managed | comment }}
    
which produces this output:

    #
    # This file is managed by Ansible.
    #
    # template: /home/ansible/env/dev/ansible_managed/roles/role1/templates/test.j2
    # date: 2015-09-10 11:02:58
    # user: ansible
    # host: myhost
    #
    
***URLEncode Variables***
The urlencode filter quotes data for use in a URL path or query using UTF-8:

    {{ 'Trollhättan' | urlencode }}
    
# => 'Trollh%C3%A4ttan'

***Splitting URLs***
New in version 2.4.

The ansible.builtin.urlsplit filter extracts the fragment, hostname, netloc, password, path, port, query, scheme, and username from an URL. 
With no arguments, returns a dictionary of all the fields:

    {{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('hostname') }}

# => 'www.acme.com'

    {{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('netloc') }}
    
# => 'user:password@www.acme.com:9000'

    {{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('username') }}
    
# => 'user'

    {{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('password') }}
    
# => 'password'

    {{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('path') }}
    
# => '/dir/index.html'

    {{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('port') }}

# => '9000'

    {{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('scheme') }}

# => 'http'

    {{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('query') }}

# => 'query=term'

    {{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('fragment') }}
    
# => 'fragment'

    {{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit }}
    
# =>
    #   {
    #       "fragment": "fragment",
    #       "hostname": "www.acme.com",
    #       "netloc": "user:password@www.acme.com:9000",
    #       "password": "password",
    #       "path": "/dir/index.html",
    #       "port": 9000,
    #       "query": "query=term",
    #       "scheme": "http",
    #       "username": "user"
    #   }
    
***Searching strings with regular expressions***
To search in a string or extract parts of a string with a regular expression, use the ansible.builtin.regex_search filter:

# Extracts the database name from a string

    {{ 'server1/database42' | regex_search('database[0-9]+') }}
    
# => 'database42'

# Example for a case insensitive search in multiline mode

    {{ 'foo\nBAR' | regex_search('^bar', multiline=True, ignorecase=True) }}
    
# => 'BAR'

# Example for a case insensitive search in multiline mode using inline regex flags

    {{ 'foo\nBAR' | regex_search('(?im)^bar') }}
    
# => 'BAR'

# Extracts server and database id from a string

    {{ 'server1/database42' | regex_search('server([0-9]+)/database([0-9]+)', '\\1', '\\2') }}

# => ['1', '42']

# Extracts dividend and divisor from a division

    {{ '21/42' | regex_search('(?P<dividend>[0-9]+)/(?P<divisor>[0-9]+)', '\\g<dividend>', '\\g<divisor>') }}

# => ['21', '42']

The ansible.builtin.regex_search filter returns an empty string if it cannot find a match:

    {{ 'ansible' | regex_search('foobar') }}
    
# => ''

***NOTE***

The ansible.builtin.regex_search filter returns None when used in a Jinja expression (for example in conjunction with operators, other filters, and so on). See the two examples below.

    {{ 'ansible' | regex_search('foobar') == '' }}
    
# => False

    {{ 'ansible' | regex_search('foobar') is none }}
    
# => True

This is due to historic behavior and the custom re-implementation of some of the Jinja internals in Ansible. 
Enable the jinja2_native setting if you want the ansible.builtin.regex_search filter to always return None if it cannot find a match. 
See Why does the regex_search filter return None instead of an empty string? for details.

To extract all occurrences of regex matches in a string, use the ansible.builtin.regex_findall filter:

# Returns a list of all IPv4 addresses in the string

    {{ 'Some DNS servers are 8.8.8.8 and 8.8.4.4' | regex_findall('\\b(?:[0-9]{1,3}\\.){3}[0-9]{1,3}\\b') }}
    
# => ['8.8.8.8', '8.8.4.4']

# Returns all lines that end with "ar"

    {{ 'CAR\ntar\nfoo\nbar\n' | regex_findall('^.ar$', multiline=True, ignorecase=True) }}

# => ['CAR', 'tar', 'bar']

# Returns all lines that end with "ar" using inline regex flags for multiline and ignorecase

    {{ 'CAR\ntar\nfoo\nbar\n' | regex_findall('(?im)^.ar$') }}

# => ['CAR', 'tar', 'bar']

***Note

If you want to match the whole string and you are using * make sure to always wraparound your regular expression with the start/end anchors. 
For example ^(.*)$ will always match only one result, while (.*) on some Python versions will match the whole string and an empty string at the end, which means it will make two replacements:

# add "https://" prefix to each item in a list
GOOD:

    {{ hosts | map('regex_replace', '^(.*)$', 'https://\\1') | list }}
    {{ hosts | map('regex_replace', '(.+)', 'https://\\1') | list }}
    {{ hosts | map('regex_replace', '^', 'https://') | list }}

BAD:

    {{ hosts | map('regex_replace', '(.*)', 'https://\\1') | list }}

# append ':80' to each item in a list

GOOD:

    {{ hosts | map('regex_replace', '^(.*)$', '\\1:80') | list }}
    {{ hosts | map('regex_replace', '(.+)', '\\1:80') | list }}
    {{ hosts | map('regex_replace', '$', ':80') | list }}

BAD:

    {{ hosts | map('regex_replace', '(.*)', '\\1:80') | list }}

***Managing file names and path names***    
    
To get the last name of a file path, like ‘foo.txt’ out of ‘/etc/asdf/foo.txt’:

    {{ path | basename }}
    
To get the last name of a Windows style file path (new in version 2.0):

    {{ path | win_basename }}

To separate the Windows drive letter from the rest of a file path (new in version 2.0):

    {{ path | win_splitdrive }}
    
To get only the Windows drive letter:

    {{ path | win_splitdrive | first }}
    
To get the rest of the path without the drive letter:

    {{ path | win_splitdrive | last }}
    
To get the directory from a path:

    {{ path | dirname }}
    
To get the directory from a Windows path (new version 2.0):

    {{ path | win_dirname }}
    
To expand a path containing a tilde (~) character (new in version 1.5):

    {{ path | expanduser }}
    
To expand a path containing environment variables:

    {{ path | expandvars }}
    
New in version 2.6.

To get the real path of a link (new in version 1.8):

    {{ path | realpath }}
    
To get the relative path of a link, from a start point (new in version 1.7):

    {{ path | relpath('/etc') }}
    
To get the root and extension of a path or file name (new in version 2.0):

# with path == 'nginx.conf' the return would be ('nginx', '.conf')

    {{ path | splitext }}
    
The ansible.builtin.splitext filter always returns a pair of strings. The individual components can be accessed by using the first and last filters:

# with path == 'nginx.conf' the return would be 'nginx'

    {{ path | splitext | first }}

# with path == 'nginx.conf' the return would be '.conf'

    {{ path | splitext | last }}
    
To join one or more path components:

    {{ ('/etc', path, 'subdir', file) | path_join }}

New in version 2.10.