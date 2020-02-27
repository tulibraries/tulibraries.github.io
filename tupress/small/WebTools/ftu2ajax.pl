#!/usr/bin/perl -w
# -T
#
# c: 2008-Dec-19 -- S.A. Birl
# u: 2014-Oct-06
#

use strict;
use warnings;   		# Supress the errors to the local user.
use File::Copy;

my $SERVER 			= $ENV{"SERVER_NAME"};
my $METHOD 			= $ENV{"REQUEST_METHOD"};
my $REFERER 		 	= $ENV{"HTTP_REFERER"}; 			# Useful: SCRIPT_NAME
my $TEMP;
my $Debug;
my $Username 			= $ENV{"REMOTE_USER"}; 				# For logging purposes.
my $OperatingSystem;
my $FILE;


sub PrintEnv()
{
	# Heavy debugging

#	printf("<pre>\n");

	my $val;
	my $var;

	foreach $var (sort(keys(%ENV)))
	{
	    $val = $ENV{$var};
	    $val =~ s|\n|\\n|g;
	    $val =~ s|"|\\"|g;
	    print 	"AJAX  ${var}=\"${val}\"\n";
	    print DEBUG "AJAX  ${var}=\"${val}\"\n";
	}

#	printf("</pre>\n<br><br>\n");
}
# ENDS sub PrintEnv()



printf("Content-Type: text/plain\n\n");

#################################################################################
# 										#
# Start testing the environment variables and massaging the PERL variables      #
# 										#
#################################################################################


if (defined $ENV{"REQUEST_URI"} )
{
	# While testing under Apache, if WebTools isnt password-protected then
	# this AJAX file will not know what $Username is and Overlord will not
	# be able transfer because of a filename mismatch.

	$OperatingSystem="Unix";
	$TEMP = "/tmp/";
}
else
{
	$OperatingSystem="Windows";
 	$TEMP = "S:/TEMP/FTU2_AJAX/";
	$Username =~ s/\w+\\(\w+)/$1/; 						# Get rid of the NetBIOS crap
}


# If the Username is LDAP
if ($Username =~ /dc=temple,dc=edu/i )
{
	$Username = $ENV{"AUTHENTICATE_UID"};
}


$Username = "ScootPERL" if ( (! defined $Username) || ($Username =~ /^\s*$/) ); # Override
$Username =~ s/TU\\//i;

if ( (! defined $REFERER) || ($REFERER =~ /^\s*$/) )
{
	# There is another way to grab the REFERER
	$REFERER = sprintf("https://%s%s", $SERVER, $ENV{'SCRIPT_NAME'} );
}

$FILE = $REFERER;
										# https://develop.temple.edu/ovpr/csis/WebTools/ftu2.pl?root-level-only
$FILE =~ s/\?\S+$//g; 								# delete any QUERY_STRING options
										# https://develop.temple.edu/ovpr/csis/WebTools/ftu2.pl
$FILE =~ s'/'^'g; 								# https:^^develop.temple.edu^ovpr^csis^WebTools^ftu2.pl
$FILE =~ s/_?ftu2(ajax)?\.pl(\?\S+)?//i; 						# https:^^develop.temple.edu^ovpr^csis^WebTools^
$FILE =~ s'\^WebTools\^''ig; 							# https:^^develop.temple.edu^ovpr^csis
										# http:^^develop1.temple.edu^ovpr^csis
$FILE =~ s/https?:\^\^${SERVER}\^//; 						# ovpr^csis
$FILE = sprintf("000000000#%s#%s.txt", $FILE, $Username); 			# 000000000#ovpr^csis#username.txt



$Debug = sprintf("debug_AJAX_%s", $FILE); 					# debug_AJAX_#website#username.txt
#$Debug = "debug_AJAX_generic.wri";


#################################################
# 						#
# Prep the AJAX debug file in case we need it   #
# 						#
#################################################

if ( open(DEBUG, ">>${TEMP}${Debug}") )
{
	my $temp = select(DEBUG);
	$|=1; 					# disable the write buffer.  Write data out as fast as possible.
	select($temp);
}
else
{
	printf(      "<b style=\"color:#F00;\">Cannot create/append AJAX debug '$Debug': $!</b>\n"); 	# message back to FTU2
	return;
}

printf(DEBUG "=== %s\n", scalar(localtime) );


#################################################################################
# 										#
# Exit if ftu2ajax.pl is called directly -- unless it's me calling it directly. #
# 										#
#################################################################################
#printf("%s\n", $Username );
#exit 1 if ( (! defined $FILE) || ($FILE =~ /^\s*$/) );


#if ( (! defined $FILE) || ($FILE =~ /^\s*$/) && $METHOD =~ /^POST$/ )
if ( (! defined $REFERER) || ($REFERER =~ /^\s*$/) )
{
	# There is another way to grab the REFERER
	

	printf(		"<pre class='error'>AJAX ERROR: No Referer</pre>\n"); 	# The AJAX file name is based partly on the name of the website calling it.
	printf(DEBUG 	"HTTP_REFERER is empty??!!  AJAX cannot proceed!\n"); 	# If the website is missing, then everything is out of place.  Abort.
	return 		if ( $Username !~ /sbirl/i );
}







if (! defined $METHOD)
{
	printf(      "?\n");
	printf(DEBUG "METHOD is missing?  What sort of witchcraft is this??\n");
	return;
}

printf(DEBUG "%s   %s   %s   %s   %s\n", $METHOD, $SERVER, $TEMP, $FILE, $REFERER );



# printf("@\n");

if    ($METHOD =~ /^POST$/)
{
	my $ContentLength=$ENV{"CONTENT_LENGTH"}; 							# CONTENT_LENGTH is used with POST
	my $POSTdata;
	my $TotalSuccesses=0;
	my $TotalFailures=0;
	my $TotalSizeTransfer=0;
	my @FailedTransfers;
	my $bytes_read;

	$|=1;

	if (! open(FTU2, ">>${TEMP}${FILE}") )
	{
		printf(DEBUG "<b style=\"color:#F00;\">AJAX says cannot append '$FILE': $!</b>\n"); 	# message back to FTU2
		printf(      "<b style=\"color:#F00;\">AJAX says cannot append '$FILE': $!</b>\n"); 	# message back to FTU2
		exit 1;
	}

	my $temp = select(FTU2);
	$|=1;
	select($temp);


	exit 1 if ($ContentLength < 0);

	$bytes_read = read(STDIN, $POSTdata, $ContentLength);

	return if ($POSTdata =~ /^SelectAllCheckbox=/ );

#	printf(FTU2  "POST received. %d bytes: \"%s\" \n\n", 	$ContentLength, $POSTdata); #exit(0);	# debug
#
# Keep the value of each key in here.  What if we uncheck something?
	printf(FTU2  "%s\n", $POSTdata );

#	printf("(%3.3d) %s\n", $ContentLength, $POSTdata); 						# message back to FTU2

	printf(DEBUG "POST received. %d bytes: \"%s\" \n\n", 	$ContentLength, $POSTdata); #exit(0);	# debug

	close(FTU2);

#	PrintEnv();
}
else
{
	if ($Username =~ /sbirl/i )
	{
		my $line;
		$FILE="sbirl_AJAX_debug_test.rtf";

		# Debugging from web for me.
	#	printf("<pre>\n");
		printf("REFERER '%s'\n", $ENV{"HTTP_REFERER"} );
		printf("SERVER: '%s'\n", $SERVER );
		printf("METHOD: '%s'\n", $METHOD );
		printf("FILE  : '%s'\n", $FILE );
		printf("TEMP  : '%s'\n", $TEMP );
		printf("\n");
		printf("WRITE TEST to $TEMP$FILE: ");
		if (! open(T, ">>${TEMP}${FILE}") )
		{
			printf("FAILED: $!\n");
		}
		else
		{
			printf("open() Successful\n");
		}
		if (! printf(T "%s %s\n", scalar(localtime), $ENV{"HTTP_REFERER"} ) )
		{
			printf("ERROR Writing: $! ($^E)\n");
		}
		close(T);
		printf(" READ TEST on $TEMP$FILE: ");
		if (! open(T, "${TEMP}${FILE}") )
		{
			printf("FAILED: $!\n");
		}
		else
		{
			printf("open() Successful\n");
		}
		while(<T>)
		{
			chomp; $line=$_;
		}
		printf(" DATA FROM    $TEMP$FILE: '$line'  (should be a timestamp)\n\n\n");
		close(T);

	#	printf("</pre>\n");
		PrintEnv;
	}
}

#EOF