#!/usr/bin/perl 

use DBI;
use strict;

my $driver = "ORACLE";
my $database = "ROOT";
my $dsn = "DBI:$driver:database=$database;host=localhost:port=3306";
my $userid = "PERLSCRIPT";
my $password = "Puskas54";


my $dbh = DBI->connect($dsn, $userid, $password ) or die $DBI::errstr;

my $sth = $dbh->prepare("select sysdate FROM dual");
$sth->execute() or die $DBI::errstr;
print "Number of MDNs found :" + $sth->rows;
while (my @row = $sth->fetchrow_array()) {
   my ($task) = @row;
   print "Task = $task\n";
   updatefunction($task);
   
}        
$sth->finish();
my $rc = $dbh->disconnect  or warn $dbh->errstr;
print "Connection closed status - $rc";


sub updatefunction($task){
my $sth = $dbh->prepare("update a set a=5 where a=4");
$sth->execute() or die $DBI::errstr;
$sth->finish();
}
