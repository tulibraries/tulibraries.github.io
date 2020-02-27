#
# c: 2007-Feb-22  Birl
# m: 2007-Apr-02  Birl
#

use strict;
use warnings;


my $POSTdata 		= $ENV{"QUERY_STRING"};
my $ContentLength 	= $ENV{"CONTENT_LENGTH"};
my $SCRIPT 		= $ENV{"SCRIPT_NAME"};
my $METHOD 		= $ENV{"REQUEST_METHOD"};
my $FILENAME		= "RSS_blacklist.txt";
my $FILE 		= $SCRIPT;



printf("Content-Type: text/html\n\n"); 									# Must always print out FIRST!


if ( -f "S:/Develop/FTU/FTU_top_template.shtml")
{
	open(INPUT, "S:/Develop/FTU/FTU_top_template.shtml");
	print while(<INPUT>);
	close(INPUT);
}



$FILE =~ s/RSS_blacklist_editor.pl/$FILENAME/;
$FILE = "S:/Develop$FILE";


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

	printf("<p><b>Processing</b></p>\n");
	printf("<pre style=\"font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px;\">%s</pre>\n", $POSTdata);

	if (! open(OUTPUT, ">$FILE") )
	{
		printf("<b>Failed to open %s for writing</b>: $^E ($!)\n", $FILE);
		exit 1;
	}

	printf(OUTPUT "%s", $POSTdata);
	close(OUTPUT);

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
		printf("# Could not open $FILE:\n");
		printf("# $^E ($!)\n");
		printf("# Using DEFAULT information.\n");
		printf("# These first 4 lines can be safely deleted.\n\n");
		printf("# Default blacklist file for automatic scanning.  Update as needed.\n");
		printf("# Useful for excluding password-protected directories from being added\n");
		printf("# to a RSS feed.\n");
		printf("#\n");
		printf("# Case-insensitive.\n");
		printf("#\n");
		printf("# Uses PERL's regular expression partial matching, not FULL matching.\n");
		printf("# A single . will match ANY character.  To match a literal . use \\.\n");
		printf("#\n");
		printf("# This blacklist will match against files AND folders.\n");
		printf("#\n");
		printf("# The AppDev, WebTools and _vti folders are automatically excluded.\n");
		printf("#\n");
		printf("# Remember, just because an item is excluded from the automatic searches,\n");
		printf("# one can still manually that item into the RSS feed.\n");
		printf("#\n\n");
		printf("\.jpg\n");
		printf("\.gif\n");
		printf("\.bmp\n");
		printf("\.png\n");
		printf("\.js\n");
		printf("rss\.html\n");
		printf("rss\.xml\n");

	}

	printf("\n</textarea><p>\n");
	printf("<input type=\"submit\" value=\"Update RSS Blacklist\"> &nbsp; &nbsp; &nbsp; <input type=\"reset\" value=\"Undo changes\">\n");
	printf("</form>\n");
}



