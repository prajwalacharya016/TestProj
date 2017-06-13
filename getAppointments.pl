#!"C:\xampp\perl\bin\perl.exe"
print "Content-type : text/html\n\n";
use DBI;
use strict;
use CGI;

my $q = new CGI;

if ($q->param()) {
    data($q);
}

my $searchData;

# Data from the search textArea
sub data($) {
    my ($q) = @_;

    $searchData = $q->param('search');
}

#database connection
my $dbfile = "db_appointment.sqlite";
my $dsn = "DBI:SQLite:dbname=$dbfile";
my $username = "";
my $password = "";
my $dbh = DBI->connect($dsn, $username, $password, { RaiseError => 1 }) 
                      or die $DBI::errstr;
my $query = "SELECT datetime, description from appointment where description" . " Like '". $searchData . "%'";

my $statement = $dbh->prepare($query);
my $rv = $statement->execute() or die $DBI::errstr;

if($rv < 0){
   print $DBI::errstr;
}

my $result = "[";
while(my @row = $statement->fetchrow_array()) {
      $result .= "{" . '"'. "datetime" . '"' . " : " . '"'. $row[0] . '"' ." , " . '"'. "description" .'"'. " : ". '"'. $row[1]. '"' . "},";
}
chop($result);
$result = $result ."]";
print $result;

$dbh->disconnect();

