<!--The now function: get the current time-->
New in version 2.8.

The now() Jinja2 function retrieves a Python datetime object or a string representation for the current time.

The now() function supports two arguments:

utc: Specify True to get the current time in UTC. Defaults to False.

fmt: Accepts a strftime string that returns a formatted date time string.

For example: 

    dtg: "Current time (UTC): {{ now(utc=true,fmt='%Y-%m-%d %H:%M:%S') }}"