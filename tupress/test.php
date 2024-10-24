<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<meta name='robots' content='noindex,nofollow' />
<meta name="Temple University Press" content=" ">
<meta name="keywords" HTTP-EQUIV="keywords" content="temple university press, publishing, publisher, nonfiction">
<title>Temple University Press</title>
<script language="JavaScript">
<!--

//var searchLocation = "http://gong.temple.edu/search";




function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}
//-->
</script>
<script type="text/javascript">
<!--
<!--

function newImage(arg) {
	if (document.images) {
		rslt = new Image();
		rslt.src = arg;
		return rslt;
	}
}

function changeImages() {
	if (document.images && (preloadFlag == true)) {
		for (var i=0; i<changeImages.arguments.length; i+=2) {
			document[changeImages.arguments[i]].src = changeImages.arguments[i+1];
		}
	}
}

var preloadFlag = false;
function preloadImages() {
	if (document.images) {
		oct08_01_ImageMap_03_over = newImage("img/oct08_01-ImageMap_03_over.jpg");
		oct08_01_ImageMap_01_over = newImage("img/oct08_01-ImageMap_01_over.jpg");
		oct08_01_ImageMap_02_over = newImage("img/oct08_01-ImageMap_02_over.jpg");
		oct08_01_ImageMap_05_over = newImage("img/oct08_01-ImageMap_05_over.jpg");
		oct08_01_ImageMap_04_over = newImage("img/oct08_01-ImageMap_04_over.jpg");
		preloadFlag = true;
	}
}



// -->

function MM_validateForm() { //v4.0
  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
    if (val) { nm=val.name; if ((val=val.value)!="") {
      if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' must contain an e-mail address.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' must contain a number.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' must contain a number between '+min+' and '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' is required.\n'; }
  } if (errors) alert('The following error(s) occurred:\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
function getCheckedValue(radioObj) {
	if(!radioObj)
		return "";
	var radioLength = radioObj.length;
	if(radioLength == undefined)
		if(radioObj.checked)
			return radioObj.value;
		else
			return "";
	for(var i = 0; i < radioLength; i++) {
		if(radioObj[i].checked) {
			return radioObj[i].value;
		}
	}
	return "";
}

function redirectOutput(myForm) 
{
	var w = window.open('about:blank','Popup_Window', '');
	myForm.target = 'Popup_Window';
return true;
}

function TUsearchType() 
{
	if (getCheckedValue(document.forms['books_search'].elements['sType']) == "books")
	{
		document.forms['books_search'].action = 'http://books.google.com/books/p/temple_univ_press';
		//alert(document.books_search.Action);
		//alert(getCheckedValue(document.forms['books_search'].elements['sType']));
		
	} 
	else 
	{
		document.forms['books_search'].action = "http://gong.temple.edu/search";
		//alert(document.books_search.Action);
		//alert(getCheckedValue(document.forms['books_search'].elements['sType']));
		
	}
}

function TUsearchSubmit() 
{
	redirectOutput(document.forms['books_search']);
	
}

</script>

<script type="text/javascript" src="jquery-1.4.2.min.js"></script>
 
 <style type="text/css">
.slideshow { height: 300px;  margin-left:5px; border:none; 	font-weight: bold;	font-color:#676767;}
.slideshow img { border:0px; }

 </style>
<!-- include jQuery library -->

<!-- include Cycle plugin -->
<script type="text/javascript" src="jquery.cycle.lite.js"></script>

<!--  initialize the slideshow when the DOM is ready -->
<script type="text/javascript">
$(document).ready(function() {
    $('.slideshow').cycle({
		fx: 'fade' // choose your transition type, ex: fade, scrollUp, shuffle, etc...
	});
});
</script>

<link href="style.css" rel="stylesheet" type="text/css">


<style type="text/css">
<!--
.style6 {
	color: #990000;
	font-weight: bold;
}
-->
</style>
</head>
<!-- Site designed by D a w n  D a n i s h, Copyright 2005 Temple University.  All Rights Reserved. -->
<body onLoad="MM_preloadImages('features/more_books_on.gif'), preloadImages('images/febrollover/salt2.gif','images/febrollover/silent2.gif','images/febrollover/frankie2.gif','images/febrollover/spike2.gif','images/febrollover/black2.gif','img/april08/messages2.png','img/april08/care2.png','img/april08/loss2.png','img/april08/forklore2.png','img/april08/murals2.png','img/april08/newm2.png','img/april08/newc2.png','img/3b.gif','img/4b.gif','img/5b.gif')" bgcolor="#FFFFFF" leftMargin="0" topMargin="0" rightMargin="0">
<center>
  <!-- top banner -->
  <!-- <p>&nbsp;</p> -->
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#84B8DF">
    <tr>
      <td valign="top" align="center" width="100%"><img src="img/banner2_top.gif" border="0" width="450" height="78" alt="Temple University Press"></td>
    </tr>
    <tr>
      <td align="center"><br />
          <table cellpadding="0" cellspacing="0" border="0" />
    <tr cellpadding="0" cellspacing="0">
        <td id="Xsearch_widgets" cellpadding="0" cellspacing="0" align="left" nowrap="nowrap" valign="bottom" width="190"><label class="searchy">SEARCH FOR A BOOK</label>
        </td>
        <td cellpadding="0" cellspacing="0" align="left" nowrap="nowrap" valign="bottom" width="190"><label class="searchy">FULL TEXT SEARCH VIA GOOGLE</label>
        </td>
        <td id="Xbrowse" cellpadding="0" cellspacing="0" align="left" nowrap="nowrap" valign="bottom"><label class="searchy">BROWSE BY SUBJECT</label>
        </td>
    </tr>
      <tr cellpadding="0" cellspacing="0">
        <td cellpadding="0" cellspacing="0" align="left" nowrap="nowrap" valign="top"><form method='get' action='http://gong.temple.edu/search' name='books_search'>
            <input name="site" value="temple_index" type="hidden">
            <input name="client" value="temple_index" type="hidden">
            <input name="proxystylesheet" value="temple_index" type="hidden">
            <input name="restrict" value="temple" type="hidden">
            <input name="output" value="xml_no_dtd" type="hidden">
            <input name="sitesearch" value="www.temple.edu/tempress" type="hidden">
            <input maxlength="255" size="22" name="q" id="t">
            <input name="btnG" class="small" value="Find" type="submit">
        </form></td>
        <td cellpadding="0" cellspacing="0" align="left" nowrap="nowrap" valign="top" ><form method='get' action='http://books.google.com/books/p/temple_univ_press' name='books_search'>
            <input name="q" id="q" maxlength="255" value="" size="22" style="background: white url(images/google1.JPG) no-repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;" onKeyPress="if (window.event.keyCode==13) {fnGoogleSearch();window.event.keyCode=0;}" onKeyUp='this.style.background=(this.value=="" ? "white url(images/google1.JPG) no-repeat" : "white url(none) no-repeat");' type="text">
            <input name="btnG" value="Find" type="submit" class="small">
            <input name='hl'value='en_US'type='hidden'/>
            <input name='ie'value='UTF-8'type='hidden'/>
            <input name='oe'value='UTF-8'type='hidden'/>
        </form></td>
        <td cellpadding="0" cellspacing="0" align="left" nowrap="nowrap" valign="middle"><form action"" method="get">
            <select name="menu1" id="b" class="small" width="150" onChange="MM_jumpMenu('parent',this,0)">
              <option value="subjects.html">Browse a Category</option>
              <option value="african_studies.html">African Studies</option>
              <option value="african.html">African American Studies</option>
              <option value="american.html">American Studies</option>
              <option value="animal_soc.html">Animals, &amp; Society</option>
              <option value="anthropology.html">Anthropology</option>
              <option value="art.html">Art &amp; Photography</option>
              <option value="asian.html">Asian Studies</option>
              <option value="asian_amer.html">Asian American Studies</option>
              <option value="biography.html">Biography/Memoir/Autobiography</option>
              <option value="business.html">Business/Economics</option>
              <option value="cinema.html">Cinema Studies</option>
              <option value="cultural.html">Cultural Studies</option>
              <option value="disability.html">Disability Studies</option>
              <option value="education.html">Education</option>
              <option value="family.html">Family Policy</option>
              <option value="gender.html">Gender Studies</option>
              <option value="general.html">General Interest</option>
              <option value="geography.html">Geography</option>
              <option value="health.html">Health &amp; Health Policy</option>
              <option value="history.html">History</option>
			  <option value="immigration_studies.html">Immigration Studies</option>
              <option value="jewish.html">Jewish Studies</option>
              <option value="labor.html">Labor Studies &amp; Work</option>
              <option value="latin.html">Latin Am/Carib. Studies</option>
              <option value="latino.html">Latino/a Studies</option>
              <option value="law.html">Law &amp; Criminology</option>
              <option value="literature.html">Literature &amp; Drama</option>
              <option value="mass_media.html">Mass Media &amp; Com.</option>
              <option value="music.html">Music &amp; Dance</option>
              <option value="nature.html">Nature &amp; Environment</option>
              <option value="philly.html">Philadelphia Region</option>
              <option value="philosophy.html">Philosophy &amp; Ethics</option>
              <option value="political.html">PoliSci &amp; Public Policy</option>
              <option value="psycho.html">Psychology</option>
              <option value="race.html">Race &amp; Ethnicity</option>
              <option value="religion.html">Religion</option>
              <option value="science.html">Science</option>
              <option value="sexual.html">Sexual Identity</option>
              <option value="social.html">Social Movements</option>
              <option value="sociology.html">Sociology</option>
              <option value="sports.html">Sports</option>
              <option value="urban.html">Urban Studies</option>
              <option value="women.html">Women's Studies</option>
            </select>
        </form></td>
      </tr>
  </table>
  </td>
  </tr>
  <!-- navigation -->
<tr> 
      <td bgcolor="#990033"><img src="img/spacer.gif" border="0" width="2" height="1"></td>
  </tr>
    <tr> 
      <td bgcolor="#E5DCCB"><img src="img/spacer.gif" border="0" width="2" height="2"></td>
    </tr>
    <tr> 
      <td align="center" valign="top" nowrap bgcolor="3D607A"><span class="navigation"><a class="navigation" href="index.html">Home</a> 
        | <a class="navigation" href="books.html">Our 
        Books</a> | <a class="navigation" href="contact.html">Contact 
        Us</a> | <a class="navigation" href="order.html">Place 
        an Order</a> | <a class="navigation" href="media.html">Media</a> 
        | <a class="navigation" href="press.html">Press 
        Info</a> | <a class="navigation" href="links.html">Links</a></span></td>
    </tr>
    <tr> 
      <td bgcolor="#3D607A"><img src="img/spacer.gif" border="0" width="2" height="2"></td>
    </tr>
    <tr> 
      <td bgcolor="#333333"><img src="img/spacer.gif" border="0" width="2" height="1"></td>
    </tr>
  </table>
  <!-- main content page table -->
  <table border="0" cellspacing="0" cellpadding="2" width="100%">
    <tr> 
      <td valign="top" align="left" width="192"><br> 
        <!-- Search Box -->
        <!-- In the News -->
        <TABLE border=0 cellspacing=0 cellpadding=0>
          <!--DWLayoutTable-->
          <TR valign=bottom align=center> 
            <td width="190" height="19"><img src="img/news.gif" width="171" height="19" border="0" alt="In the News"></td>
          </TR>
          <TR valign="top" align="center"> 
            <TD rowspan="6"> <TABLE border="0" width= "190" cellpadding="1" cellspacing="0" bgcolor="#708090">
                <TR> 
                  <TD width="100%"> <TABLE width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="#708090">
                      <TR> 
                        <TD width="100%" height="1044" valign="top" bgcolor="#E5DCCB"><table width="174" cellpadding="3" cellspacing="0">
                          <td width="166" class="newsboxheader">Announcements</td>
						  													  <tr>
																			  <?php include('rss2html.php?XMLFILE=http://www.templepress.wordpress.com/feed&TEMPLATE=sample-template.html&MAXITEMS=5 target="_blank">'); ?>
																			  
																			  
                            <td class="small"><span class="bluedot">&#149; </span>Follow us on <a href="http://twitter.com/TempleUnivPress" target="new"><em>TWITTER</em></a> at TempleUnivPress </tr>
						  						 	
													  <tr>
                            <td class="small"><span class="bluedot">&#149; </span>Click <a href="libraries.html"><em>here</em></a> for Temple University Press titles recommended for the 2009 University Press Books for Public and Secondary School Libraries </tr>
						  <tr>
                            <td class="small"><span class="bluedot">&#149; </span>Temple University Press celebrates <a href="anniversary.html">40 years</a> of publishing excellence                        
                          </tr>
                          <tr>
                            <td height="42" class="small"><span class="bluedot">&#149; </span>This week in <a href="http://templepress.wordpress.com/" target="new"><em>North Philly Notes</em></a>,  Lori Amy, author of <a href="titles/2013_reg.html"><em>The Wars We Inherit</em></a>, asks, How much of our identities come from the &ldquo;enemy&rdquo; against which we define ourselves?</tr>
                          <tr>
                            <td height="68" class="small"><span class="bluedot">&#149; </span>Temple University Press is proud to announce that we now have a presence on the social networking site Facebook. Check out the site <a href="http://www.facebook.com/pages/Temple-University-Press/21638877349?ref=s" target="new"><em>here</em></a>. (NOTE: You must be a registered user to view).                         
                          </tr>
                          <tr>
                            <td width="166" class="newsboxheader">Featured Authors</td>
							<tr>
                            <td class="small"><span class="bluedot">&#149; </span>Bill Ong Hing, author of <a href="titles/1999_reg.html"><em>Ethical Borders</em></a> was a guest on KQED's FORUM (88.5 KQED FM) on Wednesday, June 30. His interview is available as an <a href="http://www.kqed.org/epArchive/R201006301000" target="new"><em>online podcast</em></a>. </tr>
							<tr>
							</tr><td width="166" class="newsboxheader">Book Reviews</td>
						   <tr>
                            <td height="103" class=small>&#149; The July 2010 issue of <em>CHOICE</em> reviewed <a href="titles/2011_reg.html"><em>Recasting Welfare Capitalism</em></a> by Mark Vail. The review read, &quot;Vail (Tulane Univ.) challenges prevalent theories purporting to explain the four-decade-old transformation of welfare states in his analysis of the effects of liberalization and austerity on welfare capitalism.... Readers both inside and outside the box will be captivated by this seminal contribution to the literature on the development of varieties of welfare capitalism. Summing Up: Highly recommended.&quot; </td>
                          </tr>			
						  <tr>
                            <td height="103" class=small>&#149; The June 2010 issue of <em>The Journal of American History</em> reviewed Paul Lopes' <a href="titles/1829_reg.html"><em>Demanding Respect</em></a>. The review read, &quot;A concise history of the American comic book industry from the 1930s to the present....this is a solid piece of work.&quot; </td>
                          </tr>							
						  <tr>
                            <td height="103" class=small>&#149; The July 2010 issue of <em>The Americas</em> journal reviewed Amalia Cabeza's <a href="titles/1965_reg.html"><em>Economies of Desire</em></a> and Cathy Ragland's <a href="titles/1957_reg.html"><em>M&uacute;sica Norte&ntilde;a</em></a>. The review of <a href="titles/1965_reg.html"><em>Economies of Desire</em></a> read, &quot;Cabezas&rsquo;s arguments are enhanced by numerous personal interviews....The interviews and work experience are quite suggestive and add substantial insight and personal narrative to her theoretical constructions.... [T]his book provides a thought-provoking framework with which to ponder the pervasiveness and various manifestations of sex work in Cuba and the Dominican Republic.&quot; The review of <a href="titles/1957_reg.html"><em>M&uacute;sica Norte&ntilde;a</em></a> read, &quot;Cathy Ragland has written a splendid scholarly study of m&uacute;sica norte&ntilde;a, which originated in the Mexican northern borderlands.... Ragland&rsquo;s brilliant and informative study.... is well done and is an excellent contribution to the history of the Chicano people&rsquo;s amazingly rich and varied musical heritage.&quot; </td>
                          </tr>	 
                          <tr>
                            <td class=small><span class="bluedot">&#149;&nbsp;</span><a href="media.html">More Recent Reviews </a></td>
                          </tr>
                          <tr>
                            <td><span class="newsboxheader"> Press Notes</span></td>
                          </tr>
                          <tr>
                            <td class=small><span class="bluedot">&#149;&nbsp;</span><a href="calendar.html">Calendar</a></td>
                          </tr>
                          <tr>
                            <!--<img src="img/coming.jpg" name="Coming Next Month" width="118" height="19" border="0">-->
                            <td class=small><span class="bluedot">&#149;&nbsp;</span><a href="javascript:;" onClick="MM_openBrWindow('popup/popup.html','','width=400 height,height=250')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Coming Next Month','','img/coming_on.jpg',1)">Coming Next Month</a></td>
                          </tr>
                          <tr>
                            <td class=small><span class="bluedot">&#149;&nbsp;</span><a href="recent_arrivals.html">Recent Arrivals</a></td>
                          </tr>
                        </table></TD>
                      </TR>
                    </TABLE>
                  <a href="http://www.americanliteratures.org"><img src="img/ali.gif" width="185" height="180" border="1"></a></TD>
              </TABLE>
			  <br>
			   <a href="http://www.temple.edu"><img src="img/temple_university.gif" width="142" height="50" border="0"></a>
            </TD>
        </TABLE></td>
      <!-- homepage features -->
      <td width="802" valign="top"> <table border="0" cellspacing="0" cellpadding="12" width="100%">
          <!--DWLayoutTable-->
          <!-- main feature table --><tr><td width="73%" align="center" valign="top">
		  
		  
		  <!-- BEING NEW BOOKS (REMOVE THIS TO REPLACE WITH FEATURE, PUT IN SUBFEATURE -->
		 <table width="100%" border="0" cellpadding="12" cellspacing="0">
                <!--DWLayoutTable-->
                <tr> 
                  <td colspan="2" align="left"> <p class="normal">
<img src="img/july_feature.jpg" alt="" border="0" usemap="#Map">
				  <br>
				  <br><br><br><img src="img/recentbooks.jpg" alt="New Books"> <br><br>
				  </td>
                </tr>					
					<!-- <tr> 
                  <td width="100" height="167" align="right" valign="top"><p class="normal"> 
                    <a href="titles/2079_reg.html"><img src="small/2079_sm.gif" alt="Beyond Preservation" width="99" height="150" border="0" align="top"></a></td>
                  <td width="402" align="left" valign="top"><p class="normal">
				  <a href="titles/2079_reg.html"><strong>Beyond Preservation</strong><br>
				 Using Public History to Revitalize Inner Cities</a><br>Andrew Hurley
                  <p><I>"&ldquo;This strikingly original book poses a crucial challenge to historic preservation in American cities: how can these efforts avoid the too-common fate of historically-grounded gentrification, and instead contribute to genuinely inclusive urban revitalization within those very communities whose buildings and streetscapes are being lovingly preserved and restored? Hurley&rsquo;s answer, informed by broad research and extensive direct practice, is to use public history as a process for inclusive community engagement that turns a shared past into an active resource for change. He effectively develops a clear argument through wonderfully concrete case studies interwoven with insightful synthetic discussion. The result is a powerful yet accessible book&mdash;at once intellectually rich, narratively engaging, and immediately useful in both applied and theoretical ways.&rdquo;</I> <BR>
&mdash;Michael Frisch, Professor of American Studies and History/Senior Research Scholar University at Buffalo, SUNY and President, Oral History Association <br>
                  </td>
                </tr>	 -->
				<tr> 
                  <td width="100" height="167" align="right" valign="top"><p class="normal"> 
                    <a href="titles/909a_reg.html"><img src="small/909a_sm.gif" alt="Separate Societies" width="100" height="150" border="0" align="top"></a></td>
                  <td width="402" align="left" valign="top"><p class="normal">
				  <a href="titles/909a_reg.html"><strong>Separate Societies</strong><br>
				 Poverty and Inequality in U.S. Cities<br>Second Edition
                  </a><br>William W. Goldsmith and Edward J. Blakely<br>Foreword by President Bill Clinton                  
                  <p>The award-winning book on urban poverty&mdash;now thoroughly revised and updated<br>
                  </td>
                </tr>
				<tr> 
                  <td width="100" height="167" align="right" valign="top"><p class="normal"> 
                    <a href="titles/1955_reg.html"><img src="small/1955_sm.gif" alt="Live Wire" width="100" height="150" border="0" align="top"></a></td>
                  <td width="402" align="left" valign="top"><p class="normal">
				  <a href="titles/1955_reg.html"><strong>Live Wire</strong><br>
				 Women and Brotherhood in the Electrical Industry</a><br>Francine A. Moccio<br>
				  <span class="style6">New In Paperback!                  </span>
                  <p><em>&quot;</em>Live Wire<em> is the story of every group of outsiders who has ever tried to enter the world of insiders, of women braving an all-male kingdom, and of unions that cannot succeed without women&mdash;and vice versa. In telling the stories of women electricians, Francine Moccio gives us a universal human story, an expos&eacute; of why women are still only two percent of the building trades despite thirty years of trying, and a key to the mystery of why Americans are still seventy percent more likely to end up old and poor if they are female. If President Obama wants to solve the problems of poverty and our crumbling bridges and highways at the same time, he should read this book and insist that women work side by side with men. And if anybody thinks for a moment the women's movement is over, he or she should go right out and buy </em>Live Wire<em>.&quot; </em><br>
                    &mdash;Gloria Steinem<br>
                  </td>
                </tr>
				 <tr> 
                  <td width="100" height="167" align="right" valign="top"><p class="normal"> 
                    <a href="titles/0886-3_reg.html"><img src="small/0886-3_sm.gif" alt="Essays on Twentieth-Century History" width="99" height="150" border="0" align="top"></a></td>
                  <td width="402" align="left" valign="top"><p class="normal">
				  <a href="titles/0886-3_reg.html"><strong>Essays on Twentieth-Century History</strong></a><br>edited by Michael Adas
                  <p>Probing the paradoxes of &quot;the long twentieth century&quot;&mdash;from unprecedented human opportunity and deprivation to the rise of the United States as a hegemon<br>
                  </td>
                </tr>
				<tr> 
                  <td width="100" height="167" align="right" valign="top"><p class="normal"> 
                    <a href="titles/1908_reg.html"><img src="small/1908_sm.gif" alt="Livestock/Deadstock" width="99" height="150" border="0" align="top"></a></td>
                  <td width="402" align="left" valign="top"><p class="normal">
				  <a href="titles/1908_reg.html"><strong>Livestock/Deadstock</strong><br>
				 Working with Farm Animals from Birth to Slaughter</a><br>Rhoda M. Wilkie
                  <p><em>&quot;This welcome book tackles an important and neglected topic in an interesting and insightful manner. Full of empirical detail and written in an engaging style, </em>Livestock/Deadstock<em> is a valuable contribution to an emerging literature focusing on agricultural knowledge practices and the complexities and ambiguities of human-animal relationships in farming.&quot;</em> <br>
                    &mdash;Lewis Holloway, University of Hull <br>
                  </td>
                </tr>
				<tr> 
                  <td width="100" height="167" align="right" valign="top"><p class="normal"> 
                    <a href="titles/1934_reg.html"><img src="small/1934_sm.gif" alt="On the Margins of Citizenship" width="100" height="146" border="0" align="top"></a></td>
                  <td width="402" align="left" valign="top"><p class="normal">
				  <a href="titles/1934_reg.html"><strong>On the Margins of Citizenship</strong><br>
				 Intellectual Disability and Civil Rights in Twentieth-Century America</a><br>Allison C. Carey<br>
				  <span class="style6">New In Paperback!                  </span>
                  <p><em>&quot;</em>On the Margins of Citizenship<em> is a remarkable book. It has a broad scope, impressively addressing the history of American twentieth-century intellectual disability empirically at the individual, community, and policy levels.&quot;</em><br>
                    &mdash;Richard Scotch, Professor of Sociology and Public Policy, University of Texas at Dallas<br>
                  </td>
                </tr>
				<tr> 
                  <td width="100" height="167" align="right" valign="top"><p class="normal"> 
                    <a href="titles/2045_reg.html"><img src="small/2045_sm.gif" alt="The Machinery of Whiteness" width="99" height="150" border="0" align="top"></a></td>
                  <td width="402" align="left" valign="top"><p class="normal">
				  <a href="titles/2045_reg.html"><strong>The Machinery of Whiteness</strong><br>
				 Studies in the Structure of Racialization</a><br>Steve Martinot
                  <p><I>"</I>The Machinery of Whiteness<I> is extremely interesting and engaging. Martinot's use of historical examples to support and accentuate the structure of racialization is illuminating. His explication of the disenfranchisement of blacks after the Civil War is excellent, as is his introduction of the concept of a para-political state. Martinot's book advances the literature by synthesizing the history of the development of the black-white divide and a racialized structure."</I> <BR>
&mdash;Douglas George, University of Central Arkansas<br>
                  </td>
                </tr>
				
				
				
				
            </table>
			<!-- END NEW BOOKS, CUT UP TO HERE TO REPLACE WITH FEATURE -->			
               </td>
            <td width="27%" align="center"  valign="top"><TABLE border="0" cellspacing="0" cellpadding="0">
              <TR valign="top" align="center">
                <td width="195" height="19">&nbsp;</td>
              </TR>
			  <TR valign=bottom align=center bordercolor="#FFFFFF"> 
            <td width="187" height="19" bordercolor="FFFFFF"><img src="img/blog.gif" width="171" height="19" border="0" alt="Visit Our Blog"></td>
          </TR>
              <TR valign="top" align="center" bordercolor="#FFFFFF">
                <TD><TABLE border="0" width= "171" cellpadding="1" cellspacing="0" bgcolor="#708090">
				 
                    <TR>
                      <TD width="100%"><TABLE width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="#708090">
                          <TR>
						  
						  <td bgcolor="#E5DCCB" align="center" valign="top" class="newsboxheader">
						  <a href="http://templepress.wordpress.com/"><img src="img/visit.gif" border="0"></a><br><br><br><br>
						
						
						 <font color="#990033">Fall 2010 Catalog<br><br>
						         <a href="catalogs/fall2010.html"><img src="catalogs/fall2010.gif" alt="Fall 2010 Catalog" border="0"></a><br>
                                      
							  
                                  <font size="1" face="Verdana, Arial, Helvetica, sans-serif">Click 
                                  <a href="catalogs/archive/fall2010.pdf">here</a> 
                                for PDF.<br />
								Click <a href="http://www.scribd.com/doc/31877218/Fall-2010" target="new">here</a> for Flash. <br><br>
								</font> <br><br><br>
						
						  New Books for Course Adoption</font><br /><br />
						   <div class="slideshow">
	<p align="center"><a href="http://www.temple.edu/tempress/titles/1440_reg.html"><img src="http://www.temple.edu/tempress/titles/1440_reg.gif" width="133" height="200" alt="Black Venus 2010" /></a><br />Black Venus 2010</p>
    <p align="center"><a href="http://www.temple.edu/tempress/titles/1966_reg.html"><img src="http://www.temple.edu/tempress/titles/1966_reg.gif" width="133" height="200" alt="The Delinquent Girl" /></a><br />The Delinquent Girl</p>
    <p align="center"><a href="http://www.temple.edu/tempress/titles/1634_reg.html"><img src="http://www.temple.edu/tempress/titles/1634_reg.gif" width="133" height="200" alt="Afro-Caribbean Religions" /></a><br />Afro-Caribbean <br />Religions</p>
	<p align="center"><a href="http://www.temple.edu/tempress/titles/1998_reg.html"><img src="http://www.temple.edu/tempress/titles/1998_reg.gif" width="133" height="200" alt="The African Transformation of Western Medicine and the Dynamics of Global Cultural Exchange" /></a><br />The African Transformation of Western Medicine and the Dynamics of Global Cultural Exchange</p>
	<p align="center"><a href="http://www.temple.edu/tempress/titles/2013_reg.html"><img src="http://www.temple.edu/tempress/titles/2013_reg.gif" width="133" height="200" alt="The Wars We Inherit" /></a><br />The Wars We Inherit</p>
	<p align="center"><a href="http://www.temple.edu/tempress/titles/2086_reg.html"><img src="http://www.temple.edu/tempress/titles/2086_reg.gif" width="133" height="200" alt="Feminism and Affect at the Scene of Argument" /></a><br />Feminism and Affect at the Scene of Argument</p>
	</div><br>
						
						
								
							
								
								
								
                                
						  </td></tr></table>
								  
								  
								  
                                  <img src="img/new_noteworthy.gif" width="171" height="19" border="0" alt="New &amp; Noteworthy">
                                  <TABLE width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="#708090"><tr>
                            <TD align="left" valign="middle" bgcolor="#E5DCCB" width="100%"><p class="normal"><span class="small">Subscribe to our monthly newsletter for info about new books and website content.</span> </p>
                                <form action="http://www.temple.edu/cgi-bin/mail?tempress@temple.edu" method="post" name="Newsletter Subscription">
                                  <p class="normal" align="center">
                                    <input name="email" type="text" class="small" onBlur="MM_validateForm('email','','RisEmail');return document.MM_returnValue" onClick="this.value=''" value=" Your Email Address" size="25" />
                                    <br>
&nbsp;<br>
                      <input type="hidden" name="subject" value="Newsletter Subscription">
                      <input class="small" type="submit" value="Subscribe!" name="submit">
                      <input type="hidden" name="next-url" value="http://www.temple.edu/tempress/received_subscription.html">
                                </form></TD>
                          </TR>
                      </TABLE></TD>
                </TABLE></TD>
            </TABLE></td>
          </tr>
          <!-- subfeatures table BTW THIS IS WHERE NEW BOOKS USED TO BE -->
		  
		  
          <tr> 
            <td height="2" colspan="3" align="center" valign="top"> 
			
              
            </td>
          </tr>
          </table></td>
    </tr>
  </table>
  
  <!-- footer table -->
  <table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr> 
      <td colspan="2" bgcolor="#990033"><img src="img/spacer.gif" border="0" width="2" height="1"></td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#E5DCCB"><img src="img/spacer.gif" border="0" width="2" height="2"></td>
    </tr>
    <tr> 
      <td colspan="2" align="center" valign="top" nowrap bgcolor="3D607A"><span class="navigation"><a class="navigation" href="index.html">Home</a> 
        | <a class="navigation" href="books.html">Our 
        Books</a> | <a class="navigation" href="contact.html">Contact 
        Us</a> | <a class="navigation" href="order.html">Place 
        an Order</a> | <a class="navigation" href="media.html">Media</a> 
        | <a class="navigation" href="press.html">Press 
        Info</a> | <a class="navigation" href="links.html">Links</a> 
        </span> </td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#3D607A"><img src="img/spacer.gif" border="0" width="2" height="2"></td>
    </tr>
    <tr> 
      <td colspan="2" bgcolor="#333333"><img src="img/spacer.gif" border="0" width="2" height="1"></td>
    </tr>
    <tr> 
      <td width="50%" valign="top" align="left" nowrap> <span class="small">&nbsp;<a href="copyright.html">&copy;</a> 
        2006<a href="http://www.temple.edu" target="new"> 
        Temple University</a>. All Rights Reserved.</span><br></td>
      <td width="50%" valign="top" align="right" nowrap> <span class="small"><a href="mailto:tempress@temple.edu">Webmaster</a>&nbsp;</span><br></td>
    </tr>
  </table>
</center>
<map name="Map">
  <area shape="rect" coords="45,365,164,540" href="http://www.temple.edu/tempress/titles/1926_reg.html">
  <area shape="rect" coords="175,364,293,541" href="http://www.temple.edu/tempress/titles/1899_reg.html">
  <area shape="rect" coords="306,364,425,539" href="http://www.temple.edu/tempress/titles/2024_reg.html">
  <area shape="rect" coords="434,364,581,533" href="http://www.temple.edu/tempress/titles/2033_reg.html">
</map>
</body>
</html>
