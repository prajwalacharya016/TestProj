#!"C:\xampp\perl\bin\perl.exe"

use DBI;
use strict;
use CGI;
use URI::Escape;
#use DateTime

my $q = new CGI;
my $date;
my $time;
my $desc;
my $rawtxt;

#my $dt2 = DateTime->now(time_zone=>'local');
##database connection
my $dbfile = "db_appointment.sqlite";
my $dsn = "DBI:SQLite:dbname=$dbfile";
my $username = "";
my $password = "";
my $dbh = DBI->connect($dsn, $username, $password, { 
		    PrintError => 0,
		    RaiseError => 1,
		    AutoCommit => 1 }) 
                or die $DBI::errstr;

if ($q->param()) {
    data($q);
}

# Data from the form
# Encoded 
sub data($) {
    my ($q) = @_;
    $rawtxt=$q->param('description');
    $rawtxt=~s/(['\\])/\\$1/g;
    $date = $q->param('date');
    $time = $q->param('time');
    $desc = uri_escape($rawtxt);
}
;
#Code for basic validation and print the value into the front end, Never actually required because validation done by Javascript/JQuery
#Checks only empty condition, daste past future check by Javascript
print CGI::header();
open HTML, "copyIndx.html" or die "can't open html file!\n";

# read the whole file in a variable
my $htmldata=join '', <HTML>;

close HTML;

# prepare the message to display
my $message="";

if($date eq "" or $time eq "" or $desc eq ""){
    $message=$message.'ERROR!!!Please check for the empty field';
}else{
    my $datetime = $date . " " . $time;
    my $query = qq(INSERT INTO appointment (datetime , description) VALUES (?,?));
    my $sth = $dbh->prepare($query);
    my $rv = $sth->execute($datetime, $desc);
}
#
    
#   redirects to index.html after saving an appointment
#print "Location: http://localhost/PerlProj/\n\n";

$dbh->disconnect();
# replace %MESSAGE% by whatever you want
$htmldata =~ s/\%Message%/$message/;

# display the modified html
print $htmldata
