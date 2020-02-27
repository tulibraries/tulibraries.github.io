#!/usr/bin/perl -w
#
# c: 2008-Dec-16  Birl
# m: 2011-Oct-17  Birl
#

use strict;
use warnings;

my $URI;
my $POSTdata 		= $ENV{"QUERY_STRING"};
my $ContentLength 	= $ENV{"CONTENT_LENGTH"};
my $SCRIPT 		= $ENV{"SCRIPT_NAME"};
my $METHOD 		= $ENV{"REQUEST_METHOD"};
my $FILENAME		= "FTU_blacklist.txt";
my $FILE 		= $SCRIPT;
my $OperatingSystem;
my $RootLevelDirectory;
my $RootLevelDevDirectory;


printf("Content-Type: text/html\n\n"); 									# Must always print out FIRST!




if (defined $ENV{"REQUEST_URI"} )
{
	$URI=$ENV{"REQUEST_URI"}; 		# Apache

	$OperatingSystem="Unix";
	$RootLevelDirectory 	= "/usr/local/apache/htdocs-develop";
	$RootLevelDevDirectory 	= sprintf("/usr/local/apache/htdocs-develop%s", $URI);
}
else
{
	$URI=$ENV{"PATH_INFO"}; 		# IIS

	$OperatingSystem="Windows";
	$RootLevelDirectory 	= "S:/Develop";
	$RootLevelDevDirectory 	= sprintf("S:/Develop%s", $URI);
}



if ( -f "${RootLevelDirectory}/FTU/FTU_top_template.shtml")
{
	open(INPUT, "${RootLevelDirectory}/FTU/FTU_top_template.shtml");
	print while(<INPUT>);
	close(INPUT);
}


$FILE =  $URI; 					# /sbirl/WebTools/ftu2blacklist.pl
$FILE =~ s/ftu2blacklist.pl/$FILENAME/; 	# FTU_blacklist.txt
$FILE = "${RootLevelDirectory}$FILE"; 		# ${RootLevelDirectory}/FTU_blacklist.txt


if ($METHOD =~ /^POST$/)
{
	if ($ContentLength < 0)
	{
		printf("<b>ERROR:</b> Missing POST data.");
		exit(1);
	}

	my $bytes_read = read(STDIN, $POSTdata, $ContentLength);






#	printf("<pre><b>POST received</b>.  %d bytes: \"%s\"</pre>\n", $ContentLength, $POSTdata); 	# debug

	if ($bytes_read != $ContentLength)
	{
		printf("<b>Lost POST data.</b>  ContentLength: %d bytes.  Read in %d bytes.\n", $ContentLength, $bytes_read);
		exit(1);
	}


	if ($POSTdata !~ /^File=/ )
	{
		printf("<b>Bad POSTdata</b>\n");
		exit 1;
	}

	$POSTdata =~ s/^File=//;
	$POSTdata =~ s/%0D//g; 										# Get rid of %0D which is LF (Line Feed)
	$POSTdata =~ s/\+/ /g; 										# convert + to space
	$POSTdata =~ s/%([\da-fA-F]{2})/chr(hex($1))/eg; 						# convert hexidecimal to ASCII
	$POSTdata =~ s/\\//g; 										# get rid of backslashes

	printf("<p><b>Processing</b></p>\n");
	printf("<pre style=\"font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px;\">%s</pre>\n", $POSTdata);

	if (! open(OUTPUT, ">$FILE") )
	{
		printf("<b>Failed to open %s for writing</b>: $^E ($!)\n", $FILE);
		exit 1;
	}

	printf(OUTPUT "%s", $POSTdata);
	close(OUTPUT);

	printf("<b style=\"font-size:20pt;\">You must reload the File Transfer Utility for these rules to take effect.</b> <br/>\n");

	printf("<p><a href=\"javascript:window.close();\">Close This Window</a></p>\n<br>\n\n");
}
else
{
	printf("<form method=\"POST\" action=\"%s\">\n", $SCRIPT);
	printf("<textarea cols=\"80\" rows=\"30\" name=\"File\">\n");

	if ( open(INPUT, "$FILE") )
	{
		while( <INPUT> )
		{
			print $_;
		}
	#	seek(INPUT, 0, 0);

		close(INPUT);
	}
	else
	{
#		printf("# URI: $URI\n");
		printf("# Could not open $FILE:\n");
		printf("# $^E ($!)\n");
		printf("# Using DEFAULT information.\n");
		printf("# These first 4 lines can be safely deleted before saving this file.\n");

		printf("# Default blacklist file for speeding up the loading of FTU2.  Update as needed.\n");
		printf("# Use of this blacklist is NOT a requirement.\n");
		printf("# Useful for excluding large directories which may cause long delays in FTU2.\n");
		printf("#\n");
		printf("# Case-insensitive.\n");
		printf("#\n");
		printf("# Uses PERL's regular expression partial matching, not FULL matching.\n");
		printf("# A single . will match ANY character.  To match a literal . use \\.\n");
		printf("#\n");
		printf("# This blacklist will match against files AND folders.\n");
		printf("#\n");
		printf("# The AppDev, WebTools and _vti folders are automatically excluded.\n");
		printf("# Lockfiles, backup files are also automatically excluded.\n");
		printf("#\n");
	#	printf("#\n\n");
		printf("\#\n");
		printf("Copy of\n");
		printf("\\[\n");
		printf("\\]\n");
		printf("\\(\n");
		printf("\\)\n");
	}

	printf("\n</textarea><p>\n");
	printf("<input type=\"submit\" value=\"Update FTU Blacklist\"> &nbsp; &nbsp; &nbsp; <input type=\"reset\" value=\"Undo changes\">\n");
	printf("</form>\n");
}



