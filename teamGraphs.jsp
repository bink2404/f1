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

</head>

<body bgcolor=white>

<center>

<%@ include file="header.txt" %>

</center>

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
	String raceTeamName = request.getParameter("name") ;
	String teamId = request.getParameter("team") ;
	ResultSet rs, rs1 ;
	int i ;
	int weekNum ;
	int score ;
	int price ;
	String query ;
	String firstName ;

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
			if ((raceTeamName == null) || raceTeamName.equals(""))
			{
				out.println("<center>") ;

				out.println("<br><br>Invalid team") ;
				out.println("<br><br><A HREF=\"login.jsp?log=x&id=" + session.getValue("sessionId") + "\">Continue</A>") ;

				out.println("</center>") ;
			}
			else
			{
%>
		<%@ include file="connection.txt" %>
<%

				java.sql.Statement stmt = con.createStatement();
				java.sql.Statement stmt1 = con.createStatement();

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
					query = "SELECT weekNum FROM f1_admin WHERE weekNum > 0" ;

					rs = stmt.executeQuery(query);

					rs.next() ;

					weekNum = rs.getInt("weekNum") ;

					out.println("<center><br><A HREF=\"team.jsp?id=" + teamId + "&weekNum=" + weekNum + "\">Return to team page</A></center>") ;

					out.println("<br></center>") ;

					out.println("<b>") ;

					out.println(raceTeamName) ;

					out.println("</b>") ;
					
					out.println("<br><br>") ;

					out.println("<td><br><img src=\"images/scoreText.gif\" width=800 height=15><br></td>") ;

					out.println("<table border=0 cellspacing=0 cellpadding=0>") ;
						out.println("<tr valign=bottom align=center>") ;

						out.println("<td><br><img src=\"images/vgraph.gif\" width=50 height=200 vspace=0><br></td>") ;

						for (i = 1 ; i < weekNum ; i++)
						{
							score = 0 ;

							// Find the team scores
							query = "SELECT score FROM f1_raceteam" + i + " WHERE raceTeamName = '" + raceTeamName + "'" ;

							rs1 = stmt1.executeQuery(query);

							if (rs1.next())
							{
								score = rs1.getInt("score") ;
							}

							if (score > 0)
							{
								out.println("<td><br><img src=\"images/blue.gif\" width=30 height=" + (score * 8) + " vspace=0><br></td>") ;
							}
							else
							{
								out.println("<td><br><img src=\"images/white.gif\" width=30 height=0 vspace=0><br></td>") ;
							}
						}
						
						out.println("</tr>") ;
					out.println("</table>") ;

					out.println("<img src=\"images/hgraph.gif\" width=800 height=4 vspace=0><br>") ;
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

<center>

<br>
<br>

<%@ include file="footer.txt" %>

</center>
</div>
<p>

<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-437032-1";
urchinTracker();
</script>

</body>

</html>
