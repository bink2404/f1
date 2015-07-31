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
	String inUserId = request.getParameter("id") ;
	ResultSet rs, rs1, rs2 ;
	int weekNum ;
	int gId, tId ;

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
			if ((inUserId == null) || inUserId.equals(""))
			{
				out.println("<center>") ;

				out.println("<br>Enter the user i.d. whose teams you want to view") ;

				out.println("<form action=\"otherTeams.jsp\" method=\"post\" NAME=\"teamsForm\"><table><tr><td><b>i.d.</b>    <td><input type=\"text\" name=\"id\"></table><br><input type=\"submit\" value=\"Submit\"><tr><td>    <td></form>") ;

				out.println("</table>") ;

				out.println("<br><br>") ;

				out.println("</center>") ;
			}
			else
			{
				String query ;

%>
		<%@ include file="connection.txt" %>
<%

				java.sql.Statement stmt = con.createStatement();

				query = "SELECT name, userId, password FROM f1_user WHERE name = '" + inUserId + "'" ;

				rs = stmt.executeQuery(query);

				if (rs.next() == false)
				{
					out.println("<center>") ;

					out.println("<br>Enter the user i.d. whose teams you want to view") ;

					out.println("<form action=\"otherTeams.jsp\" method=\"post\" NAME=\"teamsForm\"><table><tr><td><b>i.d.</b>    <td><input type=\"text\" name=\"id\"></table><br><input type=\"submit\" value=\"Submit\"><tr><td>    <td></form>") ;

					if (!inUserId.equals("0"))
					{
						out.println("<font color=red>That i.d. does not exist</font>") ;
					}

					out.println("</center>") ;
				}
				else
				{
					java.sql.Statement stmt2 = con.createStatement();

					query = "SELECT weekNum FROM f1_admin WHERE weekNum > 0" ;

					rs2 = stmt2.executeQuery(query);

					rs2.next() ;

					weekNum = rs2.getInt("weekNum") ;

					int dbUserId = rs.getInt("userId") ;

					out.println("<b>" + rs.getString("name") + "'s teams</b><br><br>") ;

					query = "SELECT userTeamName, teamId, groupId FROM f1_userteam WHERE userId = " + dbUserId ;

					rs = stmt.executeQuery(query);
%>


<div align="center">
<center>
	<table border="0" width="65%" height="1" cellpadding="2">
    <tr>
      <td width="25%" height="1" bgcolor="#001480"><font color="#FFFFFF"><b>Teams</b></font></td>
	  <td width="15%" height="1" bgcolor="#001480"><font color="#FFFFFF"><b>Points</b></font></td>
      <td width="60%" height="1" bgcolor="#001480"><font color="#FFFFFF"><b>Leagues</b></font></td>
    </tr>

<% 
					java.sql.Statement stmt1 = con.createStatement();

					int totTeams ;
					int teamPos ;
					int count = 0 ;

					while (rs.next())
					{
						count++ ;

						gId = rs.getInt("groupId") ;
						tId = rs.getInt("teamId") ;

						out.println("<tr>") ;
							out.println("<td width=\"25%\" height=\"28\" bgcolor=\"#E0E0E0\"><A HREF=\"team.jsp?id=" + tId + "&weekNum=" + weekNum + "\">" + rs.getString("userTeamName") + "</A> </td>") ;

						query = "SELECT score FROM f1_userteam WHERE teamId = " + tId ; 

						rs1 = stmt1.executeQuery(query);

						rs1.next() ;
		
						out.println("<td width=\"15%\" height=\"28\" bgcolor=\"#E0E0E0\">" + rs1.getInt("score") + "</td>") ;

						query = "SELECT groupName, groupId FROM f1_groupname WHERE groupId = " + gId ;

						rs1 = stmt1.executeQuery(query);

						if (rs1.next())
						{
							out.println("<td width=\"60%\" height=\"28\" bgcolor=\"#E0E0E0\"><a href=\"group.jsp?id=" + rs1.getInt("groupId") + "\">" + rs1.getString("groupName") + "</A>") ;
						}

						// Find the team's position within the group
						query = "SELECT teamId, score FROM f1_userteam WHERE groupId = " + gId + " ORDER BY score DESC" ;

						if (gId != 0)
						{
							rs1 = stmt1.executeQuery(query);
						
							totTeams = 0 ;
							teamPos = 0 ;

							while (rs1.next())
							{
								totTeams++ ;

								if (rs1.getInt("teamId") == tId)
									teamPos = totTeams ;
							}

							out.println("Rank : " + teamPos + " of " + totTeams + "<br>") ;
						}
						else
						{
							out.println("<td width=\"60%\" height=\"28\" bgcolor=\"#E0E0E0\">") ;
						}

						// Find the team's overall position
						query = "SELECT teamId, score FROM f1_userteam WHERE groupId >= 0 ORDER BY score DESC" ;

						rs1 = stmt1.executeQuery(query);
						
						totTeams = 0 ;
						teamPos = 0 ;

						while (rs1.next())
						{
							totTeams++ ;

							if (rs1.getInt("teamId") == tId)
								teamPos = totTeams ;
						}

						out.println("Overall : " + teamPos + " of " + totTeams) ;

						out.println("</td>") ;
						out.println("</tr>") ;
					}

					if (count == 0)
					{
						// No teams, add an empty row
						out.println("<tr>") ;
						out.println("<td width=\"25%\" height=\"28\" bgcolor=\"#E0E0E0\">-</A>") ;
						out.println("</td>") ;
						out.println("<td width=\"15%\" height=\"28\" bgcolor=\"#E0E0E0\">-</A>") ;
						out.println("</td>") ;
						out.println("<td width=\"60%\" height=\"28\" bgcolor=\"#E0E0E0\">-</A>") ;
						out.println("</td>") ;
						out.println("</tr>") ;
					}

					out.println("<tr>") ;
					out.println("</tr>") ;
				}

				con.close() ;
			}
		}
	}
	catch (Exception e)
	{
		out.println("<br>Problem reading the database - try again later<br><br><br>") ;
		//out.println(e) ;
	}
%>
</P>

</table>

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


