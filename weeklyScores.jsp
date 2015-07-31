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

<div align="center">
<center>

<%@ include file="url.txt" %>

<% 
	String groupId = request.getParameter("id") ;
	ResultSet rs, rs1, rs2, rs3 ;
	int weekNum ;
	int outScore ;
	int i ;
	int tId ;
	String bgColor ;
	double highScore = 0.00 ;

	try
	{
		if ((session.getValue("sessionId") == "0") || (session.getValue("sessionId") == null))
		{
			out.println("<center>") ;

			out.println("<br><br>You are logged-out, please sign in to continue<br><br>") ;
		}
		else
		{
%>
		<%@ include file="connection.txt" %>
<%

			java.sql.Statement stmt = con.createStatement();
			java.sql.Statement stmt3 = con.createStatement();

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
				query = "SELECT groupName FROM f1_groupname WHERE groupId = " + groupId ;

				rs = stmt.executeQuery(query);

				if (rs.next())
				{
					java.sql.Statement stmt2 = con.createStatement();

					query = "SELECT weekNum FROM f1_admin WHERE weekNum > 0" ;

					rs2 = stmt2.executeQuery(query);

					rs2.next() ;

					weekNum = rs2.getInt("weekNum") ;

					out.println("<center>") ;

					out.println("<br><strong>" + rs.getString("groupName") + "</strong><br>") ;

					int tableWidth = 300 + (75 * weekNum) ;

					query = "SELECT userTeamName, teamId, score, userId FROM f1_userteam WHERE groupId = " + groupId + " ORDER BY score DESC" ;

					rs1 = stmt.executeQuery(query);

					int pos = 1 ;

					out.println("<table border=\"0\" width=\"" + tableWidth + "\" height=\"1\" cellpadding=\"2\">") ;
%>

	<tr>
      <td width="50" height="1" bgcolor="#001480"><font color="#FFFFFF"><b>Rank</b></font></td>
      <td width="250" height="1" bgcolor="#001480"><font color="#FFFFFF"><b>Team</b></font></td>

<%
                                        out.println("<td width=\"75\" height=\"1\" bgcolor=\"#001480\"><font color=\"#FFFFFF\"><b>Total</b></font></td>") ;

					for (i = weekNum-1 ; i >= 1 ; i--)
					{ 
						out.println("<td width=\"75\" height=\"1\" bgcolor=\"#001480\"><font color=\"#FFFFFF\"><b>Week " + i + "</b></font></td>") ;
					}

					out.println("</tr>") ;

					while (rs1.next())
					{
						tId = rs1.getInt("teamId") ;

						out.println("<tr>") ;

						if (rs1.getInt("userId") == Integer.parseInt(String.valueOf(session.getValue("sessionId"))))
						{
							bgColor = "#B5B5B5" ;
						}
						else
						{
							bgColor = "#E0E0E0" ;
						}

						out.println("<td width=\"20%\" height=\"28\" bgcolor=\"" + bgColor + "\">") ;
						out.println(pos + ".</td>") ;
						out.println("<td width=\"40%\" height=\"28\" bgcolor=\"" + bgColor + "\"><A HREF=\"team.jsp?id=" + tId + "&weekNum=" + weekNum + "\">" + rs1.getString("userTeamName") + "</A> </td>") ;

                                                // Now print the total
						outScore = rs1.getInt("score") ;

						out.println("<td width=\"75\" height=\"28\" bgcolor=\"" + bgColor + "\">" + outScore + "</td>") ;

						// Now output the weekly scores
						for (i = weekNum-1 ; i >= 1 ; i--)
						{
							// First find the highest scoring team for this week
							query = "SELECT teamId, score FROM f1_userteam" + i + " WHERE groupId = " + groupId + " ORDER BY score DESC" ;

							rs3 = stmt3.executeQuery(query);

							if (rs3.next())
							{
								highScore = rs3.getDouble("score") ;
							}
							else
							{
								highScore = -99 ;
							}

							query = "SELECT score FROM f1_userteam" + i + " WHERE teamId = " + tId ;

							rs2 = stmt2.executeQuery(query);

							if (rs2.next())
							{
								outScore = rs2.getInt("score") ;

								// Highlight the highest scorers
								if (outScore == highScore)
								{
									out.println("<td width=\"75\" height=\"28\" bgcolor=\"" + bgColor + "\"><b>" + outScore + "</b></td>") ;
								}
								else
								{
									out.println("<td width=\"75\" height=\"28\" bgcolor=\"" + bgColor + "\">" + outScore + "</td>") ;
								}
							}
							else
							{
								out.println("<td width=\"75\" height=\"28\" bgcolor=\"" + bgColor + "\">-</td>") ;
							}
						}

						out.println("</tr>") ;

						pos++ ;
					}

					out.println("</table>") ;

					out.println("</center>") ;

					out.println("<table border=\"0\" width=\"" + tableWidth + "\" height=\"1\" cellpadding=\"2\">") ;
					out.println("<tr>") ;
					out.println("<td width=\"100%\" height=\"1\" bgcolor=\"#FFFFFF\" align=left><font color=\"#000000\"><A HREF=\"messageBoard.jsp?groupId=" + groupId + "\">Message board</A></font></td>") ;
					out.println("</tr>") ;
					out.println("</table>") ;

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
