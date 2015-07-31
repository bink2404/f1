<%
response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
response.setHeader("Pragma", "no-cache");
%>

<html>

<head>

<%@ page 
	import = "java.io.*"
	import = "java.sql.*"
	import = "com.clix.*"
	import = "javax.mail.*"
	import = "javax.mail.internet.*"
%>

<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<meta http-equiv="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<meta name="keywords" content="fantasy, sports, sport, fantasy sport, fantasy league, fantasy manager, game, games, free, fantasysportnet, motor racing, formula one, formula 1, formula1, f1">

<title>fantasysportnet - Formula One</title>

<SCRIPT LANGUAGE="JavaScript">
 function putFocus(formInst, elementInst) {
  if (document.forms.length > 0) {
   document.forms[formInst].elements[elementInst].focus();
  }
 }
</script>

</head>

<body onLoad="putFocus(0,0);" bgcolor=white>

<center>

<%@ include file="header.txt" %>

<center>
<script type="text/javascript"><!--
google_ad_client = "pub-9229293934937598";
google_ad_width = 468;
google_ad_height = 60;
google_ad_format = "468x60_as";
google_ad_type = "text";
google_ad_channel ="";
google_color_border = "FFFFFF";
google_color_link = "001480";
google_color_bg = "FFFFFF";
google_color_text = "000000";
google_color_url = "001480";
//--></script>
<script type="text/javascript"
  src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
</center>
<br><br>

<%@ include file="url.txt" %>

<% 
	String inId = request.getParameter("id") ;
	ResultSet rs, rs1, rs2 ;
	String query ;
	String insert ;
	int i ;
	String name = null ;
	String email = null ;
	String password = null ;
	boolean found = false ;

	try
	{
%>
		<%@ include file="connection.txt" %>
<%

		java.sql.Statement stmt = con.createStatement();
		java.sql.Statement stmt2 = con.createStatement();

		query = "SELECT updating FROM f1_admin WHERE updating >= 0" ;

		rs = stmt.executeQuery(query);

		rs.next() ;

		if (rs.getInt("updating") == 1)
		{
			out.println("<center>") ;

			out.println("<br><br>The database is being updated, please try again later") ;

			out.println("</center>") ;
		}
		else
		{
			out.println("<center>") ;

			if ((inId == null) || inId.equals(""))
			{
				out.println("<br>Enter your user i.d. or e-mail address") ;
				out.println("<form action=\"passwordReminder.jsp\" method=\"post\" name=\"remindForm\"><table><tr><td><input type=\"text\" name=\"id\"></table><br><input type=\"submit\" value=\"Send request\"></form>") ;
				out.println("<br>Your password will be sent to the e-mail address entered when you created the i.d."); 
			}
			else
			{
				query = "SELECT name, emailAddress, password FROM f1_user WHERE name = '" + inId + "'" ;

				rs2 = stmt2.executeQuery(query);

				if (rs2.next())
				{
					name = rs2.getString("name") ;
					email = rs2.getString("emailAddress") ;
					password = rs2.getString("password") ;

					found = true ;
				}
				else
				{
					query = "SELECT name, emailAddress, password FROM f1_user WHERE emailAddress = '" + inId + "'" ;

					rs2 = stmt2.executeQuery(query);

					if (rs2.next())
					{
						name = rs2.getString("name") ;
						email = rs2.getString("emailAddress") ;
						password = rs2.getString("password") ;

						found = true ;
					}
				}

				if (found == true)
				{
					try 
					{ 
						SendMailBean mail = new SendMailBean(); 
						mail.setHost("localhost"); 
						mail.setAuthenticate(true); 
						mail.setUserName("fantas15"); 
						mail.setPassword("binkish"); 
						mail.setFrom("support@fantasysportnet.com"); 
						mail.addTo(email); 
						mail.setSubject("Your fantasysportnet password reminder"); 
						mail.setBody("user name = " + name + "<br><br>password = " + password); 
						mail.setHTML(true); 
						mail.send();

						out.println("<br>Your password has been sent.<br>") ;
					} 
					catch(Exception e) 
					{ 
						StringWriter sw = new StringWriter(); 
						PrintWriter pw = new PrintWriter(sw); 
						e.printStackTrace(pw); 
						pw = null; 
						sw = null; 
					} 
				}
				else
				{
					out.println("<br>No data found<br>") ;
				}
			}

			out.println("</center>") ;
		}
	}
	catch (Exception e)
	{
		out.println("<br>Problem reading the database - try again later<br><br><br>") ;
		//out.println(e) ;
	}
%>

<br>
<br>

<%@ include file="footer.txt" %>

</center>
</div>

<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-437032-1";
urchinTracker();
</script>

</body>

</html>
