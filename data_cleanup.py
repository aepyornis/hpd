"""
Use: python data_cleanup.py [number-of-columns-in-file] 1> good_data 2> bad_data

Fixes some problems that occur in HPD data:
  * removes errant quotes (")
  * re-directs lines that are too long to stderr

The "Registrations" file has 16 columns.
The "Contacts" file has 15 columns.

This applies to the most recent version. Older files may have different number of columns.

"""
import sys

for line in sys.stdin.readlines():
    row = line.replace('"', '')
    number_of_fields = len(row.split('|'))
    if number_of_fields == int(sys.argv[1]):
        sys.stdout.write(row)
    else:
        sys.stderr.write(row)
        
