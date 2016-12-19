#!/usr/bin/perl 

use DBI;
use strict;

# DB CONNECTION VARIABLE DECLARATION
my $driver = "mysql"; 
my $database = "TESTDB";
my $dsn = "DBI:$driver:database=$database;host=siili:port=3305";
my $userid = "testwagner";
my $password = "BZfCwday";

# GETTING DB HANDLE
my $dbh = DBI->connect($dsn, $userid, $password ) or die $DBI::errstr;


my $sth = $dbh->prepare("select SERVICE_TYPE, msisdn from prepaidmlk_owner.services where status ='3'and Expiry_date > sysdate order by created_date desc");
$sth->execute() or die $DBI::errstr;
print "Number of rows found :" + $sth->rows;
while (my @row = $sth->fetchrow_array()) {
   my ($SERVICE_TYPE, $msisdn) = @row;
   print "MSISDN = $msisdn\n";
   my $old_service_type = GetOldServiceType($msisdn);
   if($old_service_type==$SERVICE_TYPE){
    updateToStatus5($msisdn);
   }else if($old_service_type==0 || $old_service_type!=$SERVICE_TYPE){
	updateToStatus4($msisdn);
	}
}
$sth->finish();
$dbh->commit or die $DBI::errstr;
$rc = $dbh->disconnect  or warn $dbh->errstr;
print "$rc"

# GET MSISDN LIST FUNCTION

sub GetStatus3Msisdn{
}
sub GetOldServiceType{
}
sub updateToStatus5{
my $sth = $dbh->prepare("update prepaidmlk_owner.services set status = 5 where status = 3 and msisdn in($msisdn);");
$sth->execute() or die $DBI::errstr;
$sth->finish();
}
sub updateToStatus4{
my $sth = $dbh->prepare("Update prepaidmlk_owner.services set status = 4, promo_delivery_count=0, last_promo_delivery_time= sysdate where status = 3 and msisdn in ($msisdn)");
$sth->execute() or die $DBI::errstr;
$sth->finish();
}
