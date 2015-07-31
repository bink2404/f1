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

<b>Top 50</b><br><br></center>
<div align="center">
<center>
	<table border="0" width="65%" height="1" cellpadding="2">
    <tr>
      <td width="15%" height="1" bgcolor="#001480"><font color="#FFFFFF"><b>Rank</b></font></td>
      <td width="70%" height="1" bgcolor="#001480"><font color="#FFFFFF"><b>Name</b></font></td>
      <td width="15%" height="1" bgcolor="#001480"><font color="#FFFFFF"><b>Score</b></font></td>
    </tr>

<%@ include file="url.txt" %>

<% 
	String groupId = request.getParameter("id") ;
	ResultSet rs, rs1, rs2 ;
	int weekNum ;
	int score ;

	try
	{
		if ((session.getValue("sessionId") == "0") || (session.getValue("sessionId") == null))
		{
			out.println("</table>") ;

			out.println("<center>") ;

			out.println("<br><br>You are logged-out, please sign in to continue") ;
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

				out.println("</table>") ;

				out.println("<br><br>The database is being updated, please try again later") ;

				out.println("</center>") ;
			}
			else
			{
				query = "SELECT weekNum FROM f1_admin WHERE weekNum > 0" ;

				rs = stmt.executeQuery(query);

				rs.next() ;

				weekNum = rs.getInt("weekNum") ;

				query = "SELECT userTeamName, teamId, score, userId FROM f1_userteam WHERE groupId >= 0 ORDER BY score DESC" ;

				rs1 = stmt.executeQuery(query);

				int pos = 1 ;

				while (rs1.next())
				{
					score = rs1.getInt("score") ;

					out.println("<tr>") ;

						if (rs1.getInt("userId") == Integer.parseInt(String.valueOf(session.getValue("sessionId"))))
						{
							out.println("<td width=\"15%\" height=\"28\" bgcolor=\"#B5B5B5\">") ;
							out.println(pos + ".</td>") ;
							out.println("<td width=\"70%\" height=\"28\" bgcolor=\"#B5B5B5\"><A HREF=\"team.jsp?id=" + rs1.getString("teamId") + "&weekNum=" + weekNum + "\">" + rs1.getString("userTeamName") + "</A> </td>") ;
							out.println("<td width=\"15%\" height=\"28\" bgcolor=\"#B5B5B5\">" + score + "</td>") ;
						}
						else
						{
							out.println("<td width=\"15%\" height=\"28\" bgcolor=\"#E0E0E0\">") ;
							out.println(pos + ".</td>") ;
							out.println("<td width=\"70%\" height=\"28\" bgcolor=\"#E0E0E0\"><A HREF=\"team.jsp?id=" + rs1.getString("teamId") + "&weekNum=" + weekNum + "\">" + rs1.getString("userTeamName") + "</A> </td>") ;
							out.println("<td width=\"15%\" height=\"28\" bgcolor=\"#E0E0E0\">" + score + "</td>") ;
						}
					out.println("</tr>") ;

					pos++ ;

					if (pos > 50)
					{
						break ;
					}
				}

				out.println("</table>") ;
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
