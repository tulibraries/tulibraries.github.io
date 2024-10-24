#!/usr/bin/perl
#
# Created  2005-Oct-11  Scott Birl <webhelp@temple.edu>

use strict;
##use warnings;
use File::Find;

my $Modified="2010-Feb-23";

my $AdministratorUpdating=0; 						# Am I currently updating this script?  Let users know.

$|=1; 									# Disable output buffering; write data out to screen as fast as possible.



# These variables should be accessible from either REQUEST_METHOD

my $METHOD 		= $ENV{"REQUEST_METHOD"};
my $SCRIPT 		= $ENV{"SCRIPT_NAME"};
my $REFERER 		= $ENV{"HTTP_REFERER"};

my @FINDarray;
my @CurrentTime		= localtime();
my @Months 		= ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
my @Days 		= ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");

my $SERVER		= $ENV{"SERVER_NAME"};
my $Year		= (localtime(time))[5];

my $CoolProgramName 	= "RSS Toolbox";
my $DIRECTORY 		= "S:/Develop"; 										# Webserver directory
my $WWW 		= "http://www.temple.edu";
my $URI 		= $REFERER;
my $OUTPUT;
my $OUTPUT2;
my %RSS; 														# The contents of the RSS feed
my $FileOfRSSFeeds; 													# $DIRECTORY/WebTools/RSS_files.txt

my $ArticleCounter	= 0;
my $DebugColor 		= "BBbbFF";

my %UserBlacklist;

my $Hours=24;
my $MaximumHours=24*7; 													# MUST be a valid number!
my $CurrentField 	= 1;
my $Width 		= 150; 												# for the <td> tag.
my $FieldLength 	= 50; 												# for the <input> tags.

my $ChannelTitle;
my $ChannelLink;
my $ChannelDesc;

my $AutomaticFindCounter=0;

my $XCACLS 		= "$ENV{'SYSTEMROOT'}\\System32\\xcacls.exe";


$Year+=1900;



printf("Content-Type: text/html\n\n");  										# Must always print out FIRST!
#printf("<!-- BEGIN CGI code -->\n\n");

printf("<html>\n");
printf("<head>
<meta name='robots' content='noindex,nofollow' />\n");
printf("<title>Temple University $CoolProgramName</title>\n");
#printf("<link href=\"/FTU/cs_style.css\" rel=\"stylesheet\" type=\"text/css\">\n");
printf("<link href=\"/FTU/includes/ftu2-global-stylesheet.css\" rel=\"stylesheet\" type=\"text/css\">\n");
printf("<link href=\"/FTU/includes/homepage-stylesheet.css\" rel=\"stylesheet\" type=\"text/css\">\n");
printf("<style>\n");
#printf("html,body		{font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; }\n");
printf("br,b,i,td,th,pre	{font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; }\n");
printf("a,h2			{font-family: Verdana, Arial, Helvetica, sans-serif; }\n");
printf("td			{white-space: nowrap;}\n");
printf("pre			{background-color:#$DebugColor; }\n");
printf(".note			{color:#888888; }\n");
printf(".error			{color:#FF0000; }\n");
printf(".border 		{border: thin solid #999999; padding: 3px; }\n");
printf("a:link 			{color:#000099;}\n");
printf("label 			{cursor:pointer;}\n");
printf("</style>\n");
printf("</head>\n\n");



if ( (! defined $REFERER) || ($REFERER =~ /^\s*$/) )
{
	$REFERER =  $SCRIPT;
	$REFERER =~ s/create_RSS_XML.pl$//;

	printf("<meta http-equiv=\"refresh\" content=\"5; url=https://$SERVER$REFERER\">\n");
	printf("<a href=\"https://$SERVER$REFERER\">No refering hyperlink. Please click here to correct.</a>");
	exit(1);
}
#else
#{
#	printf("<pre>REFERER: \"%s\"\n</pre>\n\n", $REFERER); 								# debug
#}



if ($AdministratorUpdating)
{
	printf("<br><br><br>\n<h1 align=\"center\">NOTE: System Administrator is currently making changes to this program.</h1>\n<br><br><br>\n\n");
}



#$URI =~ s/https?:\/\/develop\.temple\.edu\/(\w+)//; 									# Get rid of https://develop.temple.edu/
$URI =~ s/https?:\/\/develop\.temple\.edu\/(.*)//; 									# Get rid of https://develop.temple.edu/
$URI =  $1;
$URI =~ s/\/?WebTools\///i;
$URI =~ s/create_RSS_XML.pl$//;


$OUTPUT			= "$DIRECTORY/$URI/rss.xml";
$OUTPUT2		= "$DIRECTORY/$URI/rss.html";
$FileOfRSSFeeds 	= "$DIRECTORY/$URI/WebTools/RSS_files.txt";


#printf("<pre> <b>URI: \"$URI\"</b> ($0)</pre>\n"); 									# debug
#printf("<pre> OUTPUT:  \"$OUTPUT\"<br>OUTPUT2: \"$OUTPUT2\"</pre>\n");  						# debug
#printf("<pre> FileOfRSSFeeds: \"$FileOfRSSFeeds\"</pre>\n"); 								# debug


################################################################################
# Functions (aka Subroutines)
################################################################################


sub FOOTER()
{
	my $YEAR = ((localtime(time))[5])+1900;

	if ( open(INPUT, "S:/Develop/FTU/FTU_bot_template.shtml") )
	{
		while(<INPUT>)
		{
			my $line=$_;

			$line =~ s/2007/$YEAR/g;

			print $line;
		}
		close(INPUT);
	}
	else
	{
		printf("&copy; $YEAR Temple University");
	}
}






sub Update
{
#	$RSSFilesThatExist{$OUTPUT}=1;
#
#
#	# Open up the list of existing RSS feeds.
#	if ( open(RSSFILES, "$FileOfRSSFeeds") )
#	{
#		while(<RSSFILES>)
#		{
#			chomp;
#			my $file = $_;
#
#			if (-f "$file") 										# Make sure this file still exists.
#			{
#				$RSSFilesThatExist{$file}=1; 								# If so, add it to the hash.
#			}
#		}
#	}
#
#	if ( open(RSSFILES, ">$FileOfRSSFeeds") )
#	{
#		foreach my $index (sort(keys %RSSFilesThatExist) )
#		{
#			printf(RSSFILES "%s\n", $index); 								# dump the hash back to the file.
#		}
#	}
#
}






sub PrintSelections() 	# STEP 1  and  STEP 2
{
	printf("<script language=\"JavaScript\" type=\"text/javascript\">\n");

	printf("function SelectRadio(radio)\n{\n");
	printf("\tdocument.getElementById(radio).checked=true;\n");
	printf("\tdocument.getElementById(\"RSSFilename\").selectedIndex=0;\n");
	printf("}\n\n");
	printf("</script>\n\n\n");


#	printf("<p><span id=\"Description\"><a href=\"javascript:show_Description()\">What <u>IS</u> RSS?</a></span></p>\n");

	printf("<p><span id=\"Description\">What <u>IS</u> RSS?<p>RSS is a format for syndicating news and the content of news-like sites.  <a href=\"http://rss.userland.com/whatIsRSS\" target=\"_blank\">More ...</a><br>This toolbox will create 2 formats: XML and HTML.  It conforms to RSS Version 2.0. </span>\n");


	printf("<form method=\"POST\" action=\"%s\" enctype=\"multipart/form-data\">\n", $SCRIPT);
	printf("<div class=\"border\">\n");
	printf("<b>STEP 1.</b>\n");
	printf("<br>\n");
	printf("<p>");
	printf("<input type=\"radio\" name=\"RSSFileName\" id=\"RSSFileName1\" onclick=\"document.getElementById('RSSFilename').selectedIndex=0;\" CHECKED>\n");
	printf("<label for=\"RSSFileName1\"> Create a new RSS feed: </label>");
	printf("<input type=\"text\"  name=\"RSSFilename\" id=\"RSSFileName1A\" value=\"%s\" size=\"30\" onclick=\"SelectRadio('RSSFileName1');\" onblur=\"SelectRadio('RSSFileName1');\"> ", $OUTPUT);
#	printf(" <a href=\"javascript:show_FilenameDescription()\">Help</a></p>\n");
	printf("<br><ul><div>This XML file name <b>MUST</b> begin with %s/%s/ and <b>should</b> end in .xml.<br>An HTML file will also be created and similarly named.%s</div></ul>\n", $DIRECTORY, $URI,  (-f "$FileOfRSSFeeds") ? "<br>When creating a new RSS feed, make sure the drop-down box is left blank." : "");
	printf("<p><span id=\"FilenameDescription\"></span></p>\n");

	if (-f "$FileOfRSSFeeds")
	{
		if ( open(RSSFEED, "$FileOfRSSFeeds") )
		{
			printf("<b>-- OR --</b>\n");
			printf("<br><br>\n\n");
			printf("<p>");
			printf("<input type=\"radio\" name=\"RSSFileName\" id=\"RSSFileName2\" onclick=\"document.getElementById('RSSFileName1A').value='';\">\n");
			printf("<label for=\"RSSFileName2\">Choose an existing RSS feed: \n");
			printf("<select name=\"RSSFilename\" id=\"RSSFilename\">\n");
			printf("\t<option>\n");

			while(<RSSFEED>)
			{
				chomp;
				printf("\t<option value=\"$_\"> $_\n");
			}
			close(RSSFEED);

			printf("</select></label></p>\n");
		#	printf("<br><br>\n\n");
		}
		else
		{
			printf("<b class=\"error\">Error opening $FileOfRSSFeeds:</b> $! ($^E)\n");
		}
	}


	printf("</div>\n");
	printf("<br><br>\n\n");


	if (-f "$FileOfRSSFeeds")
	{
		printf("<div class=\"border\">\n");
		printf("<b>STEP 2.</b>\n");
		printf("<br>\n");

		printf("<p><input type=\"radio\" name=\"RSSGen\" id=\"RSSGen1\" value=\"Manual\" %s>		<label for=\"RSSGen1\">Manually edit a RSS feed. </label>",  (! -f "$FileOfRSSFeeds") ? "CHECKED" : ""   );
#		printf("<a href=\"javascript:show_ManualDescription()\">Help</a></label>\n</p>\n\n");
#		printf("<span id=\"ManualDescription\"></span>\n");
		printf("<p><ul>This option will allow you to add news items into the RSS feed.</ul></p>");


		printf("<p><input type=\"radio\" name=\"RSSGen\" id=\"RSSGen2\" value=\"Auto\">			<label for=\"RSSGen2\">Automatically add files modified within the last </label>");
			printf("<input type=\"text\" name=\"Hours\" value=\"24\" size=\"3\" maxlength=\"4\" onclick=\"document.getElementById('RSSGen2').checked=true;\" onblur=\"document.getElementById('RSSGen2').checked=true;\" ><label for=\"RSSGen2\"> hours to a feed. </label>");
		#	printf("<a href=\"javascript:show_AutoDescription()\">Help</a></label>\n</p>\n\n");
#		printf("<span id=\"AutomaticDescription\"></span>\n");
		printf("<p><ul>This option will automatically scan your entire website for files that have been modified<br>within X hours (up to $MaximumHours hours) and add those files into the RSS feed.<br>You still have the option to exclude files manually and/or through use of a <a href=\"/$URI/WebTools/RSS_blacklist_editor.pl\" target=\"_blank\">blacklist</a>.</ul></p>\n");

		printf("<p><input type=\"radio\" name=\"RSSGen\" id=\"RSSGen3\" value=\"ManualAuto\" CHECKED>	<label for=\"RSSGen3\">Both manual and automatic.</label>\n</p>\n\n");

		printf("<p><input type=\"radio\" name=\"RSSGen\" id=\"RSSGen4\" value=\"DeleteFile\">		<label for=\"RSSGen4\">Delete this entire file.</label>\n</p>\n\n");

	#	printf("<p><input type=\"radio\" name=\"RSSGen\" id=\"RSSGen5\" value=\"CopyFile\">		<label for=\"RSSGen5\">Copy this entire file to</label> <input type=\"text\" name=\"NewFilename\" value=\"$DIRECTORY/$URI/\">.\n</p>\n\n");

	#	printf("<p><input type=\"radio\" name=\"RSSGen\" id=\"RSSGen6\" value=\"Rename\" onclick=\"document.getElementById('RSSFileName2').checked=true; document.getElementById('RSSFileName1A').value='';\"> 		<label for=\"RSSGen6\">Rename <b>existing</b> file to:</label> <input type=\"text\" name=\"NewFileName\" onclick=\"document.getElementById('RSSGen6').checked=true; document.getElementById('RSSFileName1A').value='';\" onblur=\"document.getElementById('RSSGen6').checked=true;\" >\n</p>\n\n");
	#	printf("<ul><div>This XML file name <b>MUST</b> begin with %s/%s/ and <b>should</b> end in .xml.<br>The HTML file will also be similarly renamed.</div></ul>\n", $DIRECTORY, $URI);

	}
	else
	{
		printf("<input type=\"hidden\" name=\"RSSGen\" id=\"RSSGen1\" value=\"Manual\">\n\n");
	}

	printf("</div>\n");
	printf("<br>\n");
	printf("<input type=\"submit\" value=\"Continue\">\n");
	printf("</form>\n\n\n");

	printf("<div style=\"font-size:6pt; color:#DDD;\">$Modified</div>\n");
#	printf("<br>\n\n");



	printf("<br>\n\n\n"); 	# LEAVE THIS HERE
	FOOTER();
	exit 0;
}





sub ManualForm()
{
	my $MaximumFields = 4; 									# 1 less than what you really want.  I want 5 fields, so I say 4.

	printf("<script language=\"JavaScript\" type=\"text/javascript\">\n");
	printf("var DisplayManualDefinition=\"<p>This option will allow you to add news items into the RSS file.</p>\";\n");
	printf("var DisplayChannelTitle=\"The overall name of your news service.\";\n");
	printf("var DisplayChannelLink=\"A URL to your news service.\";\n");
	printf("var DisplayChannelDesc=\"A brief description of your news service.\";\n");
	printf("\n");
	printf("var DisplayItemTitle=\"The name of your news item.\";\n");
	printf("var DisplayItemLink=\"A URL to your news item.\";\n");
	printf("var DisplayItemDesc=\"A brief, optional, description of your news item.\";\n");
	printf("\n");
	printf("function show_ManualDescription()\n{\n");
	printf("\tdocument.getElementById(\"ManualDescription\").innerHTML = DisplayManualDefinition;\n");
	printf("\n");
	printf("\tdocument.getElementById(\"CTD\").innerHTML = DisplayChannelTitle;\n");
	printf("\tdocument.getElementById(\"CLD\").innerHTML = DisplayChannelLink;\n");
	printf("\tdocument.getElementById(\"CDD\").innerHTML = DisplayChannelDesc;\n");
	printf("\n");
	printf("\tdocument.getElementById(\"TD\").innerHTML = DisplayItemTitle;\n");
	printf("\tdocument.getElementById(\"LD\").innerHTML = DisplayItemLink;\n");
	printf("\tdocument.getElementById(\"DD\").innerHTML = DisplayItemDesc;\n");
	printf("}\n\n");
	printf("</script>\n\n\n");


	printf("<h2>Manually update the RSS file:</h2>\n");
	printf("<span id=\"ManualDescription\"><a href=\"javascript:show_ManualDescription()\">Help</a></span>\n<br><br>\n");

	printf("<table border=\"0\" cellpadding=\"3\" cellspacing=\"0\">\n");

	printf("<td colspan=\"2\"><b>All <u>Channel</u> fields are manditory.</b></td><tr>\n");

	printf("<td nowrap width=\"$Width\"><label for=\"ChannelTitle\">Channel Title      </label></td> <td><input name=\"ChannelTitle\" id=\"ChannelTitle\" value=\"%s\" size=\"$FieldLength\">			<i id=\"CTD\" class=\"note\"></i><tr>\n", $ChannelTitle);
	printf("<td nowrap width=\"$Width\"><label for=\"ChannelLink\"> Channel Link       </label></td> <td><input name=\"ChannelLink\"  id=\"ChannelLink\"  value=\"%s\" size=\"$FieldLength\" maxlength=\"255\">	<i id=\"CLD\" class=\"note\"></i><tr>\n", $ChannelLink);
	printf("<td nowrap width=\"$Width\"><label for=\"ChannelDesc\"> Channel Description</label></td> <td><input name=\"ChannelDesc\"  id=\"ChannelDesc\"  value=\"%s\" size=\"$FieldLength\">			<i id=\"CDD\" class=\"note\"></i><tr>\n", $ChannelDesc);
	printf("<td nowrap colspan=\"2\">&nbsp;</td><tr>\n");

	printf("<td colspan=\"2\"><b>All fields with an asterisk (<span style=\"color:#F00;\">*</span>) are required ONLY if you intend to use them.  Descriptions are always optional.</b></td><tr>\n");

	for $CurrentField ($CurrentField .. $CurrentField+$MaximumFields)
	{
		printf("<td nowrap width=\"$Width\"><label for=\"title%2.2d\">Title       %d <span style=\"color:#F00;\">*</span></label></td> <td><input name=\"title%2.2d\" id=\"title%2.2d\" size=\"$FieldLength\">			<i id=\"TD\" class=\"note\"></i><tr>\n", $CurrentField, $CurrentField, $CurrentField, $CurrentField);
		printf("<td nowrap width=\"$Width\"><label for=\"url%2.2d\">  URL         %d <span style=\"color:#F00;\">*</span></label></td> <td><input name=\"url%2.2d\"   id=\"url%2.2d\"   size=\"$FieldLength\" maxlength=\"255\">	<i id=\"LD\" class=\"note\"></i><tr>\n", $CurrentField, $CurrentField, $CurrentField, $CurrentField);
		printf("<td nowrap width=\"$Width\"><label for=\"desc%2.2d\"> Description %d  </label></td> <td><input name=\"desc%2.2d\"  id=\"desc%2.2d\"  size=\"$FieldLength\">			<i id=\"DD\" class=\"note\"></i><tr>\n", $CurrentField, $CurrentField, $CurrentField, $CurrentField);
		printf("<td nowrap colspan=\"2\">&nbsp;</td><tr>\n");
	}

	printf("</table>\n");

} # ENDS sub ManualForm()





sub AutomaticForm()
{
#	printf("<script language=\"JavaScript\" type=\"text/javascript\">\n");
#	printf("var DisplayAutoDefinition=\"<p>Automatically scans your entire website for files that have modified<br>within the last $Hours hours and will include those files into the RSS feed.<br>You still have to option to exclude these additions.</p>\";\n\n");
#	printf("function show_AutoDescription()\n{\n");
#	printf("\tdocument.getElementById(\"AutomaticDescription\").innerHTML = DisplayAutoDefinition;\n}\n\n");
#	printf("</script>\n\n\n");


	printf("<h2>Automatic discovery with manual confirmation:</h2>\n");
#	printf("<span id=\"AutomaticDescription\"><a href=\"javascript:show_AutoDescription()\">Help</a></span>\n<br><br>\n");

	if (-f "$DIRECTORY/$URI/Webtools/RSS_Blacklist.txt")
	{
		printf("<a href=\"/$URI/WebTools/RSS_blacklist_editor.pl\" target=\"_blank\">Edit your RSS Blacklist</a>.\n");

		if ( open(BLACKLIST, "$DIRECTORY/$URI/Webtools/RSS_Blacklist.txt") )
		{
		#	printf("<pre>Opened $DIRECTORY/$URI/Webtools/RSS_Blacklist.txt for reading.</pre>\n"); 		# debug

			while(<BLACKLIST>)
			{
				next if (/^\s*#/);
				next if (/^\s*$/);

				chomp;
			#	printf("<pre>Blacklist: $_</pre>\n"); 							# debug
				$UserBlacklist{"$_"}=1;
			}
			close(BLACKLIST);
		}
		else
		{
			printf("<b>Could not open RSS blacklist</b>, \"$DIRECTORY/$URI/Webtools/RSS_Blacklist.txt\", $^E ($!)\n");
		}
	}
	else
	{
		printf("<b>Could not find an RSS blacklist.</b> <a href=\"/$URI/WebTools/RSS_blacklist_editor.pl\" target=\"_blank\">Create the blacklist now</a><br><br>\n");
	}

	printf("Any changes made to the blacklist will not take effect until the page is reloaded.<br><br>\n");
	printf("Files modified within the last %d hour%s:<br><br>\n\n\n", $Hours, ($Hours==1) ? "" : "s" );

	find(\&AutomaticFind, "$DIRECTORY/$URI" );

	if ($AutomaticFindCounter == 0)
	{
		printf("<p><b>No files have been modified within the last %d hour%s.</b>\n", $Hours, ($Hours==1) ? "" : "s" );
	}

	printf("<hr align=\"center\" width=\"75%%\">\n\n\n\n");

} # ENDS sub AutomaticForm()





sub PrintForm($)
{
#	printf("<pre>--> PrintForm()</pre>");
	my $FoundItem 	= 0; 												# Have we found an ITEM tag?
	my $type 	= shift;



#	printf("<body>\n");

#	printf("<pre><b>type</b> is \"%s\"</pre>\n", $type); 								# debug


#	printf("<script language=\"JavaScript\" type=\"text/javascript\">\n");
#	printf("var DisplayDefinition=\"<a href=\\\"javascript:show_NoDescription()\\\">Close Overview</a><br><br>This page will assist in the creation of the RSS file.<br><br>All RSS 2.0 files contain three important <b>Channel</b> fields and multiple news <b>Items</b> which provide information to the end-user.<br>The 3 Channel fields, Title, Link and Description, provide: <ul><li>the name of your news service, <li>a URL to your news service and <li>a brief description of your news service</ul>respectively.  Each news item, must contain a title and link, with an optional description.<br><br><a href=\\\"javascript:show_NoDescription()\\\">Close Overview</a><br><br>\";\n");
#	printf("var DisplayNoDefinition=\"<a href=\\\"javascript:show_Description()\\\">Overview</a>\";\n");
#	printf("function show_Description()\n{\n");
#	printf("\tdocument.getElementById(\"Description\").innerHTML = DisplayDefinition;\n}\n\n");
#	printf("function show_NoDescription()\n{\n");
#	printf("\tdocument.getElementById(\"Description\").innerHTML = DisplayNoDefinition;\n}\n\n");
#	printf("</script>\n\n\n");

#	printf("<span id=\"Description\"><a href=\"javascript:show_Description()\">Overview</a></span>\n");


	printf("This page will assist in the creation of the RSS file.\n<br><br>\n");
	printf("All RSS 2.0 files contain three important <b>Channel</b> fields and multiple news <b>Items</b> which provide information to the end-user.<br>\n");
	printf("The 3 Channel fields, Title, Link and Description, provide: ");
	printf("<ul><li>the name of your news service,</li> ");
	printf("<li>a URL to your news service and</li> ");
	printf("<li>a brief description of your news service respectively.</li></ul>\n");
	printf("Each news item, must contain a title and link, with an optional description.\n<br><br>\n");



	printf("<form method=\"POST\" action=\"%s\" enctype=\"multipart/form-data\">\n", $SCRIPT);

	if (-f "$OUTPUT") 												# Is there an existing RSS feed?
	{
		if ( open(INPUT, "$OUTPUT") ) 										# Open the file
		{
			printf("<h2>Review the current RSS content:</h2>\n");
			printf("<p>Location: $OUTPUT \n");
		#	printf("<input type=\"checkbox\" name=\"DeleteFile\"> Delete this entire file.  (All other form data will be ignored). &nbsp; ");
		#	printf("<input type=\"Submit\" name=\"DeleteFile\" value=\"Delete this file.\"><p>\n");
			printf("<p>Last modified: %s</p>", scalar(localtime( (stat("$OUTPUT"))[9] )) );
			printf("</p>\n");
		#	printf("<br><br>\n");



			# According to RSS protocols, all valid RSS feeds must have a Title, Link, and Description.

			while(<INPUT>) 											# Read the file
			{
				if (/<title>(.*?)<\/title>/i)
				{
					$ChannelTitle=$1;
					$ChannelTitle =~ s/"/&quot;/igo;
					$ChannelTitle =~ s/&rsquo;/'/igo;
					$ChannelTitle =~ s/&lsquo;/\`/igo;
					last; 										# Go to EOF
				}
			}
			seek(INPUT, 0, 0); 										# Go to BOF


			while(<INPUT>)
			{
				if (/<link>(.*?)<\/link>/i)
				{
					$ChannelLink=$1;
					last; 										# Go to EOF
				}
			}
			seek(INPUT, 0, 0); 										# Go to BOF


			while(<INPUT>) 											# Read the file
			{
				if (/<description>(.*?)<\/description>/i)
				{
					$ChannelDesc=$1;
					$ChannelDesc =~ s/"/&quot;/igo;
					$ChannelDesc =~ s/&rsquo;/'/igo;
					$ChannelDesc =~ s/&lsquo;/\`/igo;
					last; 										# Go to EOF
				}
			}

			# No need to rewind back to BOF
		}
		else 													# Trouble opening the file.
		{
			printf("<b>Failed to open the existing RSS feed:</b> $^E ($!).  Please report this to webhelp\@temple.edu");
		}




		if (! defined $ChannelTitle)
		{
			$ChannelTitle="";
		}

		if (! defined $ChannelLink)
		{
			$ChannelLink="";
		}

		if (! defined $ChannelDesc)
		{
			$ChannelDesc="";
		}


		printf("<table border=\"0\" cellpadding=\"3\" cellspacing=\"0\">\n");
		printf("<td nowrap width=\"$Width\"><label for=\"ChannelTitle\">Channel Title      </label></td> <td><input DISABLED name=\"ChannelTitle\" value=\"%s\" size=\"$FieldLength\"><tr>\n", $ChannelTitle);
		printf("<td nowrap width=\"$Width\"><label for=\"ChannelLink\"> Channel Link       </label></td> <td><input DISABLED name=\"ChannelLink\"  value=\"%s\" size=\"$FieldLength\" maxlength=\"255\"><tr>\n", $ChannelLink);
		printf("<td nowrap width=\"$Width\"><label for=\"ChannelDesc\"> Channel Description</label></td> <td><input DISABLED name=\"ChannelDesc\"  value=\"%s\" size=\"$FieldLength\"><tr>\n", $ChannelDesc);
		printf("<td nowrap colspan=\"2\"><p><i>To edit the Channel fields ");

		if ($type =~ /Manual/)
		{
			printf("please see the <b>Manually update RSS file</b> section below.");
		}
		else
		{
			printf("please choose either the <b>Manual</b> or <b>Both</b> option from the previous screen.");
		}
		printf("</i></td><tr>\n");
		printf("<td nowrap colspan=\"2\">&nbsp;</td><tr>\n");
		printf("</table>\n\n");


		# Now we're finished finding the Channel stuff.  Let's get the invidiual items.
		while(<INPUT>)
		{
			my $title; 								# reset to NULL during each iteration of the while
			my $link; 								# reset to NULL during each iteration of the while
			my $desc; 								# reset to NULL during each iteration of the while

			# All items should be separated by <item> </item>.  Look for the beginning tag
			if ( /<item/i )
			{
				if ($FoundItem)
				{
					printf("<b class=\"error\">XML error: Did not find a closing &lt;/item&gt; tag before encountering this new &lt;item&gt; tag.\n");
					$CurrentField++;
				}

		#		printf("<pre>Found item $CurrentField</pre>\n"); 					# debug

				$FoundItem=1;
			}

			if ( /<title>(.*?)<\/title>/i )
			{
		#		printf("<pre>Found title for item $CurrentField ($1)</pre>\n"); 			# debug
				$title = $1;
				$title =~ s/"/&quot;/igo;
				$title =~ s/&rsquo;/'/igo;
				$title =~ s/&lsquo;/\`/igo;
				$RSS{"title$CurrentField"}=$1;
			}

			if ( /<link>(.*?)<\/link>/i )
			{
		#		printf("<pre>Found link for item $CurrentField ($1)</pre>\n"); 				# debug
				$RSS{"link$CurrentField"}=$1;
			}

			if ( /<description>(.*?)<\/description>/i )
			{
			#	printf("<pre>Found desc for item $CurrentField ($1)</pre>\n"); 				# debug
				$desc = $1;
				$desc =~ s/"/&quot;/igo;
				$desc =~ s/&rsquo;/'/igo;
				$desc =~ s/&lsquo;/\`/igo;
				$RSS{"desc$CurrentField"}=$desc;
			#	printf("<pre>RSS{desc$CurrentField}=\"%s\"</pre>\n", $RSS{"desc$CurrentField"} ); 	# debug
			}


			# The closing tag </item>
			if ( /<\/item/i )
			{
				$FoundItem=0;
				$CurrentField++;
			}
		} # ENDS while(<INPUT>)

		close(INPUT);




		# Print out all items, if they exist
		if ($CurrentField > 1)
		{	
			for my $number (1 .. $CurrentField-1)
			{
				printf("<table border=\"0\" cellpadding=\"3\" cellspacing=\"0\">\n");
			#	printf("<th>&nbsp;</th><th>&nbsp;</th><th>Delete?</th><tr>\n");

			#	if ( (! defined $RSS{"desc$number"}) || ($RSS{"desc$number"} =~ /^\s*$/) )
				if (! defined $RSS{"desc$number"})
				{
					$RSS{"desc$number"}="null";
				}
	
				printf("<td nowrap width=\"$Width\"><label for=\"title%2.2d\">Title       %d <span style=\"color:#F00;\">*</span></label></td> <td><input name=\"title%2.2d\" id=\"title%2.2d\" value=\"%s\" size=\"$FieldLength\"> \n", 			$number, $number, $number, $number, $RSS{"title$number"} );
				printf("<th>Delete?</th><tr>");
				printf("<td nowrap width=\"$Width\"><label for=\"url%2.2d\">  URL         %d <span style=\"color:#F00;\">*</span></label></td> <td><input name=\"url%2.2d\"   id=\"url%2.2d\"   value=\"%s\" size=\"$FieldLength\" maxlength=\"255\">\n", 	$number, $number, $number, $number, $RSS{"link$number"} );
				printf("<td nowrap rowspan=\"2\" align=\"center\" valign=\"top\"><input type=\"checkbox\" name=\"DeleteItem\" value=\"DeleteItem%2.2d\"><tr>\n", $number);
				printf("<td nowrap width=\"$Width\"><label for=\"desc%2.2d\"> Description %d  </label></td> <td><input name=\"desc%2.2d\"  id=\"desc%2.2d\"  value=\"%s\" size=\"$FieldLength\"><tr>\n", 		$number, $number, $number, $number, $RSS{"desc$number"} );
				printf("<td nowrap colspan=\"3\">&nbsp;</td><tr>\n");
				printf("</table>\n\n");
			}
		}
	} # ENDS if (-f "$DIRECTORY/$URI/rss.xml")
	else
	{
		printf("<p><b>Because this RSS file ($OUTPUT) does not exist, it will be created as a new file.</b></p>");
	}



	printf("<hr align=\"center\" width=\"75%%\">\n");


	if ( ($type !~ /Auto/) && ($type !~ /Manual/) )
	{
		printf("<p><h2>ERROR.  Wrong type.</h2></p>\n");
		FOOTER();
		exit 1;
	}

	if ($type =~ /Auto/)
	{
		AutomaticForm();
	}

	if ($type =~ /Manual/)
	{
		ManualForm();
	}


	printf("<input type=\"hidden\" name=\"RSSFilename\" value=\"%s\">\n", $OUTPUT);


	# The name on this button will change depending upon the user updating for creating a new feed.
#	printf("<p>\n<input type=\"submit\" value=\"%s RSS\"> &nbsp; &nbsp; &nbsp; &nbsp;",  (-f "$OUTPUT") ? "Update" : "Create" );
	printf("<input type=\"reset\" value=\"Undo Changes\"> &nbsp; &nbsp; &nbsp; &nbsp;");
	printf("<input type=\"submit\" value=\"Submit RSS\"> &nbsp; &nbsp; &nbsp; &nbsp;");
	printf("<p>\n");
	printf("<br><br>\n");
	printf("<a href=\"%s\">Back to the $CoolProgramName</a></p>\n", $SCRIPT);
	printf("</form>\n");

#	printf("<pre><-- PrintForm()</pre>");
	printf("</body>\n");
	printf("</html>\n");

} # ENDS sub PrintForm()









sub AutomaticFind()
{
	return if (! -f $File::Find::name);
	return if ( $File::Find::name =~ /_(vti|private|derived|notes|bak|borders|disc\d|mm|themes)/i );
	return if ( $File::Find::name =~ /(AppDev|WebTools|\.DELETE\.txt)/i );


	my $FILE 	= $File::Find::name;
	my $Modified 	= (stat("$FILE"))[9];
	my $Title;
	my $Link;

	return if ( time-$Modified >= $Hours*3600 );

	$FILE =~ s/$DIRECTORY//;


	for my $banned (sort (keys %UserBlacklist))
	{
		my $TempBannedName = $banned;
		$TempBannedName =~ s/\\//g;

	#	printf("<pre><br>Comparing file \"$FILE\" vs blacklist \"$TempBannedName\"  </pre>"); 			# debug

		if ($FILE =~ /$banned/i )
		{
			printf("<pre><b>$FILE has been blacklisted by the filter \"$TempBannedName\"</b></pre>\n"); 	# not debug; inform the user
			return;
		}
	#	else
	#	{
	#		printf("<pre>No match\n</pre>\n"); 								# debug
	#	}
	}



	# If the file is already a part of the current RSS feed, skip it, or we'll have duplicate data.

	foreach my $key (sort(keys %RSS))
	{
		next if ($key !~ /^link/i );

		if ($RSS{$key} =~ /$FILE/i )
		{
			$key =~ s/link/URL /;

			printf("<b>Skipping $FILE</b> because it is already a part of the current RSS feed (see $key above.)<br>\n");
			return;
		}
	}






#	printf("<pre>URL %d, %s  %s</pre>\n", $CurrentField, scalar(localtime($Modified)), $FILE);




	if ( open(TEMP, "$DIRECTORY/$FILE") )
	{
		while(<TEMP>)
		{
			if ( /<title>(.*?)<\/title>/i )
			{
				$Title=$1;
				$Title =~ s/"/&quot;/igo;
				$Title =~ s/&rsquo;/'/igo;
				$Title =~ s/&lsquo;/\`/igo;
				last;
			}
		}
		close(TEMP);
	}
	else
	{
		printf("<b class=\"error\">Could not open \"%s\" for reading</b>: $^E ($!)\n", $FILE);
		return;
	}



	if ( (! defined $Title) || ($Title =~ /^\s*$/) )
	{
		$Title="No valid title found inside of the file.";
	}

	$Link = "http://www.temple.edu${FILE}";

	printf("<table border=\"0\" cellpadding=\"3\" cellspacing=\"0\">\n");
	printf("<th>&nbsp;</th><th>&nbsp;</th><th>Exclude?</th><tr>\n");

	printf("<td nowrap width=\"$Width\"><label for=\"title%2.2d\">Title       %d <span style=\"color:#F00;\">*</span></label></td> <td><input name=\"title%2.2d\" id=\"title%2.2d\" value=\"%s\" size=\"$FieldLength\"> \n", 				$CurrentField, $CurrentField, $CurrentField, $CurrentField, $Title );
	printf("<td nowrap rowspan=\"3\" align=\"center\"><input type=\"checkbox\" name=\"DeleteItem\" value=\"DeleteItem%2.2d\"><tr>\n", $CurrentField);
	printf("<td nowrap width=\"$Width\"><label for=\"url%2.2d\">  URL         %d <span style=\"color:#F00;\">*</span></label></td> <td><input name=\"url%2.2d\"   id=\"url%2.2d\"   value=\"%s\" size=\"$FieldLength\" maxlength=\"255\"><tr>\n", 	$CurrentField, $CurrentField, $CurrentField, $CurrentField, $Link );
	printf("<td nowrap width=\"$Width\"><label for=\"desc%2.2d\"> Description %d  </label></td> <td><input name=\"desc%2.2d\"  id=\"desc%2.2d\"               size=\"$FieldLength\"><tr>\n", 			$CurrentField, $CurrentField, $CurrentField, $CurrentField,  );
	printf("<td nowrap colspan=\"3\">&nbsp;</td><tr>\n");
	printf("</table>\n\n");



	$CurrentField++;
	$AutomaticFindCounter++;


} # ENDS sub AutomaticFind()










sub GenerateRSS()
{
	my %RSSFilesThatExist;
	my $WWWOUT1;
	my $WWWOUT2;

	$OUTPUT2 =  $OUTPUT;
	$OUTPUT2 =~ s/xml$/html/i;

	$WWWOUT1 = $OUTPUT;
	$WWWOUT1 =~ s/S:\/develop/$WWW/i;

	$WWWOUT2 = $OUTPUT2;
	$WWWOUT2 =~ s/S:\/develop/$URI/i;



#	$OUTPUT =~ s/WebTools\///;
#	$OUTPUT2 =~ s/WebTools\///;

#	$OUTPUT =~ s/\/WebTools//;
#	$OUTPUT2 =~ s/\/WebTools//;




	printf("<!--\n"); 												# debug
	printf("<pre>\n"); 												# debug
	printf("rss.xml  will be stored: \"%s\" \n", $OUTPUT); 								# debug
	printf("rss.html will be stored: \"%s\" \n", $OUTPUT2); 							# debug
	printf("</pre>\n"); 												# debug
	printf("-->\n"); 												# debug


	if (! open(outXMLfh,  ">$OUTPUT") ) 										# Start creating the XML  file
	{
		printf("<b class=\"error\">Could not create \"$OUTPUT\": $^E ($!)</b>\n");
		exit 1;
	}

	if (! open(outHTMLfh, ">$OUTPUT2") ) 										# Start creating the HTML file
	{
		printf("<b class=\"error\">Could not create \"$OUTPUT2\": $^E ($!)</b>\n");
		exit 1;
	}



	$RSS{"ChannelTitle"} =~ s/&/&amp;/igo;
	$RSS{"ChannelDesc"}  =~ s/&/&amp;/igo;

	$RSS{"ChannelTitle"} =~ s/%97/\-/igo; 										# convert 'Em' dash to hyphen
	$RSS{"ChannelDesc"}  =~ s/%97/\-/igo; 										# convert 'Em' dash to hyphen

	$RSS{"ChannelTitle"} =~ s/%([\da-fA-F]{2})/chr(hex($1))/eg; 							# convert hexidecimal to ASCII
	$RSS{"ChannelDesc"}  =~ s/%([\da-fA-F]{2})/chr(hex($1))/eg; 							# convert hexidecimal to ASCII


	printf(outXMLfh "<?xml version=\"1.0\"?>\n");
	printf(outXMLfh "<rss version=\"2.0\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\n");
#	printf(outXMLfh "\t<!-- View the source code to see how this works. -->\n");
	printf(outXMLfh "\t\t<!-- required tags: channel, title, link, description -->\n");
	printf(outXMLfh "\t<channel>\n");
	printf(outXMLfh "\t\t<title>%s</title>\n", $RSS{"ChannelTitle"} );
	printf(outXMLfh "\t\t<link>%s</link>\n", $RSS{"ChannelLink"} );
	printf(outXMLfh "\t\t<description>%s</description>\n", $RSS{"ChannelDesc"});
#	printf(outXMLfh "\t\t<!-- optional tags -->\n");
	printf(outXMLfh "\t\t<atom:link href=\"$WWWOUT1\" rel=\"self\" type=\"application/rss+xml\" />\n");
#	printf(outXMLfh "\t\t<docs>$WWWOUT2</docs>\n");
	printf(outXMLfh "\t\t<language>en-us</language>\n");
	printf(outXMLfh "\t\t<copyright>Copyright 2005-%s Scott Birl</copyright>\n", $Year);
	printf(outXMLfh "\t\t<generator>PERL script written by Scott Birl. PERL code last modified: %s</generator>\n", $Modified);
	printf(outXMLfh "\t\t<lastBuildDate>%s, %2.2d %s %4.4d %2.2d:%2.2d:%2.2d %s</lastBuildDate>\n", $Days[$CurrentTime[6]], $CurrentTime[3], $Months[$CurrentTime[4]], $CurrentTime[5]+1900, $CurrentTime[2], $CurrentTime[1], $CurrentTime[0], ($CurrentTime[8] ? "EDT" : "EST")  );
	printf(outXMLfh "\t\t<managingEditor>sbirl+rss\@concept.temple.edu (S.A. Birl)</managingEditor>\n");
#	printf(outXMLfh "\t\t<image><url>http://</url></image>\n");



#	printf(outHTMLfh "<html>\n");
#	printf(outHTMLfh "<head>
<meta name='robots' content='noindex,nofollow' />\n");
#	printf(outHTMLfh "<title>%s</title>\n", $RSS{"ChannelTitle"} );
#	printf(outHTMLfh "<meta name=\"robots\"\t\tcontent=\"NoArchive, NoIndex, NoFollow\">\n");
#	printf(outHTMLfh "<meta name=\"description\"\tcontent=\"RSS feed (HTML-version).\">\n" );
#
#	printf(outHTMLfh "<meta http-equiv=\"Pragma\"\tcontent=\"no-cache\">\n\n");
#
#	printf(outHTMLfh "</head>\n\n");
#	printf(outHTMLfh "<body>\n");
#	printf(outHTMLfh "<h1>%s</h1>\n\n", $RSS{"ChannelTitle"} );
#	printf(outHTMLfh "%s\n<p>\n", scalar(localtime) );



	printf(outHTMLfh "<img src=\"/icons/rss.gif\" title=\"RSS feed.\" alt=\"RSS feed.\"><br>\n");
	printf(outHTMLfh "<ul>\n");





	foreach my $item (sort (keys %RSS) )
	{
		my $number;

		if ($item =~ /^title(\d+)/ )
		{
			$number=$1;
		}
		else
		{
			next;
		}




		# Because XML needs to have & (and other similar tags) converted to &amp; for Title and Description
		# write out the HTML code first, then the XML


#		printf(outHTMLfh "<table border=\"1\" width=\"700\">\n");
#		printf(outHTMLfh "<th><a href=\"%s\">%s</a></th>\n<tr>\n", $RSS{"url$number"}, $RSS{"title$number"} );

		printf(outHTMLfh "<li><a href=\"%s\" target=\"_blank\">%s</a> %s\n", $RSS{"url$number"}, $RSS{"title$number"}, $RSS{"desc$number"} );


	#	printf("<pre>title$number is \"%s\"</pre>\n", $RSS{"title$number"} ); 				# debug
	#	printf("<pre>desc$number  is \"%s\"</pre>\n", $RSS{"desc$number"} ); 				# debug

		$RSS{"title$number"} =~ s/&/&amp;/igo;
		$RSS{"desc$number"}  =~ s/&/&amp;/igo;


		printf(outXMLfh "\t<!-- Start  %2.2d -->\n", ++$ArticleCounter);
		printf(outXMLfh "\t\t<item>\n");
		printf(outXMLfh "\t\t\t<title>%s</title>\n", $RSS{"title$number"} );
	#	printf(outXMLfh "\t\t\t<pubDate>%s</pubDate>\n", scalar(localtime()) );

		printf(outXMLfh "\t\t\t<guid isPermaLink=\"true\">%s</guid>\n", $RSS{"url$number"} ) 	if ( (defined $RSS{"url$number"}) && ($RSS{"url$number"} !~ /^$/) ); 

		printf(outXMLfh "\t\t\t<link>%s</link>\n", $RSS{"url$number"} )   			if ( (defined $RSS{"url$number"}) && ($RSS{"url$number"} !~ /^$/) ); 




		if ( (defined $RSS{"desc$number"}) && ($RSS{"desc$number"} !~ /^$/) )
		{

	#		if ($LINE =~ /\.(gif|jpe?g|bmp|ico|png)/)
	#		{
	#		#	printf(outXMLfh "\t\t\t<photo:imgsrc>http://%s/%s</photo:imgsrc>\n", $SERVER, $LINE);
	#		#	printf(outXMLfh "\t\t\t<photo:thumbnail>http://%s/%s</photo:thumbnail>\n", $SERVER, $LINE);
	#		#	printf(outXMLfh "\t\t\t<pb:thumb>http://%s/%s</pb:thumb>\n", $SERVER, $LINE);
	#			printf(outXMLfh "\t\t\t<description>&lt;img src=&quot;http://%s/%s&quot;&gt; was created or updated on %s</description>\n", $SERVER, $LINE, $DATE);

	#		printf(outHTMLfh "<th><img src=\"/%s\"></th>\n<tr>\n", $LINE);
	#		}
	#		else
	#		{
				# Use  &lt; &gt;  to add hypertext inside of the description.
				printf(outXMLfh "\t\t\t<description>%s</description>\n", $RSS{"desc$number"} );
	#		}

	#		printf(outHTMLfh "<td>%s</td>\n", $RSS{"desc$number"});

		} # ENDS if ( (defined $RSS{"desc$number"}) && ($RSS{"desc$number"} !~ /^$/) )


		printf(outXMLfh "\t\t</item>\n");
		printf(outXMLfh "\t<!-- Finish %2.2d -->\n", $ArticleCounter);

#		printf(outHTMLfh "</table>\n\n<br>\n<br>\n\n");
	}



	printf(outHTMLfh "</ul>\n");
#	printf(outHTMLfh "</body>\n</html>\n\n");


	printf(outXMLfh "\t</channel>\n");
	printf(outXMLfh "</rss>\n");

	close(outXMLfh);
	close(outHTMLfh);

	# Set the permissions so that IUSR_ can update the file as needed.
	if (! -f "$XCACLS")
	{
		printf("<b class=\"error\">Failed to find xcacls.exe</b><p>\n");
	}
	else
	{
	#	printf("<pre>\"${XCACLS}\"  /Y /E /R \"$OUTPUT\"   \"IUSR_FRONTPAGE_SVR\":RWXCD;RWXCD</pre>\n"); 	# debug
	#	`"${XCACLS}"  /Y /E /R "$OUTPUT"  "IUSR_FRONTPAGE_SVR":RWXCD;RWXCD`;

	#	printf("<pre>\"${XCACLS}\"  /Y /E /R \"$OUTPUT2\"  \"IUSR_FRONTPAGE_SVR\":RWXCD;RWXCD</pre>\n"); 	# debug
	#	`"${XCACLS}"  /Y /E /R "$OUTPUT2" "IUSR_FRONTPAGE_SVR":RWXCD;RWXCD`;
	}



	$RSSFilesThatExist{$OUTPUT}=1;


	# Open up the list of existing RSS feeds.
	if ( open(RSSFILES, "$FileOfRSSFeeds") )
	{
		while(<RSSFILES>)
		{
			chomp;
			my $file = $_;

			if (-f "$file") 										# Make sure this file still exists.
			{
				$RSSFilesThatExist{$file}=1; 								# If so, add it to the hash.
			}
		}
	}

	if ( open(RSSFILES, ">$FileOfRSSFeeds") )
	{
		foreach my $index (sort(keys %RSSFilesThatExist) )
		{
			printf(RSSFILES "%s\n", $index); 								# dump the hash back to the file.
		}
	}



} # ENDS sub GenerateRSS()


















if ( -f "S:/Develop/FTU/FTU_top_template.shtml")
{
	open(INPUT, "S:/Develop/FTU/FTU_top_template.shtml");
#	print while(<INPUT>);
	while(<INPUT>)
	{
		next if ($. < 8); 											# skip the first 7 lines.
		print;
	}
	close(INPUT);
}

printf("<!-- ... -->\n\n\n");

printf("<h2>Temple University RSS Toolbox</h2>\n");




if (! defined $METHOD) 													# commandline execution.
{
	$METHOD = "GET";
}


if ($METHOD =~ /^POST$/)
{
	my %RequiredFieldsMissing 	= 0;
	my $TotalMissing 		= 0;
	my $POSTdata 			= $ENV{"QUERY_STRING"};
	my $ContentLength 		= $ENV{"CONTENT_LENGTH"};
	my @Data; 													# The contents of the form data
	my %ItemsToDelete;



	if ($ContentLength < 0)
	{
		printf("<b>ERROR:</b> Missing POST data.");
		FOOTER();
		exit 1;
	}

	my $bytes_read = read(STDIN, $POSTdata, $ContentLength);





#	printf("<pre><b>POST received</b>.  %d bytes: \"%s\"</pre>\n", $ContentLength, $POSTdata); 			# debug

	if ($bytes_read != $ContentLength)
	{
		printf("<b>Lost POST data.</b>  ContentLength: %d bytes.  Read in %d bytes.\n", $ContentLength, $bytes_read);
		FOOTER();
		exit 1;
	}





	if    ( $POSTdata =~ /RSSFilename=(S.[^&]+)&/ )
	{
		my $hours;
		my $type;

		$OUTPUT=$1;
		$OUTPUT =~ s/\+/ /g; 											# convert + to space
		$OUTPUT =~ s/%([\da-fA-F]{2})/chr(hex($1))/eg; 								# convert hexidecimal to ASCII


		if ($OUTPUT !~ /^S:\/Develop\/$URI/i )
		{
			printf("<p><b>ERROR: Invalid filename \"%s\" (Bad location).  Please go back and correct.</b></p>\n", $OUTPUT);
			FOOTER();
			exit 1;
		}

		if ($OUTPUT =~ /\.html/i )
		{
			printf("<p><b>ERROR: Invalid filename \"%s\". Filename CANNOT end in .html.  Please go back and correct.</b></p>\n", $OUTPUT);
			FOOTER();
			exit 1;
		}

		$OUTPUT2 =  $OUTPUT;
		$OUTPUT2 =~ s/\.\w+$/.html/i;

	

		if ( $POSTdata =~ /Hours=(-?\d+)/ )
		{
			$hours = $1;
		}

		if ( $POSTdata =~ /RSSGen=(\w+)/ )
		{
			$type = $1;
		}



		# Check to see if the user wanted to delete the file.  If so, do it and ignore everything else
		if ($POSTdata =~ /DeleteFile/i )
		{
			my @RSSArray;

			# Read in the list of RSS feeds
			if ( open(RSSFEED, "$FileOfRSSFeeds") )
			{
				while (<RSSFEED>)
				{
					if ($_ !~ /$OUTPUT/ )
					{
						push(@RSSArray, $_);
					}
				}
				close(RSSFEED)
			}


			if ($#RSSArray >= 0) 					# 0 or greater means data is there.
			{
				# Write out the new list of RSS feeds
				if ( open(RSSFEED, ">$FileOfRSSFeeds") )
				{
					for my $index (0 .. $#RSSArray)
					{
						printf(RSSFEED "%s", $RSSArray[$index]);
					}
					close(RSSFEED)
				}
			}
			else
			{
	 			# Remove this file.  No longer needed.
				# This will also affect the PrintSelections() function above.
				unlink("$FileOfRSSFeeds");
			}




			printf("Removing \"%s\": ", $OUTPUT);

			#if ( unlink($OUTPUT) )
			if (rename($OUTPUT, "${OUTPUT}.DELETE.txt"))
			{
				printf("Successful.<br>");
			}
			else
			{
				printf("<b>FAILED:</b> $^E ($!).<br><br>Please report this to webhelp\@temple.edu.<br><br><br>");
			}


			printf("Removing \"%s\": ", $OUTPUT2);

			#if ( unlink($OUTPUT2) )
			if (rename($OUTPUT2, "${OUTPUT2}.DELETE.txt"))
			{
				printf("Successful.<br>");
			}
			else
			{
				printf("<b>FAILED:</b> $^E ($!).<br><br>Please report this to webhelp\@temple.edu.<br><br><br>");
			}

			printf("<p></p>\n<hr>\n");

			printf("\n<a href=\"%s\">Back to the $CoolProgramName</a><p>\n", $SCRIPT);
			FOOTER();
			exit 0;
		}


		# Check to see if the user wanted to copy the file.  If so, do it and ignore everything else
		if ($POSTdata =~ /CopyFile/i )
		{
			printf("<h2>Not implemented</h2>\n");
			printf("\n<a href=\"%s\">Back to the $CoolProgramName</a><p>\n", $SCRIPT);
			FOOTER();
			exit 0;
		}


		# Check to see if the user wanted to rename the file.  If so, do it and ignore everything else
		if ($POSTdata =~ /RSSGen=Rename/)
		{
			my $NewFileName= ( split(/=/,(split(/&/, $POSTdata))[5]))[1];
			$NewFileName =~ s/\+/ /g; 									# convert + to space
			$NewFileName =~ s/%([\da-fA-F]{2})/chr(hex($1))/eg; 						# convert hexidecimal to ASCII

		#	printf("<pre> NewFileName is \"%s\"</pre>\n", $NewFileName); 					# debug

			if ($NewFileName !~ /^S:\/Develop\/$URI/i )
			{
				printf("<p><b>ERROR: Invalid filename \"%s\" (Bad location).  Please go back and correct.</b></p>\n", $NewFileName);
			}
			elsif ($NewFileName =~ /\.html/i )
			{
				printf("<p><b>ERROR: Invalid filename \"%s\". Filename CANNOT end in .html.  Please go back and correct.</b></p>\n", $NewFileName);
			}
			elsif ( -d "$NewFileName")
			{
				printf("<b class=\"error\">%s already exists as a directory.  Cannot delete.</b><p>\n", $NewFileName);
			}
			elsif ( -f "$NewFileName")
			{
				printf("<b class=\"error\">%s already exists.  Please delete this file first.</b><p>\n", $NewFileName);
			}
			else
			{
				printf("Renaming %s to %s:<br>\n", $OUTPUT, $NewFileName);
				if (rename ($OUTPUT, $NewFileName) )
				{
					printf("Successful.<p>");
				}
				else
				{
					printf("<b>FAILED:</b> $^E ($!).<br><br>Please report this to webhelp\@temple.edu.<br><br><br>");
				}


				$NewFileName =~ s/\.\w+$/.html/i;

				printf("Renaming %s to %s:<br>\n", $OUTPUT2, $NewFileName);
				if (rename ($OUTPUT, $NewFileName) )
				{
					printf("Successful.<p>");
				}
				else
				{
					printf("<b>FAILED:</b> $^E ($!).<br><br>Please report this to webhelp\@temple.edu.<br><br><br>");
				}


			}

			printf("\n<a href=\"%s\">Back to the $CoolProgramName</a><p>\n", $SCRIPT);
			FOOTER();
			exit 0;
		}




		if ( ($hours > 1) && ($hours <= $MaximumHours) )
		{
			$Hours=$hours;
		}
		# else the $Hours will remain at the default 24



		PrintForm($type);
		FOOTER();
		exit 0;
	}
	elsif ($POSTdata =~ /^(Channel)?Title/i )
	{

		# split the POST data.  Each Key/Value pair is separated by an &, so split on &
		@Data=split(/&/, $POSTdata);


	#	printf("<pre>\n"); 											# debug
		for my $item (@Data)
		{
			my ($key, $value) = split(/=/, $item); 								# Grab each assignment

			printf("<!--\n"); 										# debug
			printf("<pre>-----\nITEM: %s\n\tKEY: %s\n\tVALUE: %s\n</pre>\n", $item, $key, $value); 		# debug
			printf("-->\n"); 										# debug


			$value =~ s/\+/ /g; 										# convert + to space
			$value =~ s/\"/&quot;/g; 									# convert " to &quot
			$value =~ s/%9(3|4)/&quot;/g; 									# convert funny double-quotes to &quot
			$value =~ s/&rsquo;/'/igo; 									# right-side quote
			$value =~ s/&lsquo;/\`/igo; 									# left-side quote

			$value =~ s/%97/\-/igo; 									# convert 'Em' dash to hyphen
			$value =~ s/%ED/i/igo; 										# convert Spanish � to English i

			$value =~ s/%([\da-fA-F]{2})/chr(hex($1))/eg; 							# convert hexidecimal to ASCII -- yes this is working.


			printf("<!--\n"); 										# debug
			printf("<pre>_ITEM: %s\n\t_KEY: %s\n\t_VALUE: %s\n-----</pre>\n", $item, $key, $value); 	# debug
			printf("-->\n"); 										# debug


			# First, if there is a DeleteItem, we need to skip that number, not process it.

			if ($key =~ /(\d+)/)
			{
				my $number=$1;

				if ($POSTdata =~ /DeleteItem$number/i )
				{
			#		printf("<pre><b>Need to delete Item $number ($item)</b></pre>\n");
					next;
				}
			}




			if    ( ($key =~ /^Channel/) && ((! defined $value) || ($value =~ /^\s*$/)) )
			{
				$RequiredFieldsMissing{$key}=1;
				$TotalMissing++;
			}
			elsif ( ($key =~ /^ChannelLink/) && ($value !~ /^https?:\/\/\S+/i ) )
			{
				printf("<b class=\"error\">%s contains an invalid HTTP URL</b> (%s)<p>\n", $key, $value);
				FOOTER();
				exit 1;
			}



			if ($key =~ /^url(\d+)/) 									# If there's a URL field
			{
				my $number=$1;

			#	printf("<pre>number is $number</pre>\n");


				if ( ($value !~ /^$/) && ((! defined $RSS{"title$number"}) || ($RSS{"title$number"} =~ /^$/)) )
				{
					$RequiredFieldsMissing{"title$number"}=1;
					$TotalMissing++;
				}

				if ( ($value =~ /^$/) && ($RSS{"title$number"} !~ /^$/) )
				{
					$RequiredFieldsMissing{$key}=1;
					$TotalMissing++;
				}

				if ( ($value !~ /^$/) && ( $value !~ /^https?:\/\/\S+/i ) )
				{
					printf("<b class=\"error\">%s contains an invalid HTTP URL</b> (%s)<p>\n", $key, $value);
					FOOTER();
					exit 1;
				}

			}

			if ($key =~ /^desc(\d+)/) 									# If there's a Description field
			{
				my $number=$1;

				if ( ($value !~ /^$/) && ((! defined $RSS{"title$number"}) || ($RSS{"title$number"} =~ /^$/)) )
				{
					$RequiredFieldsMissing{"title$number"}=1;
					$TotalMissing++;
				}

				if ( ($value !~ /^$/) && ((! defined $RSS{"url$number"}) || ($RSS{"url$number"} =~ /^$/)) )
				{
					$RequiredFieldsMissing{"url$number"}=1;
					$TotalMissing++;
				}
			}



			next if ( ($key =~ /^title/) && ($value =~/^$/) ); 			# skip empty TITLEs, which, later on, will skip over URLs and DESCs


			$RSS{$key}=$value; 										# Add the information in

		} # ENDS for my $item (@Data)

		printf("</pre>\n"); 											# debug



		if ($TotalMissing)
		{
			printf("<b class=\"error\">There %s %d required field%s missing: </b><br>\n", ($TotalMissing == 1) ? "is" : "are",  $TotalMissing,  ($TotalMissing == 1) ? " " : "s"   );

			foreach my $item (sort (keys %RequiredFieldsMissing) )
			{
				next if ($item =~ /^0$/); 								# dont know where this value came from.

				printf("<dd>$item<br>\n");
			}

			printf("<b class=\"error\">Please go back and fill in the missing fields.</b>");
			FOOTER();
			exit 1;
		}



		if    ( $POSTdata =~ /RSSFilename=(.*?)$/ )
		{
			$OUTPUT=$1;
			$OUTPUT =~ s/\+/ /g; 										# convert + to space
			$OUTPUT =~ s/%([\da-fA-F]{2})/chr(hex($1))/eg; 							# convert hexidecimal to ASCII


			if ($OUTPUT !~ /^S:\/Develop\/$URI/i )
			{
			#	printf("<p><b>ERROR: Invalid filename \"%s\".  Please go back and correct.</b></p>\n", $OUTPUT);
				FOOTER();
				exit 1;
			}
		}
		else
		{
			FOOTER();
			exit 1;
		}

		GenerateRSS();


		$OUTPUT  =~ s/S:\/Develop\/$URI\///i;
		$OUTPUT2 =$OUTPUT;
		$OUTPUT2 =~ s/\.\w+$/.html/i;


#		printf("<script language=\"JavaScript\" type=\"text/javascript\">\n");
#		printf("var Description_XML=\"<br>The XML file is the \\\"raw\\\" syndication source for RSS readers used by news aggregators.  <a href=\\\"http://rss.userland.com/howUseRSS\\\" target=\\\"_blank\\\">More ...</a><br>\\n \";   \n");
#		printf("var Description_HTML=\"<br>The HTML file is a HTML version of the XML file.  It is meant to be included into other webpages via Server Side Includes.  <a href=\\\"/webhelp/\\\" target=\\\"_blank\\\">More ...</a><br>\\n \";\n\n");
#		printf("function Explain_XML()\n{\n");
#		printf("\tdocument.getElementById(\"Description_XML\").innerHTML = Description_XML;\n}\n");
#		printf("function Explain_HTML()\n{\n");
#		printf("\tdocument.getElementById(\"Description_HTML\").innerHTML = Description_HTML;\n}\n");
#		printf("</script>\n\n");



		printf("<p>\n");
#		printf("<h2>RSS.XML</h2>\n");
		printf("<h2>%s</h2>\n", uc($OUTPUT) );
		printf("<a href=\"/$URI/$OUTPUT\"  target=\"_blank\">View the XML file</a>  located at http://$SERVER/$URI/$OUTPUT<br>\n");
#		printf("<span id=\"Description_XML\"><a href=\"javascript:Explain_XML()\">What can I do with this XML file?</a></span><br><br>\n");
		printf("The XML file is the \"raw\" syndication source for RSS readers used by news aggregators.  <a href=\"http://rss.userland.com/howUseRSS\" target=\"_blank\">More ...</a><br>\n");


		printf("<p>\n");
#		printf("<h2>RSS.HTML</h2>\n");
		printf("<h2>%s</h2>\n", uc($OUTPUT2) );
		printf("<a href=\"/$URI/$OUTPUT2\" target=\"_blank\">View the HTML file</a> located at http://$SERVER/$URI/$OUTPUT2<br>\n");
#		printf("<span id=\"Description_HTML\"><a href=\"javascript:Explain_HTML()\">What can I do with this HTML file?</a></span><br><br>\n");
		printf("The HTML file is a HTML version of the XML file.  It is meant to be included into other webpages via Server Side Includes.  <a href=\"/webhelp/\" target=\"_blank\">More ...</a><br>\n\n");
		printf("</p>\n\n");

		printf("<br><br>\n\n");
		printf("\n<a href=\"%s\">Back to the $CoolProgramName</a><p>\n", $SCRIPT);

		FOOTER();
		exit 0;
	}
	else
	{
		printf("Bad POST: %s", $POSTdata);
		FOOTER();
		exit 1;
	}


} # ENDS if ($METHOD =~ /^POST$/)





# All other REQUEST_METHODS
PrintSelections();




#EOF