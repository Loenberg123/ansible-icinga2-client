#!/usr/bin/env python

# Usage: ./check_haproxy.py -u http://your-site.pl

from optparse import OptionParser
import os, sys, urllib2

UNKNOWN = 3
OK = 0
WARNING = 1
CRITICAL = 2

parser = OptionParser()
parser.add_option('-u', '--url', dest='url')

options, args = parser.parse_args()

if not getattr(options, 'url'):
	print 'CRITICAL - %s not specified' % options.url
        #raise SystemExit, CRITICAL
	sys.exit(CRITICAL)

address = options.url+"/haproxy?stats;csv"

web = urllib2.urlopen(address)
log = web.read()
web.close()

list = [[]]
word = ""
j = 0

for i in log:
	if i == "\n":
		j += 1
		list.append([])
	elif i == ",":
		list[j].append(word)
		word = ""
	else:
		word += i

print "Number of connections: %s :: Monitored: %s %s %s/%s  %s %s %s/%s" % (list[1][4],list[6][0],list[6][17],list[6][18],list[6][19],list[9][0],list[9][17],list[9][18],list[9][19])
sum = 0
if sum < 12:
	sys.exit(OK)
elif sum > 12 and sum < 18:
	sys.exit(WARNING)
else:
	sys.exit(CRITICAL)
