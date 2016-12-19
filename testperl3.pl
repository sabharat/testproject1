#!/usr/bin/perl 

use DBI;
use strict;

my $driver = "mysql";
my $database = "lappo";
my $dsn = "DBI:$driver:database=$database;host=siili:port=3305";
my $userid = "testwagner";
my $password = "BZfCwday";


my $dbh = DBI->connect($dsn, $userid, $password ) or die $DBI::errstr;

my $sth = $dbh->prepare("select count(*) from prepaidmlk_owner.services where expiry_date between to_date(to_char(sysdate, 'YYYYMMDD')|| '00:00:00', 'YYYYMMDD HH24:MI:SS') and to_date(to_char(sysdate+1, 'YYYYMMDD')|| '00:00:00', 'YYYYMMDD HH24:MI:SS') and status in (2,5) order by id ;");
$sth->execute() or die $DBI::errstr;
print "Number of rows found :" + $sth->rows;
while (my @row = $sth->fetchrow_array()) {
   my ($task) = @row;
   print "Count = $task\n";   
}        
$sth->finish();
my $rc = $dbh->disconnect  or warn $dbh->errstr;
print "Connection closed status - $rc";

# SEND MAIL

