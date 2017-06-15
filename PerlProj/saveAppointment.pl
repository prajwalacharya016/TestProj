#!"C:\xampp\perl\bin\perl.exe"

use DBI;
use strict;
use CGI;
use URI::Escape;

my $q = new CGI;
my $date;
my $time;
my $desc;

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
sub data($) {
    my ($q) = @_;
    $date = $q->param('date');
    $time = $q->param('time');
    $desc = uri_escape($q->param('description'));
}

my $datetime = $date . " " . $time;
my $query = qq(INSERT INTO appointment (datetime , description) VALUES (?,?));

my $sth = $dbh->prepare($query);
my $rv = $sth->execute($datetime, $desc);

$dbh->disconnect();

#redirects to index.html after saving an appointment
print "Location: http://localhost/PerlProj/\n\n";