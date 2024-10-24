#!/usr/bin/perl -w




































































# This is Line 70
use strict;
use warnings;
use File::Find;
use File::Copy;




# Satisify -T
$ENV{"PATH"}="/bin";

my $Modified 			= "2014-Dec-17 by Birl";


my @directories_to_search; 	#=("/usr/local/apache/htdocs/sysadmin");

my @DirectoriesForJavascript;

my $CurrentTabs 		= 0;
my $PreviousTabs 		= 0;
my $MaximumTabs 		= 0;
my $MaximumBoxWidth 		= 750;
my $MaximumNumberFilesToTransfer= 1000;
my $MaximumTotalMegabytes 	= 1024+512;
my $MaximumTotalFileSizeTransfer= 1024*1024*$MaximumTotalMegabytes;

my $URI; 							# kinda OS-specific
my $SERVER 			= $ENV{"SERVER_NAME"};
my $Method 			= $ENV{"REQUEST_METHOD"};
my $REFERER 			= $ENV{"HTTP_REFERER"};
my $Username 			= $ENV{"REMOTE_USER"}; 									# For logging purposes.
my $QUERY 			= $ENV{"QUERY_STRING"};
my $SystemRoot 			= $ENV{"SYSTEMROOT"};
my $COMPUTERNAME 		= $ENV{"COMPUTERNAME"};

my $CurrentTime 		= time; 										# For logfile name.
my $CurrentYr 			= (localtime($CurrentTime))[5]+1900;
my $CurrentMon 			= (localtime($CurrentTime))[4]+1;
my $CurrentDay			= (localtime($CurrentTime))[3];
my $CurrentHr 			= (localtime($CurrentTime))[2];
my $CurrentMin			= (localtime($CurrentTime))[1];
my $CurrentSec 			= (localtime($CurrentTime))[0];

my $DebugFile; 							# OS-specific. 
my $FTU2Blk; 							# OS-specific. Local file, not web file
my $FTU2AJAX; 							# OS-specific. Local file, not web file
my $AJAXFile;
my $IsAre;
my $WWW;
my $LogDir;
my $LogURL;
my $LogFile;
my $RootLevelDevDirectory; 												# The local file system path
my $RootLevelPubDirectory; 												# The local file system path
my $BaseHREF; 														# Similiar to the RootLevelDirectory, but https://
my $WebTools;
my $Parent;
my $OverlordDirectory;
my $OverlordUsername;
my $OverlordWebTools;
my $OverlordFile;

my $LargeFileWarning 		= 1024*1024*15; 									# Megabytes
my $TotalSize			= 0;
my $TotalFiles			= 0;
my $TotalSizeWord		= 0; 											# Post-conversion, ie: 100MB
my $NumberOfMinions 		= 0;

my $FolderOpen;
my $FolderClse;

my $TEMP; 										# OS-specific.

#my $XCACLS 			= "xcacls.exe";
#my $IUSR 			= "IUSR_FrontPage_SVR";

my $OperatingSystem;

#my $MaximumTableColumns 	= 8; 											# Must be an even number
my $Number 			= 1;
my $LabelCounter 		= 0;

my $Directory;
my $ParentDirectory;

my $IsVIP 			= 0; 											# Some extra functionality for Computer Services.

my $EpochStart 			= time;
my $EpochFinish 		= 0;

my %FilesThatExistOnDevelop;
my %UserBlacklist;
my %OtherFTUS;





$|=1; 	# Disable buffering on STDOUT.  Get the data out to the browser asap.





if (defined $ENV{"PATH_INFO"} )
{
	$URI=$ENV{"PATH_INFO"}; 		# IIS
	$OperatingSystem="Windows";

	$RootLevelDevDirectory 	= sprintf("S:/Develop%s", $URI);
	$LogFile 		= sprintf("S:/Develop%s", $URI);
}
else
{
	$URI=$ENV{"SCRIPT_NAME"}; 		# Apache
	$OperatingSystem="Unix";

	$RootLevelDevDirectory 	= sprintf("/usr/local/apache/htdocs-develop%s", $URI);
	$LogFile 		= sprintf("/usr/local/apache/htdocs-develop%s", $URI);
}


# If the Username is LDAP
if ($Username =~ /dc=temple,dc=edu/i )
{
	$Username = $ENV{"AUTHENTICATE_UID"};
}



# The overriding factor in case of emergency
#$Username = "ScootPERL" if ( (! defined $Username) || ($Username =~ /^\s*$/) || ($Username =~ /^I(USR|WAM)_/i ) );




################################################################
# HTTP HEADERS
################################################################

if ($OperatingSystem =~ /^Windows$/) 						# Apache dont like the Redirect
{
	if ( (! defined $ENV{"HTTPS"}) || ($ENV{"HTTPS"} !~ /^on$/i) ) 		# If the user isnt using https://  then force them to https://
	{
		printf("HTTP/1.x 301 Moved Permanently\n");
		printf("Location: https://%s%s\n", $SERVER, $URI); 		# Cannot use :8443 for Proof/Imprint.  Will interfere with www-dev
		printf("X-Application: FTU2 $Modified\n");
		printf("Pragma: nocache\n");
		printf("Expires: Thu, 01 Jan 1970 00:00:00 GMT\n");
		printf("Cache-Control: no-cache, no-store, must-revalidate, max-age=0\n");
		printf("Content-Type: text/html\n\n");
		exit 0;
	}
}


printf("X-Application: FTU2 $Modified\n");
printf("Pragma: nocache\n");
printf("Expires: Thu, 01 Jan 1970 00:00:00 GMT\n");
printf("Cache-Control: no-cache, no-store, must-revalidate, max-age=0\n");
printf("Content-Type: text/html\n\n"); 						# This line MUST be the last HTTP header written out!






################################################################
# Set up our variables
################################################################

if ($OperatingSystem =~ /^Windows$/)
{
	$OverlordDirectory="S:/FTU2";
	$TEMP="S:/TEMP/FTU2_AJAX";
}
else
{
	$OverlordDirectory="/usr/local/apache/overlord";
	$TEMP="/tmp";
}


#$FolderClse="https://www.temple.edu/icons/right.gif";
#$FolderOpen="https://www.temple.edu/icons/down.gif";

#$FolderClse="https://www.temple.edu/icons/+.gif";
#$FolderOpen="https://www.temple.edu/icons/-.gif";

$FolderClse="https://www.temple.edu/icons/folder.gif";
$FolderOpen="https://www.temple.edu/icons/folder.open.gif";

if ($Username =~ /kpeachd/)
{
	$FolderClse="/ftu_images/peach.gif";
#	$FolderOpen="/ftu_images/peach.gif";
}

$RootLevelDevDirectory 	=~ s/\/WebTools\/.*$//i;

$RootLevelPubDirectory 	= $RootLevelDevDirectory;
$RootLevelPubDirectory 	=~ s/Develop/publish/i;

$BaseHREF 		=  sprintf("https://${SERVER}%s", $URI );
$BaseHREF 		=~ s/\/WebTools\/.*$//i;

$WWW 			=  sprintf("http://www.temple.edu%s", $URI );
$WWW 			=~ s/\/WebTools\/.*$//i;


$WebTools=  $URI;
$WebTools=~ s/\w+.pl$//;

$Parent = $URI;
$Parent =~ s/(^\/\w+).*$/$1\/WebTools\//;

$LogDir  =  sprintf("%s", $URI);
$LogDir  =~ s/\w+.pl$/FTU_log\//;

$LogFile =~ s/\w+.pl$/FTU_log\//;

	if (! -d "$LogFile")
	{
		mkdir("$LogFile");
	}


$LogFile 	= sprintf("%s%4.4d%2.2d%2.2d.html", $LogFile, $CurrentYr, $CurrentMon, $CurrentDay);
$LogURL 	= sprintf("%s%4.4d%2.2d%2.2d.html", $LogDir,  $CurrentYr, $CurrentMon, $CurrentDay);


if ( (! defined $REFERER) || ($REFERER =~ /^\s*$/) )
{
	$REFERER="Webpage accessed directly.";
}


$OverlordUsername = $Username;
$OverlordWebTools = $WebTools;

$OverlordUsername =~ s/DEVELOP(DR)?\\//i;
$OverlordUsername =~ s/TU\\//i;

$OverlordWebTools =~ s/\/WebTools\///i;
$OverlordWebTools =~ s/\///;
$OverlordWebTools =~ s/\//\^/g;

# The lower the number, the sooner processed.
$OverlordFile = sprintf("%s/%d#%s#%s.txt", $OverlordDirectory, $CurrentTime, $OverlordWebTools, $OverlordUsername);

#$AJAXFile = sprintf("%s/WebTools/files_to_transfer_tmp.txt", 	$RootLevelDevDirectory);
#$AJAXFile = sprintf("$TEMP/%s_files_to_transfer_tmp.txt", 	$OverlordWebTools);
$AJAXFile = sprintf("$TEMP/000000000#%s#%s.txt", $OverlordWebTools, $OverlordUsername); 	# Match the temporary AJAX file to the OverlordFile for emergency use.
$FTU2AJAX = sprintf("%s/WebTools/ftu2ajax.pl", 			$RootLevelDevDirectory);
$FTU2Blk  = sprintf("%s/WebTools/ftu2blacklist.pl", 		$RootLevelDevDirectory);


#$DebugFile=sprintf("%s/debug_%s_%4.4d%2.2d%2.2d-%2.2d%2.2d%2.2d.txt", $TEMP, $OverlordUsername, $CurrentYr, $CurrentMon, $CurrentDay, $CurrentHr, $CurrentMin, $CurrentSec);
$DebugFile=sprintf("%s/debug_FTU2_%4.4d%2.2d%2.2d_%s__%s.txt", $TEMP, $CurrentYr, $CurrentMon, $CurrentDay, $OverlordUsername, $OverlordWebTools);

################################################################
# subroutes aka functions
################################################################

sub Bottom()
{
	printf("<br>\n");
	printf("<div id=\"FOOTER\" style=\"color:#FFffFF; background-color:#008282; font-size:10px; text-align:right; padding:2px;\">\n");
	printf("&copy; Copyright 2007-%d <a href=\"http://www.temple.edu/\" style=\"font-weight:bold; color:#FFffFF;\" target=\"_blank\"><u>Temple University</u></a> <a href=\"http://www.temple.edu/cs/\" style=\"font-weight:bold; color:#FFffFF;\" target=\"_blank\"><u>Computer Services</u></a>.\n", $CurrentYr );
	printf("All Rights Reserved.<br>\n");
	printf("For questions, please email <a href=\"mailto:webhelp\@temple.edu\" style=\"font-weight:bold; color:#FFffFF;\" target=\"_blank\"><u>webhelp\@temple.edu</u></a>\n");
	printf("</div>\n\n");
	printf("</body>\n");
	printf("</html>\n\n");
}





sub FilenameHeader()
{
	printf("<div style=\"background-color:#AAF; color:#000; padding:3px; display:block; position:relative; left:0px;\">&nbsp;<b style=\"position:relative; left:20px; display:inline;\">File/Directory Name</b> <b style=\"position:relative; left:150px;\">Date Modified</b> <b style=\"position:relative; left:295px;\">File Size</b> <b style=\"position:relative; left:345px;\">Action Needed</b></div>");
	printf("\n");
}




sub TestContactInfo()
{
	# debug

	printf("<pre style=\"padding:5px;\" title=\"Debugging information.\" onclick=\"HideShowTable('debug_subsection');\">\n");
	printf("<h1>FTU 2.5&#223;: TEST mode</h1>\n");
	printf("<b style=\"font-size:14pt;\">Code updated:</b> %s by <b>S.A. Birl</b>\n\n", scalar(localtime((stat($0))[9])) );
	printf("Help documentation written. Link at the top.<br/>\n");
	printf("<b>A small number of websites have timed out during the loading of FTU2.  Usually due to 1000 or more files.  Please try the blacklist above.</b>\n\n");
	printf("<b>If something is not working, please contact the Help Desk via <a href=\"https://tuhelp.temple.edu\" target=\"_blank\">TU Help</a></b>\n\n");
	printf("<div id=\"debug_subsection\" style=\"display:none;\">\n");
	printf("\n\n\n");
	printf("Me only -- <a href=\"chrome://ietab/content/reloaded.html?url=https://%s%s\">IE tab</a> -- <b>cut and paste</b> into a new Mozilla tab.\n<p>\n", $SERVER, $URI);
	printf("\n\n");
	printf("Questions, comments, etc need to be directed to <a href=\"mailto:sbirl\@temple.edu?CC=v.m\@temple.edu&Subject=FTU2\"><u style=\"font-weight:bold\">the server administrators</u></a> sbirl\@temple.edu, v.m\@temple.edu, gmayro\@temple.edu with <b>FTU2</b> in the subject.\n\n\n");
	printf("<input type=\"checkbox\" DISABLED CHECKED> <del>Has an Overlord?</del>\n");
	printf("<input type=\"checkbox\" DISABLED CHECKED> <del>Get this to work properly with Internet Explorer again.</del>\n");
	printf("<input type=\"checkbox\" DISABLED CHECKED> <del>Delete obsolete files from WWW.</del>\n");
	printf("<input type=\"checkbox\" DISABLED CHECKED> <del>Merge MasterFTU (aka Enterprise FTU, aka EFTU) into FTU2.</del>\n");
	printf("<input type=\"checkbox\" DISABLED CHECKED> <del>Eliminate restrictions on file quantity/size</del>\n");
	printf("<input type=\"checkbox\" DISABLED CHECKED> <del>Ability to select a sub-directory and all files underneath it.</del>\n");
	printf("<input type=\"checkbox\" DISABLED        > Work on the user interface -- partially done.\n");
	printf("<input type=\"checkbox\" DISABLED        > Should there be an auto-select of files modified within the last 24 hours? 	<a href=\"mailto:sbirl\@temple.edu?Subject=FTU2+auto-select\">sbirl\@temple.edu</a>\n");
	printf("<input type=\"checkbox\" DISABLED        > Should there be an auto-select of files that do not exist on WWW? 		<a href=\"mailto:sbirl\@temple.edu?Subject=FTU2+auto-select\">sbirl\@temple.edu</a>\n");
	printf("<input type=\"checkbox\" DISABLED CHECKED> <b>Has user-defined blacklist?</b>\n");
	printf("<input type=\"checkbox\" DISABLED CHECKED> <b>Has AJAX back-end.</b>\n");
#	printf("<input type=\"checkbox\" DISABLED        > \n");
	printf("</div>\n");
	printf("</pre>\n");

}






sub ShowCriticalVariables()
{
	# debug

	if ($Username =~ /^(DEVELOP(DR)?\\sbirl|sbirl(test|-local)?)$/)
	{
		printf("<a onclick=\"HideShowTable('Critical');\" style=\"cursor:pointer;\"><u style=\"font-weight:bold\">Critical</u></a>\n");
	}

	printf("\n\n\n<pre style=\"width:800px; display:none;\" title=\"Debugging information.\" id=\"Critical\">\n");
	printf("OperatingSystem:       \"%s\"\n", $OperatingSystem);
	printf("Zero:                  \"%s\"\n", $0);
	printf("Modified:              \"%s\"\n", $Modified);
	printf("Temp:                  \"%s\"\n", $TEMP);
	printf("DebugFile:             \"%s\"\n", $DebugFile);
	printf("URI:                   \"%s\"\n", $URI);
	printf("BaseHREF:              \"%s\"\n", $BaseHREF);
	printf("WWW:                   \"%s\"\n", $WWW);
	printf("Parent WebTools:       \"%s\"\n", $Parent);
	printf("WebTools:              \"%s\"\n", $WebTools);
	printf("SERVER:                \"%s\"\n", $SERVER);
	printf("QUERY:                 \"%s\"\n", $QUERY);
	printf("Method:                \"%s\"\n", $Method);
	printf("Username:              \"%s\"\n", $Username);
	printf("REFERER:               \"%s\"\n", $REFERER);
	printf("LogFile:               \"%s\"\n", $LogFile);
	printf("LogDir:                \"%s\"\n", $LogDir);
	printf("LogURL:                \"%s\"\n", $LogURL);
	printf("AJAXFile:              \"%s\"\n", $AJAXFile);
	printf("FTU2AJAX:              \"%s\"\n", $FTU2AJAX);
	printf("FTU2Blk:               \"%s\"\n", $FTU2Blk);
	printf("OverlordDirectory:     \"%s\"\n", $OverlordDirectory);
	printf("OverlordUsername:      \"%s\"\n", $OverlordUsername);
	printf("OverlordWebTools:      \"%s\"\n", $OverlordWebTools);
	printf("OverlordFile:          \"%s\"\n", $OverlordFile);
	printf("RootLevelDevDirectory: \"%s\"\n", $RootLevelDevDirectory);
	printf("RootLevelPubDirectory: \"%s\"\n", $RootLevelPubDirectory);
	printf("IsVIP:                 \"%s\"\n", $IsVIP);

	printf(DEBUG "CurrentTime:           \"%s\"\n", scalar(localtime($CurrentTime)) );
	printf(DEBUG "\n");
	printf(DEBUG "OperatingSystem:       \"%s\"\n", $OperatingSystem);
	printf(DEBUG "Zero:                  \"%s\"\n", $0);
	printf(DEBUG "Modified:              \"%s\"\n", $Modified);
	printf(DEBUG "Temp:                  \"%s\"\n", $TEMP);
	printf(DEBUG "DebugFile:             \"%s\"\n", $DebugFile);
	printf(DEBUG "URI:                   \"%s\"\n", $URI);
	printf(DEBUG "BaseHREF:              \"%s\"\n", $BaseHREF);
	printf(DEBUG "WWW:                   \"%s\"\n", $WWW);
	printf(DEBUG "Parent WebTools:       \"%s\"\n", $Parent);
	printf(DEBUG "WebTools:              \"%s\"\n", $WebTools);
	printf(DEBUG "SERVER:                \"%s\"\n", $SERVER);
	printf(DEBUG "QUERY:                 \"%s\"\n", $QUERY);
	printf(DEBUG "Method:                \"%s\"\n", $Method);
	printf(DEBUG "Username:              \"%s\"\n", $Username);
	printf(DEBUG "REFERER:               \"%s\"\n", $REFERER);
	printf(DEBUG "LogFile:               \"%s\"\n", $LogFile);
	printf(DEBUG "LogDir:                \"%s\"\n", $LogDir);
	printf(DEBUG "LogURL:                \"%s\"\n", $LogURL);
	printf(DEBUG "AJAXFile:              \"%s\"\n", $AJAXFile);
	printf(DEBUG "FTU2AJAX:              \"%s\"\n", $FTU2AJAX);
	printf(DEBUG "FTU2Blk:               \"%s\"\n", $FTU2Blk);
	printf(DEBUG "OverlordDirectory:     \"%s\"\n", $OverlordDirectory);
	printf(DEBUG "OverlordUsername:      \"%s\"\n", $OverlordUsername);
	printf(DEBUG "OverlordWebTools:      \"%s\"\n", $OverlordWebTools);
	printf(DEBUG "OverlordFile:          \"%s\"\n", $OverlordFile);
	printf(DEBUG "RootLevelDevDirectory: \"%s\"\n", $RootLevelDevDirectory);
	printf(DEBUG "RootLevelPubDirectory: \"%s\"\n", $RootLevelPubDirectory);
	printf(DEBUG "IsVIP:                 \"%s\"\n", $IsVIP);
	printf(DEBUG "\n\n");

	printf("</pre>\n");
	printf("<br>\n\n\n\n");

}
#ENDS sub ShowCriticalVariables()





sub ViewCurrentLog()
{
	printf("<br>\n");
	printf("<div style=\"border:solid 1px #000000; width:${MaximumBoxWidth}px; background-color:#DDddDD; padding:3px;\">\n");
	printf("<a href=\"%s\" target=\"_blank\"><b>View %s</b></a>\n<p>\n", $WWW, $WWW);
	printf("<a href=\"%s\">Go back to the File Transfer Utility</a></b>\n<br>\n", $URI);
	printf("<a href=\"%s\" target=\"_blank\">Go back to the WebTools directory</a></b>\n<br>\n", $WebTools);
	printf("<a href=\"%s\" target=\"_blank\">View the log file of this transfer</a></b>\n", $LogURL);
	printf("</div>\n");
}





sub ViewAllLogs()
{
	printf("<br>\n<a href=\"%s\" target=\"_blank\">View the logs of previous transfers</a>\n<br>\n", $LogDir);
}





sub PrintEnv()
{
	# Heavy debugging

	printf("<pre>\n");

	my $val;
	my $var;

	foreach $var (sort(keys(%ENV)))
	{
	    $val = $ENV{$var};
	    $val =~ s|\n|\\n|g;
	    $val =~ s|"|\\"|g;
	    print "${var}=\"${val}\"\n";
	}

	printf("</pre>\n<br><br>\n");
}










# Remove all files from this specific directory
sub RemovePublishF()
{
	my @Dir = split(/\//, $File::Find::name);

	if (-f "$File::Find::name")
	{
		printf(LOG " [F] " . " " x (($#Dir)-2) . "%s" . "\t" x (5-($#Dir)), $File::Find::name);

		if (! unlink("$File::Find::name") )
		{
			printf(LOG " &nbsp; <b>UNLINK FAILED:</b> $! ($^E)");
		}

		printf(LOG "\n");
	}
}




# Remove all directories from this specific directory -- only works when all files have been removed first.
sub RemovePublishD()
{
	my @Dir = split(/\//, $File::Find::name);

#	printf("$File::Find::name ($#Dir)<br>");

	return if ($#Dir == 3);

	if (-d "$File::Find::name")
	{
		printf(LOG " [D] " . " " x (($#Dir)-2) . "%s" . "\t" x (5-($#Dir)), $File::Find::name);
	
		if (! rmdir("$File::Find::name") )
		{
			printf(LOG " &nbsp; <b>RMDIR FAILED:</b> $! ($^E)");
		}
	
		printf(LOG "\n");
	}
}










sub FILES($)
{
	my $FILE=shift;

	if (! defined $_)
	{
		$_=$FILE;
	}


}





sub SearchDevelop()
{
	my $FILE 		= $File::Find::name; 									# http://
	my $ShortFILE 		= $File::Find::name; 									# no URL, no Base Directory
	my @Dir 		= split(/\//, $File::Find::name);
	my $PublishLastModified;
	my $DevelopLastModified;



#	printf("$_\n);
#	printf("$_\n$File::Find::name\n$File::Find::dir\n\n");


	if ($FILE =~ /^[A-Z]:/ ) 											# Windows directory
	{
		$FILE      =~ s/^$RootLevelDevDirectory/$BaseHREF/;
		$ShortFILE =~ s/^$RootLevelDevDirectory//;
	}
	else
	{
	#	$FILE =~ s/\/usr\/local\/apache\///;
		$FILE      =~ s/^$RootLevelDevDirectory/$BaseHREF/;

	#	if ($FILE =~ /htdocs/)
	#	{
	#		$FILE =~ s/htdocs//;
	#	}
	}


	return if ($FILE =~ /^(\s+)?$/); 										# skip over anything blank
	return if ($FILE =~ /\.lck$/i ); 										# skip over lockfiles.
	return if ($FILE =~ /\.bak$/i ); 										# skip over backup files

	for my $banned (sort (keys %UserBlacklist))
	{
		my $TempBannedName = $banned;
		$TempBannedName =~ s/\\//g;

		if ($FILE =~ /$banned/i )
		{
	#		printf("<pre><b>$FILE has been blacklisted by the filter \"$TempBannedName\"</b></pre>\n"); 	# not debug; inform the user
			return;
		}
	#	else
	#	{
	#		printf("<pre>No match\n</pre>\n"); 								# debug
	#	}
	}


#	return if ( ($File::Find::name =~ /(AppDev|MMWIP|Templates)/i ) && ($IsVIP == 0) ); 				# original

	return if ( (-d $File::Find::name) && ($_ =~ /^(AppDev|MMWIP|Templates)$/i ) && ($IsVIP == 0) ); 		# directories named AppDev|MMWIP|Templates
	return if ( (-d $File::Find::dir)  && ($File::Find::dir =~ /(AppDev|MMWIP|Templates)/i ) && ($IsVIP == 0) ); 	# files within those directories -- might not be perfect

	# skip over specific directories.
	return if ( ($File::Find::name =~ /_(vti|private$|notes$|mm|baks$)/i ) && (-d $File::Find::name) );


	if ($File::Find::name =~ /WebTools/i)
	{
		if (-f "$File::Find::name/ftu2.pl")
		{
			$OtherFTUS{"$File::Find::name/ftu2.pl"}=1;
		}
		return;
	}


#	$FilesThatExistOnDevelop{}=1;




# DIRECTORIES
	if (-d $File::Find::name) 											# directory
	{
		return if ($QUERY =~ /^(list|force)/i);

		$CurrentTabs= $#Dir - 2;


#		printf("\n\n\n\n<!----- %s  %d tab(s) ----->\n\n", $File::Find::name, $CurrentTabs);

		if    ( $PreviousTabs >= $CurrentTabs )
		{
			while ($PreviousTabs-- >= $CurrentTabs) 							# must be  >=   not  >
			{
				printf("	" x $CurrentTabs . "</ul>\n\n");
			}

		#	printf("</script>\n");
			$LabelCounter=0;
		}


		printf("<!-- Folder -->\n");

		if ( $PreviousTabs <= $CurrentTabs )
		{
			printf("        " x $CurrentTabs     . "<script type=\"text/javascript\" language=\"JavaScript\">\n");
			printf("        " x ($CurrentTabs+1) . "document.writeln('<img id=\"%s_image\" src=\"$FolderClse\" alt=\"Open list\" onClick=\"toggleFolder(\\'%s_image\\',\\'%sList\\');\" style=\"cursor:pointer;\" title=\"Open Directory.\">');\n", $FILE, $FILE, $FILE);
			printf("        " x $CurrentTabs     . "</script>\n");


			# BEGINNING OF directory name

			# We dont want the ID of the checkbox, but the UL tag
			if ( ($FILE cmp $BaseHREF) != 0)
			{
			#	printf("        " x $CurrentTabs     . "<input type=\"checkbox\" id=\"%s\" name=\"%s\" onClick=\"selectTree('%sList', this);\" %s DISABLED> ", $File::Find::name, $File::Find::name, $FILE,   ( ($FILE cmp $BaseHREF) != 0 ) ? "" : "DISABLED");
				printf("        " x $CurrentTabs     . "<input type=\"checkbox\" id=\"%s\" name=\"%s\" onClick='ajaxFunction(\"%s\"); toggleColor(\"%s\",\"%s_Label\");' %s > ", $File::Find::name, $File::Find::name, $File::Find::name, $File::Find::name, $File::Find::name,   ( ($FILE cmp $BaseHREF) != 0 ) ? "" : "DISABLED");
			}
			printf("        " x $CurrentTabs . "<label for=\"%s\" style=\"cursor:row-resize;\" title=\"Clicking on this folder name will select ALL files underneath of it.\"><b>%s</b></label>\n",  $File::Find::name, $FILE);





		#	printf("%s\n", $File::Find::name); 								# debug
		#	printf("&nbsp; &nbsp; &nbsp; %d dirs - %d tab(s)\n", $#Dir, $CurrentTabs); 			# debug
			printf("	" x $CurrentTabs . "<br>\n");


			printf("\t<ul id=\"%sList\" >\n", $FILE);

			FilenameHeader();
		}





		printf("\t\t<script type=\"text/javascript\" language=\"JavaScript\">\n");
		printf("\t\t\tdocument.getElementById('%sList').style.display =\"none\";\n", $FILE);
	#	printf("\t\t\tdocument.getElementById(\"ReadyToGo\").innerHTML=\"Loading sub-directory %s\";\n", $_ );
		printf("\t\t\tdocument.getElementById(\"ReadyToGo\").innerHTML=\"Loading sub-directory %s\";\n", $FILE );
		printf("\t\t</script>\n\n");

	#	push(@DirectoriesForJavascript, $FILE);



		$PreviousTabs = $CurrentTabs;

		if ($CurrentTabs > $MaximumTabs)
		{
			$MaximumTabs = $CurrentTabs;
		}

		if ($PreviousTabs > $MaximumTabs)
		{
			$MaximumTabs = $PreviousTabs;
		}

	}
# FILES 1461 days = 126230400
	else 														# files
	{
	#	return; 												# debug


		printf("<!-- File -->\n") 		if ($QUERY !~ /^(list|force)/i);

		return if ($_ =~ /^robots.txt$/i ); 							# Gene, Viral, Jemin said just skip over this file.


		my ($FileSize, $FileModified) = (stat("$File::Find::name"))[7,9];
		my $PublishFile 	= $File::Find::name;
		my $PublishFMod;
		my $ByteSize    	= $FileSize;
		my $SizeWarning		= 0;
	#	my $TooOldWarning 	= 0;
		my $Error 		= 0;
		my $InvalidChar;
	#	my $TooOld 		= 126230400;
		my $DisableCheckbox 	= 0;

		$PublishFile =~ s/Develop/publish/i; 							# i  for apache
		if (-f "$PublishFile")
		{
			$PublishFMod = (stat("$PublishFile"))[9];
		}
		else
		{
		# 	printf("$PublishFile: $!\n"); 							# debug
			$PublishFMod = 0;
		}

		$TotalSize += $FileSize;
		$TotalFiles++;

		# An &  *is* valid as part of a filename.  Go figure!
		# $1 will only catch 1 invalid character.  Enduser will have to correct and re-validate
		if ($_ =~ /([^A-Z0-9\_\.\-\+\=\*\(\)\[\]\,\@\&\'\$\:\;\!\^\~\s])+/i )
		{
			$Error++;
			$InvalidChar=$1;
		}




		$DisableCheckbox=1 if ($PublishFMod >= $FileModified);



		################################################################################################
		# This little section of code is for SERVER ADMINS ONLY and cannot be shown to the end-user.
		# LIST  will dump out a plain-text version of the files to be updated.  That file can then be passed to the Overlord.
		# FORCE will dump out a plain-text version directly to the Overlord.
		# 
		# For more information go to about line 2020

		if ($QUERY =~ /^(list|Force)/i)
		{
		#	return if (-d $File::Find::name);
			return if ($Error);
			return if ($DisableCheckbox);
			return if ($PublishFMod == $FileModified);
			return if ($File::Find::name =~ /_(vti|private$|notes$|mm|baks$)/i );

			printf(AJAXFILE "%s\n", $File::Find::name) if ( open(AJAXFILE, ">>$AJAXFile") );
			printf("%s\n", $File::Find::name);
			return;
		}

		################################################################################################






	# Display each file
		printf("	" x $CurrentTabs . "<div style=\"padding:2px; border:solid 1px #AAA; display:block; cursor:%s\" id=\"%s_Label\">\n", $Error ? "not-allowed" : "default", $File::Find::name );

		printf("	" x $CurrentTabs . "\t<span style=\"border:0px solid #070; display:block; position:relative; left:0px; padding:0px 0px 2px 0px;\">\n");
		if ( ($Error) || ($DisableCheckbox) )
		{
			printf("	" x $CurrentTabs . "\t&nbsp; &nbsp;\n");
		}
		else
		{
	# checkbox
			printf("	" x $CurrentTabs . "\t<input type=\"checkbox\" id=\"%s\" onclick='ajaxFunction(\"%s\"); toggleColor(\"%s\",\"%s_Label\");' style=\"cursor:%s\" %s>\n", $File::Find::name, $File::Find::name, $File::Find::name, $File::Find::name, $DisableCheckbox ? "not-allowed" : "pointer", $DisableCheckbox ? "DISABLED" : "" );
		}
		printf("	" x $CurrentTabs . "\t<label for=\"%s\" style=\"cursor:pointer; display:inline;\">\n", $File::Find::name);
	#	printf("	" x $CurrentTabs . " <!-- Name -->\t<a href=\"%s\" target=\"_blank\" title=\"%s\">%s</a>\n", $FILE, $FILE, $ShortFILE);
		printf("	" x $CurrentTabs . " <!-- Name -->\t<a href=\"%s\"  target=\"_blank\" title=\"%s\">%s</a>\n", $FILE, $FILE, $_);


	# Date Modified
		printf("        " x $CurrentTabs . " <!-- Date -->\t<span style=\"position:absolute; left:340px; display:inline; border:0px solid #0F0; width:200px; padding:2px 5px 0px 5px; cursor:%s; background-color:#FFF;\" title=\"Date file was last modified.\">%s</span>\n", $Error ? "not-allowed" : "default", scalar(localtime($FileModified))   );




	# FileSize
		printf("        " x $CurrentTabs . "\t\t<input type=\"hidden\" id=\"%s_bytes\" value=\"%d\">\n", $File::Find::name, $ByteSize);
		printf("        " x $CurrentTabs . " <!-- Size -->\t<span style=\"position:absolute; left:610px; display:inline; border:0px solid #0F0; padding:0px 3px 0px 3px; cursor:%s; background-color:#FFF;\" title=\"File size.\">", $Error ? "not-allowed" : "default");

			if    ($FileSize == 0)
			{
				printf("<i>empty!</i>");
			}
			elsif ($FileSize >= 1024)
			{
				$FileSize /= 1024; 		# kilobytes


				if ($FileSize >= 1024)
				{
					$FileSize /= 1024; 	# megabytes


					if ($FileSize >= 1024) 	# gigabytes
					{
						$FileSize /= 1024;
	#					printf("(~ %d GB)", $FileSize);
						printf("%d GB", $FileSize);
					}
					else
					{
	#					printf("(~ %d MB)", $FileSize);
						printf("%d MB", $FileSize);
					}




					if    ($ByteSize >= $MaximumTotalFileSizeTransfer)
					{
						printf("	" x $CurrentTabs . "<br>\n<span style=\"background-color:#FFdddd; font-weight:bold;\">ERROR: $FILE is too big for the FTU.</span>\n");
					}
					else
					{
						$SizeWarning=1;
					}
				}
				else
				{
	#				printf("(~ %d KB)", $FileSize);
					printf("%d KB", $FileSize);
				}
			}
			else
			{
					printf("%3d b", $FileSize);
			}
			printf("</span>\n"); 					# span for size


	# Update?
		if (! $Error)
		{
			if ($PublishFMod != $FileModified)
			{
				printf("        " x $CurrentTabs . "\t<b style=\"cursor:help; display:inline; position:absolute; left:750px;\" title=\"%s\">Update</b>\n", ($PublishFMod > 0) ? "This file is newer than the live file." : "This file does not exist on the live site."   );
			}
			else
			{
				printf("        " x $CurrentTabs . "\t<i style=\"cursor:help; display:inline; position:absolute; left:750px; color:#999;\" title=\"No update is needed.\">none</i>\n");
			}
		}
		else
		{
				printf("        " x $CurrentTabs . "\t<b style=\"cursor:help; display:inline; position:absolute; left:750px;\" title=\"Correction needed.\">Fix error</b>\n"   );
		}


#		printf("	" x $CurrentTabs . "\t<b>$PublishFile</b>\n"); 	# debug
		printf("	" x $CurrentTabs . "\t</label>\n");
		printf("        " x $CurrentTabs . "\t</span>\n"); 		# span of file name
		$LabelCounter++;





	# Warnings
		if ($File::Find::name =~ /\s/ )
		{
			printf("	" x $CurrentTabs . "\t<div style=\"padding:3px; background-color: #FA7; cursor:default;\"><b class=\"error\">WARNING:</b> Whitespace character found in <span style=\"background-color:#DDddDD\">%s</span>.  Whitespace should be eliminated (using your web editor) before continuing the transfer.</div>\n\n", $FILE);
		}


		if ($Error)
		{
			printf("	" x $CurrentTabs . "\t<div style=\"padding:3px; background-color: #FA7; cursor:not-allowed;\"><b class=\"error\">ERROR:</b> An invalid character <span style=\"background-color:#DDddDD\">$InvalidChar</span> found in <span style=\"background-color:#DDddDD\">%s</span>.  Non-alphanumeric characters must eliminated (using your web editor) before the file can be selected for transfer.</div>\n", $_);
		}


		if ($SizeWarning && ($Error == 0) )
		{
			printf("	" x $CurrentTabs . "\t<div style=\"padding:3px; background-color: #FA7; cursor:progress;\"><b class=\"error\">WARNING:</b> Selecting this file will result in a long transfer time.</div>\n");
		}




	#	printf("	" x $CurrentTabs . "\t<br>\n");
		printf("	" x $CurrentTabs . "</div>\n");
		printf("\n\n\n\n");
	}

} # ENDS SearchDevelop










sub CloseLog($)
{
	my $error=shift;

	if ($error != 0)
	{
		printf(LOG "<h2 style=\"color:#FF0000;\">A fatal error occured.</h2>\n");
	}

	printf(LOG "</pre>\n");
	printf(LOG "</div>\n<br><br><br>\n\n\n");

	close(LOG);
}




##############
#            #
# Master FTU #
#            #
##############

sub FindOtherFTU()
{
	no warnings 'File::Find';

	my $temp=$File::Find::name;
	$temp =~ s/$RootLevelDevDirectory/$BaseHREF/;

	if ( ($File::Find::name =~ /WebTools$/i) && (-d $File::Find::name) )
	{
		printf("<li><a href=\"%s\" target=\"_blank\">%s</a>\n", $temp, $temp);
		printf("\t<dd>");

		if    ( (-f "$File::Find::name/ftu2.shtml") && (! -f "$File::Find::name/MasterFTU.shtml") )
		{
			unlink("$File::Find::name/ftu2.shtml");
#			printf("<a href=\"%s/ftu.shtml\" target=\"_blank\">[ FTU1 ]</a> ", $temp);
		}
		elsif (-f "$File::Find::name/MasterFTU.shtml")
		{
			unlink("$File::Find::name/MasterFTU.shtml");
			printf("<a href=\"%s/MasterFTU.shtml\" target=\"_blank\">[ MasterFTU 1 ]</a> ", $temp);
		}


# removed 2014-Nov-10
#		if (-f "$File::Find::name/ftu2.pl")
#		{
#			printf("<a href=\"%s/ftu2.pl\" target=\"_blank\">[ FTU2 ]</a> ", $temp);
#
#		}
#		else
#		{
#			# People want  Target=_blank  here
#			printf("<a href=\"?copy=$File::Find::name\" target=\"_blank\">{ <i>Copy FTU2 here</i> }</a> ");
#		}
#
		if ($IsVIP && (-f "$File::Find::name/ftu2.pl") )
		{
			printf("<a href=\"?copy=$File::Find::name\" target=\"_blank\">{ Admins: <i>Re-Copy FTU2 here</i> }</a> ");

		}


# removed 2014-Nov-10
#		if (-d "$File::Find::name/stats")
#		{
#			printf("<a href=\"%s/stats/\" target=\"_blank\">[ Stats ]</a> ", $temp);
#		}
#
#		if (-f "$File::Find::name/create_RSS_XML.pl")
#		{
#			printf("<a href=\"%s/create_RSS_XML.pl\" target=\"_blank\">[ RSS ]</a> ", $temp);
#		}

		if (-f "$File::Find::name/current_list_of_webmasters.html")
		{
			printf("<a href=\"%s/current_list_of_webmasters.html\" target=\"_blank\">[ Web Administrators ]</a> ", $temp);
		}

		printf("</dd>\n<p>\n\n");
	}

	return;

	if ( ($File::Find::name =~ /WebTools\/ftu2.pl/i) && (-f $File::Find::name) )
	{

		printf("<li><a href=\"%s\" target=\"_blank\">%s</a>\n", $temp, $temp);
	}

} # ENDS FindOtherFTU





sub CheckOverlord()
{
	if ( opendir(OverlordDIR, "$OverlordDirectory") )
	{
		$NumberOfMinions = 0;

		while( my $Minion = readdir(OverlordDIR) )
		{
			next if ($Minion =~ /^\.\.?$/ );
			next if ($Minion =~ /^debug.txt$/ );
			next if ($Minion !~ /#/ );
			next if ($Minion =~ /\.lock$/ );

		#	printf("<i>$Minion</i> -- "); 			# debug
			$NumberOfMinions++;
		}
	}

	if ( opendir(OverlordDIR, "$OverlordDirectory") )
	{
		while( my $Minion = readdir(OverlordDIR) )
		{
			next if ($Minion =~ /^\.\.?$/ );
			next if ($Minion =~ /^debug.txt$/ );
			next if ($Minion !~ /#/ );
			next if ($Minion =~ /\.lock$/ );

		#	printf("<i>$Minion</i> -- "); 			# debug
		#	$NumberOfMinions++;

			my @temp = split(/#/, $Minion);

		#	if ($temp[1] =~ /^$OverlordWebTools/)
			if ($OverlordWebTools =~ /^$temp[1]/) 		# this should prevent children FTUs from executing.
			{
				my $MinionLines=0;

				if ( open(TEMP, "$OverlordDirectory/$Minion") )
				{
					while(<TEMP>) {}

					$MinionLines=$.;
					close(TEMP);
				}

				$temp[2] =~ s/\.txt$//i;

				printf("<div style=\"display:table; border:solid 2px #000; padding:3px; background-color:#FDD; color:#000;\"> ");
				printf("\t<h2>A transfer is already in progress:</h2>\n");
				printf("\tUser '<b>%s</b>' scheduled a transfer from <b>https://%s/%s/WebTools/</b> on <b>%s</b>\n", $temp[2], $SERVER, $temp[1], scalar(localtime($temp[0]))  );
				printf("\t<br>\n");
				printf("\tDue to the complex nature of FTU2, only <b>1</b> transfer for https://%s/%s can be executed at a time.\n", $SERVER, $temp[1]);
				printf("\t<br>\n");
				printf("\t<br>\n");
				if ($MinionLines)
				{
					printf("\tThere %s $MinionLines file%s in that request.\n", ($MinionLines==1) ? "is" : "are", ($MinionLines==1) ? "" : "s" );
				}
				else
				{
					printf("\tI could not determine how many files were scheduled for transfer. Perhaps that file was already processed? You should refresh this page.\n");
				}
				printf("\t<br>\n");
				printf("\tNo additional information can be obtained about that transfer. Please refer to your <a href=\"./FTU_log/\" target=\"_blank\">logs</a>.\n");
				printf("\t<br>\n");
				printf("\t<br>\n");
				printf("Other website requests besides yours: %d. %s\n", $NumberOfMinions-1, (($NumberOfMinions-1) != 0) ? "This may also affect how long your transfer takes." : "" );
				printf("\t<br>\n");
				printf("\t<br>\n");
				printf("\t<b>Please try again later.</b>\n");
				printf("</div>\n\n\n");

				ViewCurrentLog();
				ViewAllLogs();
				Bottom();
				exit(0);
			}
		}
	}
	else
	{
		printf("<b class=\"error\">Failed to sneek into the Overlord's chambers: $! ($^E)</b>\n");
		Bottom();
		exit(0);
	}


	if ($NumberOfMinions == 1)
	{
		$IsAre="is";
	}
	else
	{
		$IsAre="are";
	}



	if ($NumberOfMinions)
	{
		printf("<span style=\"display:table; border:solid 2px #000; padding:3px; background-color:#DDF; color:#000;\">");
		printf("There %s %d other website%s ahead of you that %s scheduled for processing.", $IsAre, $NumberOfMinions, ($NumberOfMinions == 1) ? "" : "s", $IsAre);
		printf("</span> <br/>\n\n\n");
	}
} # ENDS CheckOverlord()










################################################################################################################################
################################################################################################################################
#
# M A I N     (more or less)
#
################################################################################################################################
################################################################################################################################


open(DEBUG, ">>$DebugFile") or die "DEBUG ($DebugFile): $!";



################################################################
# HTML junk.  Will always print out.
################################################################

printf("\n" x 100);
printf("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 1.1 Transitional//EN\">\n"); 		# This line is needed for IE 7
printf("<html lang=\"en\">\n");
ShowCriticalVariables();
printf("<head>
<meta name='robots' content='noindex,nofollow' />\n");
printf("<META NAME=\"robots\"		CONTENT=\"NoArchive, NoIndex\">\n");
printf("<META http-equiv=\"Pragma\"	CONTENT=\"no-cache\">\n\n");
printf("<title>File Transfer Utility for %s</title>\n\n", $BaseHREF);

printf("<link href=\"/FTU/includes/global-stylesheet.css\"  rel=\"stylesheet\" type=\"text/css\" />\n");
printf("<link href=\"/FTU/includes/subpage-stylesheet.css\" rel=\"stylesheet\" type=\"text/css\" />\n\n");

printf("<style>\n");
printf("a         {text-decoration:none;}\n");
printf("a.visited {color: #AAA; }\n");
printf("pre       {background-color: #7aA; padding:3px;}\n");
printf(".error    {background-color: #FfA; padding:1px; color: #F00;}\n");
printf("</style>\n\n");

printf("<script type=\"text/javascript\" language=\"JavaScript\" src=\"/javascript/prototype-1.6.0.2.js\"></script>\n\n");

printf("<script type=\"text/javascript\" language=\"JavaScript\">\n");
printf("var TotalFilesSelectedForTransfer=0;\n\n");

#printf("<script type=\"text/javascript\" language=\"JavaScript\">\n");
printf("function serverInfo(serverStatus)\n");
printf("{\n");
printf("	alert(serverStatus);\n");
printf("}\n\n");

printf("function ajaxFunction(thisElement)\n");
printf("{\n");
printf("	var xmlHttp;\n");

printf("	try\n");
printf("	{\n");
printf("		// Firefox, Opera 8+, Safari\n");
printf("		xmlHttp = new XMLHttpRequest();\n");
printf("	}\n");
printf("	catch (e)\n");
printf("	{\n");
printf("		try\n");
printf("		{\n");
printf("			// Internet Explorer 6+\n");
printf("			xmlHttp = new ActiveXObject(\"Msxml2.XMLHTTP\");\n");
printf("		}\n");
printf("		catch (e)\n");
printf("		{\n");
printf("			try\n");
printf("			{\n");
printf("				// Internet Explorer 5.5\n");
printf("				xmlHttp = new ActiveXObject(\"Microsoft.XMLHTTP\");\n");
printf("			}\n");
printf("			catch (e)\n");
printf("			{\n");
printf("				alert(\"Your browser does not support AJAX!\");\n");
printf("				return false;\n");
printf("			}\n");
printf("		}\n");
printf("	}\n\n");
#
#printf("	document.getElementById(\"ReadyToGo\").innerHTML=xmlHttp.responseText;\n");
#
printf("//	alert(\"thisElement is \" + thisElement + \"=\" + document.getElementById(thisElement).checked );\n\n");
printf("	xmlHttp.onreadystatechange=function()\n");
printf("	{\n");
printf("		// 0 request not initialized\n");
printf("		// 1 request set up\n");
printf("		// 2 request sent\n");
printf("		// 3 request in progress\n");
printf("		// 4 request is complete\n\n");
printf("		if ( (xmlHttp.readyState == 4) || (xmlHttp.readyState == \"complete\") )\n");
printf("		{\n");
printf("	//		document.getElementById(\"ReadyToGo\").innerHTML=xmlHttp.status;\n");
printf("			document.getElementById(\"ReadyToGo\").innerHTML=xmlHttp.responseText;\n");
printf("	//		document.getElementById(\"AJAXmessages\").innerHTML=xmlHttp.responseText;\n");
printf("	//		document.getElementById(\"AJAXmessages\").innerHTML=xmlHttp.status;\n");
printf("	//		serverInfo(xmlHttp.status);\n");
printf("		}\n");
printf("	}\n\n");
#
# XMLHTTP.open may throw a "Permission denied to call method XMLHttpRequest.open" on Develop1 during testing.  Change URL from HTTPS to HTTP.
#
printf("//	document.getElementById(\"SubmitButton\").disabled=true;\n");
printf("	try {\n");
printf("		xmlHttp.open(\"POST\", \"https://%s%sftu2ajax.pl\", false);\n", $SERVER, $WebTools);
printf("	} catch (e) {\n");
printf("		alert(\"FATAL ERROR: Could not contact https://%s%sftu2ajax.pl\"); return false; }\n", $SERVER, $WebTools);
printf("	xmlHttp.send(document.getElementById(thisElement).id + \"=\" + document.getElementById(thisElement).checked );\n\n");
printf("//	document.getElementById(\"SubmitButton\").disabled=false;\n");
printf("	return true;\n");
printf("}\n\n");
#printf("</script>\n");


printf("function HideShowTable(thisElement)\n");
printf("{\n");
	printf("\tif (document.getElementById(thisElement).style.display != \"none\")\n");
	printf("\t{\n");
	printf("\t\tdocument.getElementById(thisElement).style.display=\"none\";\n");
	printf("\t}\n");
	printf("\telse\n");
	printf("\t{\n");
	printf("\t\tdocument.getElementById(thisElement).style.display=\"table\";\n");
	printf("\t}\n");
printf("}\n\n\n");

printf("function checkTotalFilesSelected()\n");
printf("{\n");
	printf("\tdocument.getElementById(\"SubmitButton\").value=\"Transfer \" + TotalFilesSelectedForTransfer + \" files\";\n\n");
	printf("\tif (TotalFilesSelectedForTransfer > %d)\n", $MaximumNumberFilesToTransfer);
	printf("\t{\n");
		printf("\t\tdocument.getElementById(\"SubmitButton\").disabled=true;\n");
		printf("\t\tdocument.getElementById(\"SubmitButton\").value=\"Too many files to transfer.  De-select \" + (TotalFilesSelectedForTransfer-%d) + \" files\";\n\n", $MaximumNumberFilesToTransfer);
		printf("\t\talert(\"Too many files to transfer.  De-select \" + (TotalFilesSelectedForTransfer-%d) + \" files\");\n\n", $MaximumNumberFilesToTransfer);
	printf("\t}\n");
	printf("\telse if (TotalFilesSelectedForTransfer == 0)\n", $MaximumNumberFilesToTransfer);
	printf("\t{\n");
		printf("\t\tdocument.getElementById(\"SubmitButton\").disabled=true;\n");
	printf("\t}\n");
	printf("\telse\n");
	printf("\t{\n");
		printf("\t\tdocument.getElementById(\"SubmitButton\").disabled=false;\n");
	printf("\t}\n");
printf("}\n\n\n");

printf("function toggleColor(chkbox, chkboxLabel)\n");
printf("{\n");
	printf("\tif (document.getElementById(chkbox).checked)\n");
	printf("\t{\n");
		printf("\t\tdocument.getElementById(chkboxLabel).style.backgroundColor=\"#cFc\";\n");
	printf("\t}\n");
	printf("\telse\n");
	printf("\t{\n");
		printf("\t\tdocument.getElementById(chkboxLabel).style.backgroundColor=\"#FfF\";\n");
	printf("\t}\n\n");
printf("}\n\n\n");


printf("function toggleSelectAll (theElement)\n");
printf("{\n");
	printf("\tvar checked;\n");
	printf("\tvar index=0;\n");
	printf("\tvar theForm = theElement.form\n\n");
	printf("\tif (theElement.checked == true)\n");
	printf("\t{\n");
		printf("\t\tTotalFilesSelectedForTransfer++;\n");
		printf("\t\tdocument.getElementById(\"SelectAllWord\").innerHTML=\"Unselect every file from %s.\"\n", $BaseHREF);
		printf("\t\tchecked = true;\n\n");
		printf("\t\tfor(index = 0; index < theForm.length; index++)\n");
		printf("\t\t{\n");
		#	printf("\t\t\talert(\"theForm[\" + index + \"/\" + theForm.length + \"].id = \" + document.getElementById('FTU')[index].name);\n");
			printf("\t\t\ttheForm[index].checked = theElement.checked;\n");
		#	printf("\t\t\tdocument.getElementById(theForm.id).style.backgroundColor=\"#ccccFF\";\n");
			printf("\t\t\tdocument.getElementById('FTU')[index].style.backgroundColor=\"#ccccFF\";\n");
			printf("\t\t\tTotalFilesSelectedForTransfer++;\n");
		printf("\t\t}\n");
		printf("\t\tTotalFilesSelectedForTransfer-=4;\n");
	printf("\t}\n");
	printf("\telse\n");
	printf("\t{\n");
		printf("\t\tTotalFilesSelectedForTransfer=0;\n");
		printf("\t\tdocument.getElementById(\"SelectAllWord\").innerHTML=\"Select every file from %s for transfer.\"\n", $BaseHREF);
		printf("\t\tchecked = false;\n\n");
		printf("\t\tfor(index = 0; index < theForm.length; index++)\n");
		printf("\t\t{\n");
		#	printf("\t\t\talert(\"theForm[\" + index + \"/\" + theForm.length + \"].id = \" + theForm[index].ul.childNodes.length);\n");
			printf("\t\t\ttheForm[index].checked = theElement.checked;\n");
			printf("\t\t\tdocument.getElementById(theForm.id).style.backgroundColor=\"#FFffFF\";\n");
			printf("\t\t\tTotalFilesSelectedForTransfer=0;\n");
		printf("\t\t}\n");
	printf("\t}\n\n");
#	printf("\tcheckTotalFilesSelected();\n");
printf("}\n\n\n");


printf("function ClearAll(theElement)\n");
printf("{\n");
	printf("\tvar index=0;\n");
	printf("\tTotalFilesSelectedForTransfer=0;\n");
		printf("\t\tdocument.getElementById(theElement.form.id).style.backgroundColor=\"#FFffFF\";\n");
		printf("\t\tfor(index = 0; index < theElement.form.length; index++)\n");
		printf("\t\t{\n");

		printf("\t\t}\n");
#	printf("\tdocument.getElementById('SubmitButton').value=\"Transfer \" + TotalFilesSelectedForTransfer + \" files\";\n");
printf("}\n\n\n");


printf("function toggleFolder(image,list)\n");
printf("{\n");
	printf("\tvar listElementStyle = document.getElementById(list).style;\n");
	printf("\tif (listElementStyle.display==\"none\")\n");
	printf("\t{\n");
		printf("\t\tlistElementStyle.display=\"block\";\n");
		printf("\t\tdocument.getElementById(image).src=\"$FolderOpen\";\n");
		printf("\t\tdocument.getElementById(image).alt=\"Close list\";\n\n");

		printf("\t\tdocument.getElementById(\"ReadyToGo\").innerHTML=\"\";\n");
		printf("\t\tdocument.getElementById(\"ReadyToGo\").style.backgroundColor=\"#FFffFF\";\n");
		printf("\t\tdocument.getElementById(\"ReadyToGo\").display=\"none\";\n");
	printf("\t}\n");
	printf("\telse\n");
	printf("\t{\n");
		printf("\t\tlistElementStyle.display=\"none\";\n");
		printf("\t\tdocument.getElementById(image).src=\"$FolderClse\";\n");
		printf("\t\tdocument.getElementById(image).alt=\"Open list\";\n");
	printf("\t}\n");
printf("}\n\n\n");


# view-source:http://mail-archives.apache.org/mod_mbox/httpd-users/200711.mbox

printf("function LoadBrowser()\n");
printf("{\n");
	if    ($Method =~ /^POST$/)
	{
		printf("\tdocument.getElementById(\"ReadyToGo\").style.backgroundColor=\"#FFAA00\";\n");
		printf("\tdocument.getElementById(\"ReadyToGo\").innerHTML=\"Finished: %s\";\n", scalar(localtime()) );
	}
printf("}\n\n\n");



printf("// Thanks, Mark Rose!\n");

# This affects the top-level "Select All" checkbox

printf("document.observe('dom:loaded', function(e)\n");
printf("{\n");
	printf("\t\$('SelectAllCheckbox').observe('click', function(e)\n");
	printf("\t{\n");
		printf("\t\t//alert('checked = ' + this.checked);\n");
		printf("\t\t//alert('value = ' + this.value);\n");
		printf("\t\t//alert('name = ' + this.name);\n");
		printf("\t\tvar ischecked = false;\n");
		printf("\t\tif(this.checked)\n");
		printf("\t\t{\n");
			printf("\t\t\tischecked = true;\n");
		printf("\t\t}\n");
		printf("\t\tvar someNodeList = \$('FTU').getElementsByTagName('input');\n");
		printf("\t\tvar nodes = \$A(someNodeList);\n");
		printf("\t\tnodes.each(function(node){\n");
			printf("\t\t\tif(node.type == \"checkbox\" && node.value != \"SelectAllCheckbox\")\n");
			printf("\t\t\t{\n");
				printf("\t\t\t\t//alert(node.nodeName + ':' + node.type + ':' + node.value);\n");
				printf("\t\t\t\tnode.checked = ischecked;\n");
	printf("\t\t\t\tdocument.getElementById(\"SubmitButton\").disabled=false;\n");
				printf("\t\t\tajaxFunction(node.id);\n");
	printf("\t\t\t\tdocument.getElementById(\"SubmitButton\").disabled=false;\n");
	#			printf("\t\t\ttoggleColor(node.id, node.id + '_Label');\n");
			printf("\t\t\t}\n");
		printf("\t\t});\n");
	printf("\t});\n");
printf("});\n\n\n");


# This affects the sub-directory checkbox

printf("function selectTree(ulID, e)\n");
printf("{\n");
	printf("\tvar ischecked = false;\n");
	printf("\tif(e.checked)\n");
	printf("\t{\n");
		printf("\t\tischecked = true;\n");
	printf("\t}\n");
	printf("\tvar someNodeList = \$(ulID).getElementsByTagName('input');\n");
	printf("\tvar nodes = \$A(someNodeList);\n");
	printf("\tnodes.each(function(node){\n");
		printf("\t\tif(node.type == \"checkbox\")\n");
		printf("\t\t{\n");
			printf("\t\t\t//alert(node.nodeName + ':' + node.type + ':' + node.value);\n"); 	# Input: Checkbox: on
			printf("\t\t\t//alert(node.id + ' = ' + node.value );\n");
			printf("\t\t\tnode.checked = ischecked;\n");
			printf("\t\t\tajaxFunction(node.id);\n");
	#		printf("\t\t\ttoggleColor(node.id, node.id + '_Label');\n");

	#		printf("\t\t\tdocument.getElementById(\"AJAXmessages\").innerHTML=\"checked \" + node.id;\n");

		printf("\t\t}\n");
	printf("\t});\n");
printf("}\n\n");

printf("</script>\n");

printf("</head>\n\n\n");



printf("<body id=\"archives\" onload=\"javascript:LoadBrowser();\" style=\"background-color:#FfF; font-family:monospace; font-size:10pt;\">\n");
printf("<!-- code modified $Modified -->\n\n");


if (! open(TEMP, ">>$AJAXFile") )
{
	printf("<b>Cannot create tmp AJAXfile: $!</b>\n");
}
close(TEMP);



if (! -f "$FTU2AJAX")
{
	printf("<br/>");
	printf("<div style=\"border: solid 1px #000; padding:2px; background-color:#FFdddd;\">\n");
	printf("<b>FATAL: No AJAX handler ($FTU2AJAX)</b> I cannot proceed without this file! <br/>\n");
	printf("Please contact the system administrator at <a href=\"mailto:webhelp\@temple.edu?Subject=Missing AJAX for $BaseHREF WebTools\">webhelp\@temple.edu</a> (Subject: Missing AJAX for $BaseHREF WebTools) to get this corrected.\n<p>\n");
	printf("</div>\n");
	exit(1);
}



if ($0 !~ /(\/|\\)WebTools(\/|\\)/i)
{
	printf("<div style=\"border: solid 1px #000; padding:2px; background-color:#FFdddd;\">\n");
	printf("<h1>FTU2 is in the wrong location.</h1>\n");
	printf("It needs to be located inside of a WebTools directory.\n<p>\n");
	printf("Current location: $URI\n");
#	ShowCriticalVariables();
	printf("</div>\n");
	exit 1;
}



my @tempURL=split('/', $URI);

if ( (! defined $Username) || ($Username =~ /^\s*$/) || ($Username =~ /^I(USR|WAM)_/i ) )
{
	# IUSR has no authority to manipulate NTFS permissions

	printf("<h2 style=\"color:#FF0000; background-color:#FFdddd; padding:3px;\">This WebTools directory is not password protected.</h2>");
	printf("If you recently created the WebTools directory, please wait 3-6 hours [until %s] for the password protection to be auto-enabled. <br/>\n", scalar( localtime($CurrentTime+3600)) );
	printf("Or contact the system administrator at <a href=\"mailto:webhelp\@temple.edu?Subject=Password protect $BaseHREF WebTools\">webhelp\@temple.edu</a> (Subject: Password protect $BaseHREF WebTools) to get this corrected.\n<p>\n");

	Bottom();
	exit(1);
}




# To any webmaster reading this (and you shouldnt be reading this)
# Dont bother trying to hack this section -- there are levels of protection in place

$IsVIP=0;

if ($OperatingSystem =~ /^Windows$/) 
{
	if ( open(VIP, "S:/D/Logs/IIS/Accounts/current_${COMPUTERNAME}_users_groups.csv") )
	{
	#	printf("VIPs opened."); 						# debug
		while(<VIP>)
		{
			if    (/^Administrators,Administrators/) 			# Develop's sysadmins
			{
				my @fields = split(/,/, $_);
	
				for my $index (0 .. $#fields)
				{
				#	printf(      "[%s] ", $fields[$index] ); 	# debug
					printf(DEBUG "[%s] ", $fields[$index] ); 	# debug
	
					if ( ($fields[$index] cmp ${Username} ) == 0)
					{
						$IsVIP=1;
						last;
					}

					$fields[$index] = lc($fields[$index]);

					if ( ($fields[$index] cmp ${Username} ) == 0)
					{
						$IsVIP=1;
						last;
					}
				}
				printf(DEBUG "\n");
			}
			elsif (/^OWS_2955744346_admin/) 				# Other Computer Services people
			{
				my @fields = split(/,/, $_);
	
				for my $index (0 .. $#fields)
				{
				#	printf(      "{%s} ", $fields[$index] ); 	# debug
					printf(DEBUG "{%s} ", $fields[$index] ); 	# debug
	
					if ( ($fields[$index] cmp ${Username} ) == 0)
					{
						printf(DEBUG "\tMarking $Username as 2955744346 VIP [1]\n");
						$IsVIP=1;
						last;
					}

					if ( ($fields[$index] cmp "TU\${Username}" ) == 0)
					{
						printf(DEBUG "\tMarking $Username as 2955744346 VIP [2]\n");
						$IsVIP=1;
						last;
					}

					$fields[$index] = lc($fields[$index]);

					if ( ($fields[$index] cmp ${Username} ) == 0)
					{
						printf(DEBUG "\tMarking $Username as 2955744346 VIP [3]\n");
						$IsVIP=1;
						last;
					}

					if ( ($fields[$index] cmp "TU\${Username}" ) == 0)
					{
						printf(DEBUG "\tMarking $Username as 2955744346 VIP [4]\n");
						$IsVIP=1;
						last;
					}
				}
				printf(DEBUG "\n");
			}
			elsif (/^OWS_4163918017_admin/) 				# Other Computer Services people
			{
				my @fields = split(/,/, $_);
	
				for my $index (0 .. $#fields)
				{
				#	printf(      "{%s} ", $fields[$index] ); 	# debug
					printf(DEBUG "{%s} ", $fields[$index] ); 	# debug
	
					if ( ($fields[$index] cmp ${Username} ) == 0)
					{
						$IsVIP=1;
						last;
					}

					$fields[$index] = lc($fields[$index]);

					if ( ($fields[$index] cmp ${Username} ) == 0)
					{
						$IsVIP=1;
						last;
					}
				}
				printf(DEBUG "\n");
			}
		}
	}


	$IsVIP=1 if ($Username =~ /sbirl/);
	$IsVIP=1 if ($Username =~ /su\-/);

	#else
	#{
	#	printf("Could not open VIPs: $! ($^E)\n");
	#}
}
else
{
	if ( open(VIP, "/etc/group") )
	{
		while(<VIP>)
		{
			if ( /^wheel:.:\d+:(.*)/ )
			{
				my @groups = split(/,/, $1);
				for my $index (0 .. $#groups)
				{
					if ( ($groups[$index] cmp ${Username} ) == 0)
					{
						$IsVIP=1;
						last;
					}
				}
			}
		}
		close(VIP);
	}
}

#############################
#
#   B A N N E R
#
#############################

printf("<div id=\"block001\" style=\"background-color:#008282;\">\n");
printf("\t<div id=\"tuLogo\"><a href=\"http://www.temple.edu\" target=\"_blank\"><img src=\"/ftu_images/logo.gif\" alt=\"Temple University\" style=\"border:0px solid #008282; width:312px; height:40px;\" /></a></div>\n");
printf("\t<div id=\"utilityNav\">\n");
printf("\t<ul style=\"font-size: 1.4em; color:#666666; margin-top:25px; font-weight:lighter;\">\n");
#printf("\t\t<li><a href=\"$BaseHREF\"><img src=\"/images/home-button.gif\" alt=\"Home\" width=\"37\" height=\"34\" border=\"0\" align=\"absmiddle\" /></a></li>\n");
printf("\t\t<li><a href=\"https://computerservices.temple.edu/file-transfer-utility\" target=\"_blank\">FTU Help</a></li>\n");
printf("\t\t\t<li>|</li>\n");
printf("\t\t<li><a href=\"https://computerservices.temple.edu/\" target=\"_blank\">Computer Services</a></li>\n");
printf("\t\t\t<li>|</li>\n");
printf("\t\t<li><a href=\"https://computerservices.temple.edu/web-hosting-www\" target=\"_blank\">WebHelp</a></li>\n");
printf("\t\t\t<li>|</li>\n");
printf("\t\t<li><a href=\"https://tuhelp.temple.edu\" target=\"_blank\">HelpDesk</a></li>\n");
printf("\t\t\t<li>|</li>\n");
printf("\t\t<li><a href=\"http://www.temple.edu\" target=\"_blank\">Temple University Home</a></li>\n");
printf("\t</ul>\n");
printf("\t</div>\n");
printf("</div>\n\n");

#printf("<div>\n");
#printf("\t<a href=\"http://www.temple.edu/\" target=\"_blank\"><img src=\"/images/temple_2c.gif\" title=\"Temple University.\" border=\"0\"></a>\n");
#printf("</div>\n");
#printf("<br><br>\n");
#printf("\n\n\n\n");


printf("<div id=\"HEADER\" style=\"color:#000; background-color:#FFF; text-align:left; padding:2px; border:0px solid #888;\">\n");
printf("\t<i style=\"font-weight:bold; font-family:sans-serif;\"><span title=\"FTU: File Transfer Utility\">FTU</span> for \n");
printf("\t<a href=\"http://www.temple.edu/\" style=\"color:#000;\" target=\"_blank\" title=\"http://www.temple.edu/\"><u>http://www.temple.edu</u></a>");
	for my $index (0 .. ($#tempURL)-2)
	{
		printf("<a href=\"http://www.temple.edu");

		for my $index2 (0 .. $index)
		{
			printf("%s/", $tempURL[$index2]);
		}

		printf("\" style=\"color:#000;\" target=\"_blank\"><u>%s</u></a>/", $tempURL[$index] );
	}
printf("\t</i>\n");

printf("\t<span style=\"font-size:8pt; color:#888; cursor:help;\" ");
if ($WebTools =~ /^${Parent}$/i)
{
	printf("title=\"This means you are at the very top of your development website.\">This is the root-level FTU.");
}
else
{
	# No Target=_blank here
	printf(">This is a sub-level FTU. <a href=\"https://%s%sftu2.pl\"><u>Click here for the root-level FTU</u></a>.", $SERVER, $Parent);
}
printf("</span>\n");

printf("\t<span style=\"display:inline; position:absolute; right:60px; font-size:8pt;\" title=\"I believe this to be you.\">Logged in as <b>%s</b>%s.</span>\n", $Username, ($IsVIP) ? " *" : ""  );



printf("\t<br>\n");
printf("\t<b style=\"cursor:help;\" id=\"SubDescription\" title=\"Overview of the development website.\">&nbsp;</b>\n");






printf("\t<div style=\"font-size:8pt;\">\n");
if ( (! defined $QUERY) || ($QUERY =~ /^\s*$/) )
{
	printf("\t<p>\n");

	# No Target=_blank here
	printf("\t<a href=\"https://%s%sftu2.pl?MasterFTU\"       style=\"color:#888;\" title=\"Master FTU 2\"><u>Click here to list all FTUs underneath https://%s%s</a></u>.\n", $SERVER, $WebTools, $SERVER, $WebTools);
	printf("\t<br>\n");
# removed 2014-Nov-10
#	printf("\t<a href=\"https://%s%sftu2.pl?root-files-only\" style=\"color:#888;\" title=\"If clicked, no directories will be shown.\"><u>Click here to access ONLY the root-level files</a></u>.\n", $SERVER, $WebTools);
#	printf("\t<br>\n");

	if (-f "$FTU2Blk")
	{
		printf("\t<a href=\"https://%s%sftu2blacklist.pl\" target=\"_blank\" style=\"font-size:8pt; color:#888;\" title=\"Useful if you have a LARGE website.\"><u>Click here for the FTU Blacklist</u></a> ", $SERVER, $WebTools );
	}
	else
	{
		printf("\t<a href=\"mailto:webhelp\@temple.edu\" target=\"_blank\" style=\"font-size:8pt; color:#888;\" title=\"Not manditory for using FTU2, but useful to have.\"><u>FTU Blacklist missing.</u></a> ", $SERVER, $Parent );
	}


	if ( open(BLACKLIST, "$RootLevelDevDirectory/WebTools/FTU_blacklist.txt") )
	{
		while(<BLACKLIST>)
		{
			next if (/^\s*#/);
			next if (/^\s*$/);

			chomp;
			printf(DEBUG "Blacklist: $_\n"); 							# debug
			$UserBlacklist{"$_"}=1;
		}
		close(BLACKLIST);

		printf("<i>Blacklist patterns loaded: %d</i>\n", scalar(keys %UserBlacklist)  );
	}
	else
	{
		printf("<b>Could not read blacklist.</b>\n" );
		printf(DEBUG "Could not read blacklist: $! ($^E)\n");
	}


#	printf("\t<br>\n");
}
elsif ( (defined $QUERY) && ($QUERY =~ /^root-(files-only|level-files)$/i ) )
{
	printf("\t<a href=\"https://%s%sftu2.pl\" style=\"color:#888;\"><u>Click here list all files and directories underneath https://%s%s</a></u>.\n", $SERVER, $Parent, $SERVER, $Parent);
}
printf("\t<br>\n");



	ViewAllLogs();

printf("\t</div>\n");
printf("</div>\n\n\n");





#TestContactInfo(); 			# debug

#PrintEnv(); 				# heavy debugging

ShowCriticalVariables();





################################################################
# Conditional code  GET -vs- POST
################################################################


if    ($Method =~ /^POST$/)
{
	my $ContentLength=$ENV{"CONTENT_LENGTH"}; 							# CONTENT_LENGTH is used with POST
	my $POSTdata;
	my $TotalSuccesses=0;
	my $TotalFailures=0;
	my $TotalSizeTransfer=0;
	my @FailedTransfers;
	my $bytes_read;

	push(@directories_to_search, $RootLevelPubDirectory);

	$|=1;

	if ($ContentLength < 0)
	{
		printf("!!!!!");
		Bottom();
		exit 1;
	}




	CheckOverlord(); 	# status update for user.




	if ( open(OVERLORD, ">$OverlordFile") )
	{
		if ( open(AJAXFILE, "$AJAXFile") )
		{
			my %Hash;

			while(<AJAXFILE>)
			{
				chomp;

				my ($key, $value) = split(/=/);

				$Hash{$key}=$value;
			}
			close(AJAXFILE);


			if ($Username =~ /^(DEVELOP(DR)?\\sbirl|sbirl(-local)?)$/)
			{
				printf("<u onclick=\"HideShowTable('AJAX2Overlord')\">AJAX to Overlord</u> <br/>\n");
				printf("<pre id=\"AJAX2Overlord\" style=\"display:none\">\n");
			}

			foreach my $key (sort keys %Hash)
			{
				printf(OVERLORD "%s\n", $key)   if ($Hash{$key} =~ /^(on|true)$/i );

				printf("%s=%s\n", $key, $Hash{$key} ) if ($Username =~ /^(DEVELOP(DR)?\\sbirl|sbirl(-local)?)$/);
			}

			if ($Username =~ /^(DEVELOP(DR)?\\sbirl|sbirl(-local)?)$/)
			{
					printf("</pre> \n\n");
			}

		}
		else
		{
			printf("<b style=\"color:#F00; font-size:16pt;\">FAILED AJAX open('$AJAXFile'): $! ($^E)\n");
			exit (1);
		}

#		foreach my $junk ( split(/&/, $POSTdata) )
#		{
#			$junk =  (split(/=/, $junk))[0];
#			$junk =~ s/\+/ /g;
#			$junk =~ s/%([\da-fA-F]{2})/chr(hex($1))/eg; 					# convert hexidecimal to ASCII
#
#			printf(OVERLORD "%s\n", $junk );
#		}
		close(OVERLORD);

		printf("<div style=\"border:solid 1px #000; background-color:#AFA; padding:5px;\">");
		printf("<h2>Your request has been submitted.</h2> \n");
		printf("\tIt will be handled on a first-come, first-served basis. <br>\n");
		printf("\tThe request can be tracked at <a href=\"$LogURL\" target=\"_blank\">$LogURL</a> <br>\n");
		printf("</div>\n");
	}
	else
	{
		printf("<b>FAILED open('$OverlordFile'): $! ($^E)\n");
	}




	ViewCurrentLog();
	ViewAllLogs();
	printf("</div>\n");


	if ($Username =~ /^((DEVELOP(DR)?|TU|TEMPLE)\\(sbirl|vmehta02)|(sbirl|vmehta02)(-local)?)$/)
	{
		$EpochFinish=time;
		printf("Load: %d seconds.<br><br>\n", $EpochFinish-$EpochStart );
	}

	Bottom();
	exit 0;
}
elsif ($Method =~ /^GET$/)
{
	push(@directories_to_search, $RootLevelDevDirectory);

	printf("<!-- GET -->\n\n");


	if (defined $QUERY)
	{

	##############
	#            #
	# Master FTU #
	#            #
	##############

		if ($QUERY =~ /^MasterFTU$/i)
		{
			printf("\n<p>\n\n<div style=\"padding: 2px;\">\n");
		#	printf("\t<div style=\"border:solid 1px #000; padding:5px; width:600px;\">\n");
		#	printf("\t<b><a href=\"https://www.temple.edu/webform\" target=\"_blank\">Website Administration From</a></b>\n<br>\n");
		#	printf("\t<b><a href=\"https://www.temple.edu/webhelp/web_resources/policies.htm\">Temple University Web Policies</a></b>\n<br>\n");
		#	printf("\t</div>\n");
			printf("<h3>All WebTools directories underneath $BaseHREF</h3>\n");
			printf("<div style=\"border:solid 1px #BbB; color:#999; padding:5px; width:600px;\">As of 2008-Feb, When webmasters create a sub-folder called 'WebTools' anywhere in the website, they will have the ability to copy FTU2 into that sub-folder from this page.  Permissions are adjusted every 3 hours (at noon).</div>\n<br>\n");
			printf("<b>NOTE:</b> Please be aware that each WebTools directory has it own set of permissions.  You may be required to have proper authentication to access it.\n<p>\n");
			printf("<ol>\n");
			find(\&FindOtherFTU, @directories_to_search);
			printf("</ol>\n");
			printf("</div>\n");

			Bottom();
			exit 0;
		}


	########
	#      #
	# copy #
	#      #
	########
		if ($QUERY =~ /^copy=(.*)$/i)
		{
			my $Destination=$1;
			my $DestURL=$1;

			$DestURL =~ s/${RootLevelDevDirectory}/${BaseHREF}/;


			printf("\n<p>\n\n<div style=\"padding: 2px;\">\n");
			if    ($Destination !~ /^$RootLevelDevDirectory/)
			{
				printf("<h2 class=\"error\">Invalid path (%s)</h2>\n", $Destination);
			}
			elsif (! -d "$Destination")
			{
				printf("<h2 class=\"error\">%s is not a directory</h2>\n", $Destination);
			}
			elsif ($Destination !~ /WebTools(\/)?$/i)
			{
				printf("<h2 class=\"error\">%s is not a WebTools directory</h2>\n", $Destination);
			}
			elsif ( (-f "$Destination/ftu2.pl") && ($IsVIP == 0) )
			{
				printf("<h2 class=\"error\" style=\"width:600px;\">FTU2 already exists</h2>\n");
				printf("Please email <a href=\"mailto:webhelp\@temple.edu?Subject=FTU2\">webhelp\@temple.edu</a> (Subject: FTU2) if you think this FTU needs to be updated.\n");
			}
			else
			{
				if ( copy("$0", "$Destination/ftu2.pl") )
				{
					printf("Copy of FTU2 was successful. <a href=\"$DestURL/ftu2.pl\" target=\"_blank\">Use $DestURL/ftu2.pl now</a>\n");
				}
				else
				{
					printf("<b class=\"error\">Copy of FTU2 FAILED:</b> $! ($^E).\n");
				}

				if (! copy("$FTU2AJAX", "$Destination/ftu2ajax.pl") )
				{
					printf("<b class=\"error\">Copy of FTU2AJAX FAILED:</b> $! ($^E).\n");
				}

				copy("$FTU2Blk", "$Destination/ftu2blacklist.pl");
			}
			printf("</div>\n");

			Bottom();
			exit 0;
		}
		# ENDS if ($QUERY =~ /^copy=(.*)$/i)


	# From line 800

	########
	#      #
	# List #
	#      #
	########
		if ($QUERY =~ /^list/i)
		{
			printf("<pre>");
			printf("# For SERVER ADMINS ONLY!\n");
			printf("# Used to PROPERLY update an entire site without the need to click on boxes, drag-n-drop, etc.\n");
			printf("# File will be placed here: $TEMP/%s#%s#%s.txt\n", time, $OverlordWebTools, $OverlordUsername );
			printf("# Copy that file to $OverlordDirectory\n");
			printf("#\n");
			printf("# The file should already be populated and ready to go, but if not, here's the output:\n");
			printf("#\n");

			$AJAXFile = sprintf("$TEMP/%s#%s#%s.txt", time, $OverlordWebTools, $OverlordUsername );
			find(\&SearchDevelop, @directories_to_search);
			printf("</pre>");

			Bottom();
			exit 0;
		}

	####################
	#                  #
	# Force Update Now #
	#                  #
	####################
		if ($QUERY =~ /^Force/i)
		{
			printf("<pre class=\"error\">");
			printf("<br/>\n");
			if ($IsVIP)
			{
				printf("For <b>WEBSERVER ADMINS ONLY!</b> Normal end-user use is <b>PROHIBITED</b> as it will crash the server!\n");
				printf("Used to PROPERLY update an entire site <b>IMMEDIATELY</b> without the need to click on boxes, drag-n-drop, etc. <br/><br/>\n");
				printf("The website is already being updated in its entirety. <b>It's too late to back out of this option now!</b>\n");
				printf("<br/>\n");

				$AJAXFile = sprintf("$OverlordDirectory/%s#%s#%s.txt", time, $OverlordWebTools, $OverlordUsername );
				find(\&SearchDevelop, @directories_to_search);
			}
			else
			{
				printf("<h2>Unauthorized</h2>\n");
			}
			printf("</pre>");

			Bottom();
			exit 0;
		}
	} # ENDS if (defined $QUERY)



	CheckOverlord(); 	# status update for user.


# Leave this inside of the GET method!

	if (-f $AJAXFile && (! unlink($AJAXFile) ))
	{
		printf("<div style=\"border:solid 1px #000; background-color:#FAA; padding:5px;\">");
		printf("Failed to unlink($AJAXFile): $! ($^E) <br/>\n");
		printf("Perhaps the previous transfer has not yet been sent to the Overlord for processing? <br/> \n");
		printf("Please wait, then refresh this page. <br/> \n");
		printf("This file needs to be removed before FTU2 can be ran again.\n");
		printf("If this problem persists, please <a href=\"mailto:webhelp\@temple.edu\">email webhelp\@temple.edu</a> (Subject: Locked AJAX) the above error <br/>");
		printf("</div>\n");
		exit(1);
	}




	printf("<b id=\"ReadyToGo\">Loading ... please wait.</b>\n");

	printf("<form method=\"POST\" enctype=\"multipart/form-data\" action=\"%s\" name=\"FTU\" id=\"FTU\">\n", $URI );


	# Select All box
#	printf("<input type=\"checkbox\" name=\"%s\" id=\"SelectAllCheckbox\" onClick=\"ajaxFunction(\"%s\");\" DISABLED> <span id=\"SelectAllWord\">Select every file from %s for transfer</span>", $RootLevelDevDirectory, $RootLevelDevDirectory, $BaseHREF);
#	printf("<br><br>\n\n");

#	FilenameHeader();



	if ( (defined $QUERY) && ($QUERY =~ /^root-(files-only|level-files)$/i ) )
	{
		if ( opendir(DIRhandle, $directories_to_search[0] ) )
		{
			FilenameHeader();
			while (my $FILE = readdir(DIRhandle))
			{
				next if (-d "$directories_to_search[0]/$FILE");

				find(\&SearchDevelop, "$directories_to_search[0]/$FILE"); 		# Hack
			}
		}


		printf("<script type=\"text/javascript\" language=\"JavaScript\">\n");
		printf("\tdocument.getElementById(\"ReadyToGo\").style.backgroundColor=\"#FfF\";\n");

		if ($TotalSize >= 1024)
		{
			$TotalSize /= 1024; 								# kilobytes

			if ($TotalSize >= 1024)
			{
				$TotalSize /= 1024; 							# megabytes

				if ($TotalSize >= 1024) 						# gigabytes
				{
					$TotalSize /= 1024;
					$TotalSize=sprintf("%d GB", $TotalSize);
				}
				else
				{
					$TotalSize=sprintf("%d MB", $TotalSize);
				}
			}
			else
			{
				$TotalSize=sprintf("%d KB", $TotalSize);
			}
		}

		printf("\tdocument.getElementById(\"ReadyToGo\").innerHTML=\"Ready.  Found $TotalFiles root-level file%s totaling $TotalSize.\";\n", ($TotalFiles==1) ? "" : "s"  );
		printf("</script>\n");
	}
	else
	{
		find(\&SearchDevelop, @directories_to_search);
	}




#	printf("PreviousTabs: $PreviousTabs ($MaximumTabs)<br>\n"); 					# debug

	while ($MaximumTabs-- >= 0) 									# Because it can = 0
	{
		printf("	" x $MaximumTabs . "</ul>\n");
	}

#	printf("PreviousTabs: $PreviousTabs ($MaximumTabs)<br>\n"); 					# debug


	printf("<br clear=\"all\">\n\n");
#	printf("<div id=\"TransferSize\"></div>");

	printf("<input type=\"submit\" id=\"SubmitButton\"  			   value=\"Transfer files\"><p>\n");
	printf("<input type=\"reset\"  id=\"ClearButton\"   name=\"ClearButton\"   value=\"Clear selection\"   onclick=\"javascript:ClearAll(this);\">\n");
	printf("<br>\n\n");
	printf("<br>\n\n");


	printf("<div style=\"display:table; padding:5px 5px 0px 5px; position:fixed; right:10%%; top:20%%; border:solid 2px #F00; background-color:#FFF; z-index:2;\">");
	printf("<input type=\"submit\" id=\"SubmitButton\"  			   value=\"Transfer files\"  style=\"font-size:8pt\"><p>\n");
	printf("<input type=\"reset\"  id=\"ClearButton\"   name=\"ClearButton\"   value=\"Clear selection\" style=\"font-size:8pt\"  onclick=\"javascript:ClearAll(this);\">\n");
	printf("</form>\n");
	printf("</div>\n");
	printf("\n\n\n");




	printf("<!-- ");

	$TotalSizeWord=$TotalSize;

	if ($TotalSizeWord >= 1024)
	{
		$TotalSizeWord /= 1024; 								# kilobytes

		if ($TotalSizeWord >= 1024)
		{
			$TotalSizeWord /= 1024; 							# megabytes

			if ($TotalSizeWord >= 1024) 							# gigabytes
			{
				$TotalSizeWord /= 1024;
				$TotalSizeWord=sprintf("%d GB", $TotalSizeWord);
			}
			else
			{
				$TotalSizeWord=sprintf("%d MB", $TotalSizeWord);
			}
		}
		else
		{
			$TotalSizeWord=sprintf("%d KB", $TotalSizeWord);
		}
	}

	printf("-->\n\n");


	printf("<script type=\"text/javascript\" language=\"JavaScript\">\n");
#	printf("\tdocument.getElementById(\"SelectAllCheckbox\").disabled=false;\n");
	printf("\tdocument.getElementById(\"ReadyToGo\").style.backgroundColor=\"#FfF\";\n");
	printf("\tdocument.getElementById(\"ReadyToGo\").innerHTML=\"&nbsp;\"\n" );
	printf("\tdocument.getElementById(\"SubDescription\").innerHTML=\"$TotalFiles file%s totaling $TotalSizeWord\";\n", ($TotalFiles==1) ? "" : "s"  );



# Auto-open the root-level directory
#	if ( (defined $QUERY) && ($QUERY !~ /^root-(files-only|level-files)$/i ) )
	if ( (! defined $QUERY) || ($QUERY =~ /^\s*$/) )
	{
		printf("\ttoggleFolder('%s_image','%sList');\n", $BaseHREF, $BaseHREF);
	}
	printf("</script>\n");
	printf("\n\n");


	printf(DEBUG "Total size of data: $TotalSizeWord\n"); 						# debug


	$EpochFinish=time;
	printf(      "Page Loaded: %d seconds. [modified: $Modified]<br><br>\n", $EpochFinish-$EpochStart ) 	if ($Username =~ /^((DEVELOP(DR)?|TU|TEMPLE)\\(sbirl|vmehta02)|(sbirl|vmehta02)(-local)?)$/);
	printf(DEBUG "Page Loaded: %d seconds.<br><br>\n", $EpochFinish-$EpochStart );
	printf(DEBUG "\n\n\n\n");


#	printf("<i id=\"AJAXmessages\" style=\"border:solid 1px #000; background-color:#AAA; position:fixed; bottom:50px; right:10px; width:300px; font-size:8pt;\">AJAX messages</i>");

	ViewAllLogs();

	Bottom();
	exit 0;
}

# EOF
