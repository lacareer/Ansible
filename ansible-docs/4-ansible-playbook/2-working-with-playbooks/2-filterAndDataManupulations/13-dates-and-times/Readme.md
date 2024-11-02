<!--Handling dates and times-->

To get a date object from a string use the to_datetime filter:

# Get the total amount of seconds between two dates. Default date format is %Y-%m-%d %H:%M:%S but you can pass your own format

    {{ (("2016-08-14 20:00:12" | to_datetime) - ("2015-12-25" | to_datetime('%Y-%m-%d'))).total_seconds()  }}

# Get remaining seconds after delta has been calculated. NOTE: This does NOT convert years, days, hours, and so on to seconds. For that, use total_seconds()

    {{ (("2016-08-14 20:00:12" | to_datetime) - ("2016-08-14 18:00:00" | to_datetime)).seconds  }}
    
# This expression evaluates to "12" and not "132". Delta is 2 hours, 12 seconds

# get amount of days between two dates. This returns only the number of days and discards remaining hours, minutes, and seconds

    {{ (("2016-08-14 20:00:12" | to_datetime) - ("2015-12-25" | to_datetime('%Y-%m-%d'))).days  }}
    
    
For a full list of format codes for working with Python date format strings, see the python datetime documentation.

New in version 2.4.

To format a date using a string (like with the shell date command), use the “strftime” filter:

# Display year-month-day

    {{ '%Y-%m-%d' | strftime }}
    
# => "2021-03-19"

# Display hour:min:sec

    {{ '%H:%M:%S' | strftime }}

# => "21:51:04"

# Use ansible_date_time.epoch fact

    {{ '%Y-%m-%d %H:%M:%S' | strftime(ansible_date_time.epoch) }}

# => "2021-03-19 21:54:09"

# Use arbitrary epoch value

    {{ '%Y-%m-%d' | strftime(0) }}          
    
# => 1970-01-01

    {{ '%Y-%m-%d' | strftime(1441357287) }}
    
# => 2015-09-04

New in version 2.13.

strftime takes an optional utc argument, defaulting to False, meaning times are in the local timezone:

    {{ '%H:%M:%S' | strftime }}           # time now in local timezone
    {{ '%H:%M:%S' | strftime(utc=True) }} # time now in UTC

***Note***
To get all string possibilities, check https://docs.python.org/3/library/time.html#time.strftime