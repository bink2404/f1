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
	String teamId = request.getParameter("id") ;
	String submit = request.getParameter("submit") ;
	String changeId = request.getParameter("cId") ;
	ResultSet rs, rs1 ;

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

			String query = "SELECT updating FROM f1_admin WHERE updating >= 0" ;

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
				query = "SELECT userId FROM f1_userteam WHERE teamId = " + teamId ;

				rs = stmt.executeQuery(query);

				if (rs.next())
				{
					String strId = String.valueOf(session.getValue("sessionId")) ;

					if (Integer.parseInt(strId) != rs.getInt("userId"))
					{
						out.println("<center>") ;

						out.println("<br><br>You are not the owner of this team") ;
						out.println("<br><br><A HREF=\"login.jsp?log=x&id=" + session.getValue("sessionId") + "\">Continue</A>") ;

						out.println("</center>") ;
					}
					else
					{
						if ((submit == null) || (submit.equals("")) || (changeId == null) || (changeId.equals("")))
						{
							out.println("<center>") ;

							out.println("<br><b>Select the league you wish to join</b><br>") ;
							out.println("<br>The public leagues are divided according to the skill level of the players") ;
							out.println("<form action=\"addToPublicGroup.jsp\" method=\"post\" name=\"addForm\"><table><tr><td><input type=\"hidden\" name=\"id\" value=\"" + teamId + "\" readonly><tr><td><input type=\"radio\" name=\"cId\" value =\"1\">Public League 1 (expert)<tr><td><input type=\"radio\" name=\"cId\" value =\"2\">Public League 2 (average)<tr><td><input type=\"radio\" name=\"cId\" value =\"3\">Public League 3 (beginner)</table><br><input type=\"submit\" name=\"submit\" value=\"Join\"></form>") ;

							out.println("</center>") ;
						}
						else
						{
							out.println("<center>") ;

							if (submit.equals("Join"))
							{
								int gId = Integer.parseInt(changeId) ;

								query = "UPDATE f1_userteam SET groupId = " + (19 + gId) + " WHERE teamId = " + teamId ;

								int LinesAffected = stmt.executeUpdate(query);

								if (LinesAffected != 1)
								{
									out.println("<center>") ;
									out.println("<br>Problem updating database") ;
								}
							}

							out.println("<br><A HREF=\"login.jsp?log=x&id=" + session.getValue("sessionId") + "\">Continue</A>") ;

							out.println("</center>") ;

							con.close() ;
							response.sendRedirect("login.jsp?log=x&id=1");
						}
					}
				}
				else
				{
					// Team not found
					out.println("<br><br>Team not found") ;
					out.println("<br><br><A HREF=\"login.jsp?log=x&id=" + session.getValue("sessionId") + "\">Continue</A>") ;
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
<p><center>
<br>
</center></p>

<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-437032-1";
urchinTracker();
</script>

</body>

</html>

