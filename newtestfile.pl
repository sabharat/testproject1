#!/usr/bin/perl 

use DBI;
use strict;

# DB CONNECTION VARIABLE DECLARATION
my $driver = "mysql"; 
my $database = "prepaidmld_owner";
my $dsn = "DBI:$driver:database=$database;host=localhost:port=3306";
my $userid = "root";
my $password = "Puskas54";

# GETTING DB HANDLE
my $dbh = DBI->connect($dsn, $userid, $password ) or die $DBI::errstr;

my @msisdnto5;
my @msisdnto4;

my $sth = $dbh->prepare("select SERVICE_TYPE, msisdn from prepaidmlk_owner.services where status ='3'and Expiry_date > sysdate() order by created_date desc");
$sth->execute() or die $DBI::errstr;
print "Number of status 3 stuck records found :" + $sth->rows;

my $i = 0;
my $j = 0;

while (my @row = $sth->fetchrow_array()) {
   my ($SERVICE_TYPE, $msisdn) = @row;
   print "MSISDN = $msisdn\n";
   my $old_service_type = GetOldServiceType($msisdn);
   if($old_service_type==$SERVICE_TYPE){
	$msisdnto5[$i] = $msisdn;
	$i++;
      }elsif($old_service_type==0 || $old_service_type!=$SERVICE_TYPE){
	$msisdnto4[$j] = $msisdn;
	$j++;
      }
}
$sth->finish();
      updateToStatus5(@msisdnto5);
      updateToStatus4(@msisdnto4);
$dbh->commit or die $DBI::errstr;
my $rc = $dbh->disconnect  or warn $dbh->errstr;
print "$rc"

#confirm if one MDN can have one unique status3 at a time. //script has been written considering unique
#promo_delivery_count=0, last_promo_delivery_time= TO BE PUT IN QUERY for status 5 also

#sub GetOldServiceType($msisdn){

#return 'a';
#}


sub updateToStatus5(@msisdnto5){
my $commadelimited1 = '';
my $commadelimited1 = join( ',', @msisdnto5 );
my $sth = $dbh->prepare("update prepaidmlk_owner.services set status = 5 where status = 3 and msisdn in ($commadelimited1);");
$sth->execute() or die $DBI::errstr;
$sth->finish();
}
sub updateToStatus4(@msisdnto4){
my $commadelimited2 = '';
my $commadelimited2 = join( ',', @msisdnto4 );
my $sth = $dbh->prepare("Update prepaidmlk_owner.services set status = 4, promo_delivery_count=0, last_promo_delivery_time= sysdate() where status = 3 and msisdn in ($commadelimited2)");
$sth->execute() or die $DBI::errstr;
$sth->finish();
}
