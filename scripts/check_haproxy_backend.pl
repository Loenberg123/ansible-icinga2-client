#!/usr/bin/perl
# Author: Soren "Svindler" Hansen
# Version: 0.1
# Will test a HAProxy proxyname for active sessions

# Assumes there is a configuration on the HAProxy that sort of looks like this
#listen stats 0.0.0.0:8000
#    mode http
#    stats enable
#    stats uri /haproxy
#    stats realm HAProxy
#    stats auth hauser:hapasswd

use lib "/usr/lib/nagios/plugins";
use utils qw(%ERRORS $TIMEOUT);


use strict;
use warnings;
use LWP::Simple;
use Getopt::Std;
use Text::CSV_XS;

my %options=();
getopts("H:U:P:p:u:x:", \%options);

my $host = "localhost";
my $user = "hauser";
my $passwd = "hapasswd";
my $port = 8000;
my $uri = "/haproxy";
my $proxy = "stats";

$host = $options{H} if defined $options{H};
$user = $options{U} if defined $options{U};
$passwd = $options{P} if defined $options{P};
$port = $options{p} if defined $options{p};
$uri = $options{u} if defined $options{u};
$proxy = $options{x} if defined $options{x};

my $url = "http://" . $user . ":" . $passwd . "\@" . $host . ":" . $port . $uri . "\;csv";
#print $url . "\n\n";
my @csv = split /\n/, get($url);

# pxname,svname,qcur,qmax,scur,smax,slim,stot,bin,bout,dreq,dresp,ereq,econ,eresp,wretr,wredis,status,weight,act,bck,chkfail,chkdown,lastchg,downtime,qlimit,pid,iid,sid,throttle,lbtot,tracked,type,rate,rate_lim,rate_max,check_status,check_code,check_duration,hrsp_1xx,hrsp_2xx,hrsp_3xx,hrsp_4xx,hrsp_5xx,hrsp_other,hanafail,req_rate,req_rate_max,req_tot,cli_abrt,srv_abrt,

#print grep(/$proxy\,BACKEND\,/, @csv);

my @line = grep(/$proxy\,BACKEND\,/, @csv);

my @vars = split(/,/, $line[0]);
my $pxname = $vars[0];
my $svname = $vars[1];
my $qcur = $vars[2];
my $qmax = $vars[3];
my $scur = $vars[4];
my $smax = $vars[5];
my $slim = $vars[6];
my $stot = $vars[7];
my $bin = $vars[8];
my $bout = $vars[9];
my $dreq = $vars[10];
my $dresp = $vars[11];
my $ereq = $vars[12];
my $econ = $vars[13];
my $eresp = $vars[14];
my $wretr = $vars[15];
my $wredis = $vars[16];
my $status = $vars[17];
my $weight = $vars[18];
my $act = $vars[19];
my $bck = $vars[20];
my $chkfail = $vars[21];
my $chkdown = $vars[22];
my $lastchg = $vars[23];
my $downtime = $vars[24];
my $qlimit = $vars[25];
my $pid = $vars[26];
my $iid = $vars[27];
my $sid = $vars[28];
my $throttle = $vars[29];
my $lbtot = $vars[30];
my $tracked = $vars[31];
my $type = $vars[32];
my $rate = $vars[33];
my $rate_lim = $vars[34];
my $rate_max = $vars[35];
my $check_status = $vars[36];
my $check_code = $vars[37];
my $check_duration = $vars[38];
my $hrsp_1xx = $vars[39];
my $hrsp_2xx = $vars[40];
my $hrsp_3xx = $vars[41];
my $hrsp_4xx = $vars[42];
my $hrsp_5xx = $vars[43];
my $hrsp_other = $vars[44];
my $hanafail = $vars[45];
my $req_rate = $vars[46];
my $req_rate_max = $vars[47];
my $req_tot = $vars[48];
my $cli_abrt = $vars[49];
my $srv_abrt = $vars[50];

if ($status eq "DOWN") {
	print "HAPROXY CRITICAL: Proxy = $pxname. STATUS DOWN";
	print "|scur=$scur smax=$smax slim=$slim\n";
	exit $ERRORS{'CRITICAL'}
}

print "HAPROXY OK: Proxy = $pxname. Current sessions = $scur. Max sessions = $smax. Maximum limit = $slim" ;
print "|scur=$scur smax=$smax slim=$slim\n";

exit $ERRORS{'OK'}
