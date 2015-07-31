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
	String groupName = request.getParameter("groupname") ;
	String groupPw = request.getParameter("grouppw") ;
	ResultSet rs, rs1 ;
	String query ;
	int i, j ;
	StringBuffer dbGroupName = new StringBuffer() ;

	try
	{
		if ((session.getValue("sessionId") == "0") || (session.getValue("sessionId") == null))
		{
			out.println("<center>") ;

			out.println("<br><br>You are logged-out, please sign in to continue") ;

			out.println("</center>") ;
		}
		else
		{
%>
		<%@ include file="connection.txt" %>
<%

			java.sql.Statement stmt = con.createStatement();

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
				if ((groupName == null) || (groupName.equals("")) || (groupPw == null) || (groupPw.equals("")))
				{
					out.println("<center>") ;

					out.println("<br>Enter the league name and password") ;
					out.println("<form action=\"createGroup.jsp\" method=\"post\" name=\"createForm\"><table><tr><td><b>League name</b>    <td><input type=\"text\" name=\"groupname\"><tr><td><b>League password</b>    <td><input type=\"password\" name=\"grouppw\"></table><br><input type=\"submit\" value=\"Create league\"></form>") ;

					out.println("</center>") ;
				}
				else
				{
					out.println("<center>") ;

					// Check for invalid characters
					for (i = 0 ; i < groupName.length() ; i++)
					{
						dbGroupName.append(groupName.charAt(i)) ;

						if (groupName.charAt(i) == '\'')
						{
							dbGroupName.append('\'') ;
						}
					}

					// Now check to see it's not all spaces.
					for (j = 0 ; j < groupName.length() ; j++)
					{
						if (groupName.charAt(j) != ' ')
						{
							break ;
						}
					}

					if (j == groupName.length())
					{
						out.println("<center><br><font color=red>League name contains invalid characters<br></font>") ;
					}
					else
					{
						// Get the max groupId
						query = "SELECT MAX(groupId) AS maxId FROM f1_groupname" ;

						rs = stmt.executeQuery(query) ;

						rs.next();

						int id = rs.getInt("maxId") + 1 ;

						String insert = "INSERT INTO f1_groupname (groupId, groupName, groupPassword) VALUES ('" + id + "', '" + dbGroupName + "', '" + groupPw + "')" ;

						int LinesAffected = stmt.executeUpdate(insert);

						if (LinesAffected != 1)
						{
							out.println("<font color=red>Problem creating league, try again later</font>") ;
						}
						else
						{
							out.println("<br>Congratulations, your league has been created.<br>") ;
							out.println("<br>You will need the following details when joining this league.<br>") ;
							out.println("<strong><br>League name is " + groupName + "<br>") ;
							out.println("League id is " + id + "<br>") ;
							out.println("League password is " + groupPw + "<br></strong>") ;
						}

						out.println("<br><A HREF=\"login.jsp?log=x&id=" + session.getValue("sessionId") + "\">Continue</A>") ;

						out.println("</center>") ;
					}
				}
			}
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