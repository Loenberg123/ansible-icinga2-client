#!/usr/bin/python
import subprocess as sp
import sys,shlex

cmd = sp.Popen(shlex.split("systemctl status nginx.service"),stdout=sp.PIPE)
cmd.wait()

if (cmd.returncode != 3) and (cmd.returncode != 0):
	print "UNKNOWN - Could not get status"
	sys.exit(3)
if (cmd.returncode == 3):
	print "CRITICAL - Nginx is Stoped/Not installed"
	sys.exit(2)
if (cmd.returncode == 0):
	print "OK - Nginx service is running"
	sys.exit(0)
