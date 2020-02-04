#!/opt/local/bin/perl

use Getopt::Std;

@ticket_owner = ("5550001","5550002","5550003","5550004");
@tech_person = ("1110001","1110002","1110003","1110004");
@date_submitted = ("'13-JAN-16'","'14-JAN-16'","'15-JAN-16'","'16-JAN-16'","'17-JAN-16'","'18-JAN-16'","'19-JAN-16'");
@date_completed = ("'23-JAN-16'","'24-JAN-16'","'25-JAN-16'","'26-JAN-16'","NULL","NULL","NULL");
@category_id = ("01","02","03","04","05","06","07","08","09","10","11","12","13");
@machine = ("'acta.cs.pitt.edu'", "'kaly.cs.pitt.edu'", "'elements.cs.pitt.edu'", "'kaso.cs.pitt.edu'", "'oxgyn.cs.pitt.edu'", "'rodi.cs.pitt.edu'","'java lab machine'");
@description = ("'The fan is noisy.'",
"'Can not print any PDF file!'",
"'Seems that the server is down?!'",
"'The AFS client crashes all the time!'",
"'The mouse responds in a weird way.'",
"'I failed to login to the evaluation site.'",
"'May I have SigmaPlot installed on my machine?'",
"'Some keys on the keyboard does not function.'",
"'The sound card is unrecognized.'",
"'The harddrive got bad sector.'",
"'Windows crashed!'",
"'can not reach AFS-home directory from home.'",
"'I have trouble configuring Outlook.'",
"'Can not submit my h/w using the submission site.'",
);

getopt("t");

print "SET TRANSACTION READ WRITE;\n";

$ticket_num = 567860;

usage() if $opt_h||!$opt_t;

for($i=0; $i<$opt_t; $i++) {
	$randomSubmitted = rand($#date_submitted);
	$randomCompleted = rand($#date_completed);

	if($date_completed[$randomCompleted]=="NULL") {
		$days = "NULL";
	} else {
		$days = 10 + (int($randomCompleted) - int($randomSubmitted));
	}

	print "insert into tickets values (".$ticket_num.",".$ticket_owner[rand @ticket_owner].",".$date_submitted[$randomSubmitted].",".
		$date_completed[$randomCompleted].",".$days.",".$category_id[rand @category_id].",".$machine[rand @machine].
		",".$description[rand @description].");\n";

	push(@assignments, "insert into assignment values (".$ticket_num.",".$tech_person[rand @tech_person].",".$date_submitted[$randomSubmitted].","."'assigned'".","."NULL".");\n");
	if($date_completed[$randomCompleted]!="NULL") {
		push(@assignments, "insert into assignment values (".$ticket_num.",".$tech_person[rand @tech_person].",".$date_completed[$randomCompleted].","."'closed_successful'".","."NULL".");\n");
	}
	$ticket_num++;
}

print "\n";

foreach $tuple (@assignments) {
	print $tuple;
}

print "commit;\n";

sub usage() {
	print STDERR << "EOF";
use -t to define the number of tuples
EOF
    exit;
}
