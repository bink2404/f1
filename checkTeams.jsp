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

<title>fantasysportnet - Formula One</title>

</head>

<body bgcolor=white>

<center><a href="login.jsp?log=x&id=1"><img src="images/title2.jpg" alt="http://www.fantasysportnet.com" width="387" height="75" border="0"></a>
<a href="login.jsp?log=x&id=1"><img src="images/f12.gif" alt="http://www.fantasysportnet.com" width="100" height="75" border="0"></a><br>

<% 
	String url = "jdbc:mysql://localhost/fantas15_dbsql";
	String submit = request.getParameter("submit") ;
	ResultSet rs, rs1, rs2, rs3 ;
	int i, j ;
	int weekNum ;
	int finishPosition = 0 ;
	int qualifyPosition = 0 ;
	int fastestLap = 0 ;
	int score = 0 ;
	String firstName ;
	String raceTeamName ;
	String raceTeamName2 = "" ;
	String query ;
	int updatingFlag ;
	int userCount ;
	int LinesAffected ;
	int teamId ;
	int driverId ;
	int chosenCount ;
	int d1Id, d2Id, d3Id ;

	try
	{
		if ((session.getValue("sessionId") == "0") || (session.getValue("sessionId") == null))
		{
			out.println("<center>") ;

			out.println("<br><br>You are logged-out, please sign in to continue") ;
			out.println("<br><br><A HREF=\"login.jsp\">Sign In</A>") ;

			out.println("</center>") ;
		}
		else
		{
			Class.forName("org.gjt.mm.mysql.Driver") ;
		
			Connection con = DriverManager.getConnection(url, "fantas15_fsn2404", "doosie");

			java.sql.Statement stmt = con.createStatement();
			java.sql.Statement stmt2 = con.createStatement();
			java.sql.Statement stmt3 = con.createStatement();
			java.sql.Statement stmt4 = con.createStatement();
			java.sql.Statement stmt5 = con.createStatement();

			String strId = String.valueOf(session.getValue("sessionId")) ;

			if (Integer.parseInt(strId) != -1)
			{
				out.println("<center>") ;

				out.println("<br><br>You are not the admin") ;
				out.println("<br><br><A HREF=\"login.jsp?log=x&id=" + session.getValue("sessionId") + "\">Continue</A>") ;

				out.println("</center>") ;
			}
			else
			{
				out.println("<br>Calculating<br><br>") ;

				query = "SELECT weekNum FROM f1_admin WHERE weekNum > 0" ;

				rs = stmt.executeQuery(query);

				rs.next() ;

				weekNum = rs.getInt("weekNum") ;

				// Display any drivers or teams that have already been picked 5 times.
				query = "SELECT driver1Id, driver2Id, driver3Id, raceTeamName, teamId FROM f1_userteam WHERE teamId >= 1" ;

				rs2 = stmt4.executeQuery(query);

				while (rs2.next())
				{
					teamId = rs2.getInt("teamId") ;
					raceTeamName = rs2.getString("raceTeamName") ;

					driverId = rs2.getInt("driver1Id") ;
					d1Id = driverId ;
					chosenCount = 0 ;

					// Find the number of times this driver has already been chosen
					if (driverId != 0)
					{
						for (i = 1 ; i < weekNum ; i++)
						{
							query = "SELECT driver1Id, driver2Id, driver3Id FROM f1_userteam" + i + " WHERE teamId = " + teamId ;

							rs3 = stmt3.executeQuery(query);

							if (rs3.next())
							{
								if ((rs3.getInt("driver1Id") == driverId) || (rs3.getInt("driver2Id") == driverId) || 
									(rs3.getInt("driver3Id") == driverId))
								{
									chosenCount++ ;
								}
							}
						}

						if (chosenCount >= 5)
						{
							out.println("Driver " + driverId + " has been picked more than 5 times, team id = " + teamId + "<br>") ;
						}
					}

					driverId = rs2.getInt("driver2Id") ;
					d2Id = driverId ;
					chosenCount = 0 ;

					// Find the number of times this driver has already been chosen
					if (driverId != 0)
					{
						for (i = 1 ; i < weekNum ; i++)
						{
							query = "SELECT driver1Id, driver2Id, driver3Id FROM f1_userteam" + i + " WHERE teamId = " + teamId ;

							rs3 = stmt3.executeQuery(query);

							if (rs3.next())
							{
								if ((rs3.getInt("driver1Id") == driverId) || (rs3.getInt("driver2Id") == driverId) || 
									(rs3.getInt("driver3Id") == driverId))
								{
									chosenCount++ ;
								}
							}
						}
	
						if (chosenCount >= 5)
						{
							out.println("Driver " + driverId + " has been picked more than 5 times, team id = " + teamId + "<br>") ;
						}
					}

					driverId = rs2.getInt("driver3Id") ;
					d3Id = driverId ;
					chosenCount = 0 ;

					// Find the number of times this driver has already been chosen
					if (driverId != 0)
					{
						for (i = 1 ; i < weekNum ; i++)
						{
							query = "SELECT driver1Id, driver2Id, driver3Id FROM f1_userteam" + i + " WHERE teamId = " + teamId ;

							rs3 = stmt3.executeQuery(query);

							if (rs3.next())
							{
								if ((rs3.getInt("driver1Id") == driverId) || (rs3.getInt("driver2Id") == driverId) || 
									(rs3.getInt("driver3Id") == driverId))
								{
									chosenCount++ ;
								}
							}
						}

						if (chosenCount >= 5)
						{
							out.println("Driver " + driverId + " has been picked more than 5 times, team id = " + teamId + "<br>") ;
						}
					}

					chosenCount = 0 ;

					// Find the number of times this raceteam has already been chosen
					if ((raceTeamName != null) && (raceTeamName.length() > 0) && (!raceTeamName.equals("")))
					{
						for (i = 1 ; i < weekNum ; i++)
						{
							query = "SELECT raceTeamName FROM f1_userteam" + i + " WHERE teamId = " + teamId ;

							rs3 = stmt3.executeQuery(query);

							if (rs3.next())
							{
								raceTeamName2 = rs3.getString("raceTeamName") ;

								if ((raceTeamName2 != null) && (raceTeamName2.equals(raceTeamName)))
								{
									chosenCount++ ;
								}
							}
						}
	
						if (chosenCount >= 5)
						{
							out.println("Race Team " + raceTeamName + " has been picked more than 5 times, team id = " + teamId + "<br>") ;
						}
					}

					if (((d1Id != 0) && ((d1Id == d2Id) || (d1Id == d3Id))) ||
						((d2Id != 0) && ((d2Id == d1Id) || (d2Id == d3Id))) ||
						((d3Id != 0) && ((d3Id == d1Id) || (d3Id == d2Id))))
					{
						out.println("Drivers selected more than once, team id = " + teamId + "<br>") ;
					}
				}

				out.println("<br>Done") ;

				out.println("<br><br><A HREF=\"login.jsp?log=x&id=1\">Continue</A>") ;
			}
		}
	}
	catch (Exception e)
	{
		out.println("Problem reading the database<br>") ;
		out.println(e) ;
	}
%>

<br><br>

<table border="0" width="65%" height="1" cellpadding="4" cellspacing=0 align=center>
    <tr>
      <td width="50%" height="1" bgcolor="#FFFFFF" align=right vspace=0><font color="#000000" size=2><A HREF="help.html" target="_blank">Help</A></font></td>
	  <td width="50%" height="1" bgcolor="#FFFFFF" align=left vspace=0><font color="#000000" size=2><A HREF="mailto:support@fantasysportnet.com">Contact</A></font></td>
    </tr>
</table>

<img border=0 width=528 height=11 src="images/line.gif">

<br><font size=1.75>Copyright &copy; 2005 FantasySportNet. All
rights reserved.</font>

</center>
</div>
<p><center>
<br>
</center></p>

</body>

</html>