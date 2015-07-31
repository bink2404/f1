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

<SCRIPT LANGUAGE="JavaScript">
 function putFocus(formInst, elementInst) {
  if (document.forms.length > 0) {
   document.forms[formInst].elements[elementInst].focus();
  }
 }
</script>

</head>

<body onLoad="putFocus(0,0);" bgcolor=white>

<center><a href="login.jsp?log=x&id=1"><img src="images/title2.jpg" alt="http://www.fantasysportnet.com" width="387" height="75" border="0"></a>
<a href="login.jsp?log=x&id=1"><img src="images/f12.gif" alt="http://www.fantasysportnet.com" width="100" height="75" border="0"></a>

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

<% 
	String url = "jdbc:odbc:db";

	String teamId = request.getParameter("id") ;
	int inWeekNum = Integer.parseInt(request.getParameter("weekNum")) ;
	ResultSet rs, rs1, rs2, rs3, rs4, rs5 ;
	int driverId ;
	int totalScore ;
	boolean ownTeam = false ;
	int weekNum ;
	String teamName ;
	String homeTeam, awayTeam ;
	String gName = new String("") ;
	int finishPosition = 0 ;
	int qualifyPosition = 0 ;
	int fastestLap = 0 ;
	int score = 0 ;
	String firstName ;
	String raceTeamName ;
	String location ;
	int	chosenCount ;
	int d1Id, d2Id, d3Id ;
	int j ;
	String tempName ;
	int seasonOver = 0 ;

	try
	{
		if ((session.getValue("sessionId") == "0") || (session.getValue("sessionId") == null))
		{
			out.println("<center>") ;

			out.println("<br><br>You are logged-out, please sign in to continue") ;
			out.println("<br><br><A HREF=\"login.jsp\">Sign In</A>") ;
		}
		else
		{
			Class.forName("sun.jdbc.odbc.JdbcOdbcDriver") ;
		
			Connection con = DriverManager.getConnection(url, "", "");

			java.sql.Statement stmt = con.createStatement();
			java.sql.Statement stmt5 = con.createStatement();
			java.sql.Statement stmt7 = con.createStatement();

			String query = "SELECT updating FROM f1_admin WHERE updating >= 0" ;

			rs = stmt.executeQuery(query);

			rs.next() ;

			if (rs.getInt("updating") == 1)
			{
				out.println("<center>") ;

				out.println("<table border=\"0\" width=\"65%\" height=\"1\" cellpadding=\"2\">") ;
					out.println("<tr>") ;
					out.println("<td width=\"50%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center><font color=\"#000000\"><A HREF=\"login.jsp?log=x&id=" + session.getValue("sessionId") + "\">Home</A></font></td>") ;
					out.println("<td width=\"50%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center><font color=\"#000000\"><A HREF=\"login.jsp\">Sign Out</A></font></td>") ;
					out.println("</tr>") ;
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

				if (weekNum != inWeekNum)
				{
					teamName = "f1_userteam" + inWeekNum ;
				}
				else
				{
					teamName = "f1_userteam" ;
				}

				query = "SELECT driver1Id, driver2Id, driver3Id, raceTeamName, groupId, userTeamName, userId FROM " + teamName + " WHERE teamId = " + teamId + " AND userId > 0" ;

				rs = stmt.executeQuery(query);

				if (rs.next())
				{
					int gId = rs.getInt("groupId") ;

					out.println("<center>") ;

					query = "SELECT groupName FROM f1_groupname WHERE groupId = " + gId ;

					java.sql.Statement stmt3 = con.createStatement();

					rs2 = stmt3.executeQuery(query);

					String strId = String.valueOf(session.getValue("sessionId")) ;

					if (Integer.parseInt(strId) == rs.getInt("userId"))
					{
						ownTeam = true ;
					}

					out.println("<table border=\"0\" width=\"100%\" height=\"1\" cellpadding=\"2\">") ;
					out.println("<tr>") ;

					if (rs2.next())
					{
						gName = rs2.getString("groupName") ;

						if ((ownTeam == true) && (weekNum == inWeekNum) && (seasonOver == 0))
						{
							out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center><font color=\"#000000\"><A HREF=\"removeFromGroup.jsp?id=" + teamId + "\">" + "Remove team from this league</A></font></td>") ;
						}
					}
					else
					{
						if ((ownTeam == true) && (weekNum == inWeekNum) && (seasonOver == 0))
						{
							out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center><font color=\"#000000\"><A HREF=\"addToGroup.jsp?id=" + teamId + "\">" + "Join a private league</A></font></td>") ;
							out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center><font color=\"#000000\"><A HREF=\"addToPublicGroup.jsp?id=" + teamId + "\">" + "Join a public league</A></font></td>") ;
						}
					}

					if (ownTeam == true)
					{
						out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center><font color=\"#000000\"><A HREF=\"deleteTeam.jsp?id=" + teamId + "\">" + "Delete this team</A></font></td>") ;
					}

					out.println("</tr>") ;
					out.println("</table>") ;

					if (!"".equals(gName))
					{
						out.println("<br><A HREF=\"group.jsp?id=" + gId + "\">" + gName + "</A>") ;
					}

					out.println("<table border=\"0\" width=\"33%\" height=\"1\" cellpadding=\"2\">") ;
					out.println("<tr>") ;

					// Find the location of the week's race
					query = "SELECT location FROM f1_schedule WHERE weekNum = " + inWeekNum ;

					java.sql.Statement stmt6 = con.createStatement();

					rs3 = stmt6.executeQuery(query);
					
					if (rs3.next())
					{
						location = rs3.getString("location") ;

						out.println("<br>") ;

						if (weekNum == inWeekNum)
						{
							if (weekNum > 1)
							{
								out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=right><font color=\"#000000\"><A HREF=\"team.jsp?id=" + teamId + "&weekNum=" + (weekNum-1) + "\">Previous</A></font></td>") ;
								out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center><font color=\"#000000\"><b>" + location + "</b></font></td>") ;
								out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=left><font color=\"#000000\"></font></td>") ;
							}
							else
							{
								out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=right><font color=\"#000000\"></font></td>") ;
								out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center><font color=\"#000000\"><b>" + location + "</b></font></td>") ;
								out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=left><font color=\"#000000\"></font></td>") ;
							}
						}
						else
						{
							if (inWeekNum == 1)
							{
								out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=right><font color=\"#000000\"></font></td>") ;
								out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center><font color=\"#000000\"><b>" + location + "</b></font></td>") ;
								out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=left><font color=\"#000000\"><A HREF=\"team.jsp?id=" + teamId + "&weekNum=2\">Next</A></font></td>") ;
							}
							else
							{
								out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=right><font color=\"#000000\"><A HREF=\"team.jsp?id=" + teamId + "&weekNum=" + (inWeekNum-1) + "\">Previous</A></font></td>") ;
								out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center><font color=\"#000000\"><b>" + location + "</b></font></td>") ;
								out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=left><font color=\"#000000\"><A HREF=\"team.jsp?id=" + teamId + "&weekNum=" + (inWeekNum+1) + "\">Next</A></font></td>") ;
							}
						}	
					}
					else
					{
						// The season has finished
						seasonOver = 1 ;
						weekNum = 18 ;
						location = "Interlagos" ;

						out.println("<br>") ;

						out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=right><font color=\"#000000\"><A HREF=\"team.jsp?id=" + teamId + "&weekNum=" + (weekNum-1) + "\">Previous</A></font></td>") ;
						out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center><font color=\"#000000\"><b>" + location + "</b></font></td>") ;
						out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=left><font color=\"#000000\"></font></td>") ;
					}

					out.println("</tr>") ;
					out.println("</table>") ;

					out.println("<table border=\"0\" width=\"100%\" height=\"1\" cellpadding=\"2\">") ;
						out.println("<tr>") ;

						if ((weekNum == inWeekNum) && (ownTeam == true) && (seasonOver == 0))
						{
							out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=left><font color=\"#000000\"><A HREF=\"login.jsp?log=x&id=" + session.getValue("sessionId") + "\">Home</A></font></td>") ;
							out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center><font color=\"#000000\"><A HREF=\"changeTeamName.jsp?teamid=" + teamId + "\">Change team name</A></font></td>") ;
							out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=right><font color=\"#000000\"><A HREF=\"login.jsp\">Sign Out</A></font></td>") ;
						}
						else
						{
							out.println("<td width=\"50%\" height=\"1\" bgcolor=\"#FFFFFF\" align=left><font color=\"#000000\"><A HREF=\"login.jsp?log=x&id=" + session.getValue("sessionId") + "\">Home</A></font></td>") ;
							out.println("<td width=\"50%\" height=\"1\" bgcolor=\"#FFFFFF\" align=right><font color=\"#000000\"><A HREF=\"login.jsp\">Sign Out</A></font></td>") ;	
						}

						out.println("</tr>") ;
					out.println("</table>") ;

					out.println("<table border=\"0\" width=\"100%\" height=\"1\" cellpadding=\"2\">") ;
						out.println("<tr>") ;
						out.println("<td width=\"100%\" height=\"1\" bgcolor=\"#001480\" align=center><font color=\"#FFFFFF\"><strong>" + rs.getString("userTeamName") + "</strong></font></td>") ;
						out.println("</tr>") ;
					out.println("</table>") ;

					java.sql.Statement stmt2 = con.createStatement();

					totalScore = 0 ;

					if ((inWeekNum < weekNum) || (ownTeam == true) || (seasonOver == 1))
					{
						out.println("<table width=\"100%\">") ;

						out.println("<tr>") ;

						out.println("<td width=\"250\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Drivers</b></font></td>") ;

						if (weekNum == inWeekNum)
						{
							out.println("<td width=\"70\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Selected</b></font></td>") ;
						}

						out.println("<td width=\"30\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Qualifying</b></font></td>") ;
						out.println("<td width=\"30\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Race</b></font></td>") ;
						out.println("<td width=\"70\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Fastest Lap</b></font></td>") ;

						out.println("<td width=\"30\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Total</b></font></td>") ;

						out.println("</tr>") ;

						for (int i = 1 ; i <= 3 ; i++)
						{
							out.println("<tr>") ;
							out.println("<td width=\"250\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>") ;

							driverId = rs.getInt("driver" + i + "Id") ;

							query = "SELECT driverFirstName, driverLastName, raceTeamName FROM f1_driver WHERE driverId = " + driverId ;

							rs1 = stmt2.executeQuery(query);

							if (rs1.next())
							{
								if ((ownTeam == true) && (weekNum == inWeekNum) && (seasonOver == 0))
								{
									out.println("<A HREF=\"editDriver.jsp?driverId=" + driverId + "&teamId=" + teamId + "&pos=" + i + "\">edit</A>") ;
								}

								firstName = rs1.getString("driverFirstName") ;
								String tName = rs1.getString("raceTeamName") ;

								if ((firstName != null) && (!firstName.equals("")))
								{
									out.println(rs1.getString("driverLastName") + ", " + firstName + " (" + tName + ") ") ;
								}
								else
								{
									out.println(rs1.getString("driverLastName") + " (" + tName + ") ") ;
								}

								out.println("<a href=\"graphs.jsp?id=" + driverId + "&team=" + teamId + "\"><img src=\"images/graphs.gif\" alt=\"performance\" width=\"13\" height=\"14\" border=\"0\"></a>") ;

								out.println("</td>") ;

								// Get the appropriate stats to display
								if (weekNum != inWeekNum)
								{
									query = "SELECT finishPosition, qualifyPosition, fastestLap, score FROM f1_driver" + inWeekNum + " WHERE driverId = " + driverId ;
								}
								else
								{
									query = "SELECT finishPosition, qualifyPosition, fastestLap, score FROM f1_driver WHERE driverId = " + driverId ;
								}

								rs4 = stmt5.executeQuery(query);

								if (rs4.next())
								{
									finishPosition = rs4.getInt("finishPosition") ;
									qualifyPosition = rs4.getInt("qualifyPosition") ;
									fastestLap = rs4.getInt("fastestLap") ;
									score = rs4.getInt("score") ;

									totalScore += score ;
								}

								if (weekNum == inWeekNum)
								{
									chosenCount = 0 ;

									// Find the number of times this driver has already been chosen
									for (j = 1 ; j < weekNum ; j++)
									{
										query = "SELECT driver1Id, driver2Id, driver3Id FROM f1_userteam" + j + " WHERE teamId = " + teamId ;

										rs5 = stmt7.executeQuery(query);

										if (rs5.next())
										{
											d1Id = rs5.getInt("driver1Id") ;
											d2Id = rs5.getInt("driver2Id") ;
											d3Id = rs5.getInt("driver3Id") ;

											if ((d1Id == driverId) || (d2Id == driverId) || (d3Id == driverId))
											{
												chosenCount++ ;
											}
										}
									}

									// Take into account the current selection
									if (chosenCount < 5)
									{
										chosenCount++ ;
									}

									out.println("<td width=\"70\" height=\"1\" bgcolor=\"#E0E0E0\"><font size=2.5>" + chosenCount + " of 5</td>") ;
								}

								out.println("<td width=\"30\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>" + qualifyPosition + "</td>") ;
								out.println("<td width=\"30\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>" + finishPosition + "</td>") ;
								out.println("<td width=\"70\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>" + fastestLap + "</td>") ;
								out.println("<td width=\"30\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>" + score + "</td>") ;
							}
							else
							{
								// Empty position
								if ((ownTeam == true) && (weekNum == inWeekNum) && (seasonOver == 0))
								{
									out.println("<A HREF=\"editDriver.jsp?driverId=0&teamId=" + teamId + "&pos=" + i + "\">edit</A>") ;
								}

								out.println("[Empty]") ;

								out.println("</td>") ;

								if (weekNum == inWeekNum)
								{
									out.println("<td width=\"70\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>-</td>") ;
								}

								out.println("<td width=\"30\" height=\"1\" bgcolor=\"#E0E0E0\"><font size=2.5>-</td>") ;
								out.println("<td width=\"30\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>-</td>") ;
								out.println("<td width=\"70\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>-</td>") ;
								out.println("<td width=\"30\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>-</td>") ;
							}

							out.println("</tr>") ;
						}

						// Now display team information
						out.println("<tr>") ;

						out.println("<td width=\"250\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Constructor</b></font></td>") ;

						if (weekNum == inWeekNum)
						{
							out.println("<td width=\"70\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Selected</b></font></td>") ;
						}

						out.println("<td width=\"30\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Qualifying</b></font></td>") ;
						out.println("<td width=\"30\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Race</b></font></td>") ;
						out.println("<td width=\"70\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Fastest Lap</b></font></td>") ;

						out.println("<td width=\"30\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Total</b></font></td>") ;

						out.println("</tr>") ;

						raceTeamName = rs.getString("raceTeamName") ;

						out.println("<tr>") ;
						out.println("<td width=\"250\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>") ;

						if ((raceTeamName == null) || ("".equals(raceTeamName)) || (" ".equals(raceTeamName)))
						{
							// Empty position
							if ((ownTeam == true) && (weekNum == inWeekNum) && (seasonOver == 0))
							{
								out.println("<A HREF=\"editTeam.jsp?name=null&teamId=" + teamId + "\">edit</A>") ;
							}

							out.println("[Empty]") ;

							out.println("</td>") ;

							if (weekNum == inWeekNum)
							{
								out.println("<td width=\"70\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>-</td>") ;
							}

							out.println("<td width=\"30\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>-</td>") ;
							out.println("<td width=\"30\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>-</td>") ;
							out.println("<td width=\"70\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>-</td>") ;
							out.println("<td width=\"30\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>-</td>") ;
						}
						else
						{
							if ((ownTeam == true) && (weekNum == inWeekNum) && (seasonOver == 0))
							{
								out.println("<A HREF=\"editTeam.jsp?name=" + raceTeamName + "&teamId=" + teamId + "\">edit</A>") ;
							}

							out.println(raceTeamName) ;

							out.println("<a href=\"teamGraphs.jsp?name=" + raceTeamName + "&team=" + teamId + "\"><img src=\"images/graphs.gif\" alt=\"performance\" width=\"13\" height=\"14\" border=\"0\"></a>") ;

							out.println("</td>") ;

							// Get the appropriate stats to display
							if (weekNum != inWeekNum)
							{
								query = "SELECT finishPosition, qualifyPosition, fastestLap, score FROM f1_raceteam" + inWeekNum + " WHERE raceTeamName = '" + raceTeamName + "'" ;
							}
							else
							{
								query = "SELECT finishPosition, qualifyPosition, fastestLap, score FROM f1_raceteam WHERE raceTeamName = '" + raceTeamName + "'" ;
							}

							rs4 = stmt5.executeQuery(query);

							if (rs4.next())
							{
								finishPosition = rs4.getInt("finishPosition") ;
								qualifyPosition = rs4.getInt("qualifyPosition") ;
								fastestLap = rs4.getInt("fastestLap") ;
								score = rs4.getInt("score") ;

								totalScore += score ;
							}

							if (weekNum == inWeekNum)
							{
								chosenCount = 0 ;

								// Find the number of times this raceTeam has already been chosen
								for (j = 1 ; j < weekNum ; j++)
								{
									query = "SELECT raceTeamName FROM f1_userteam" + j + " WHERE teamId = " + teamId ;

									rs5 = stmt7.executeQuery(query);

									if (rs5.next())
									{
										tempName = rs5.getString("raceTeamName") ;

										if ((tempName != null) && tempName.equals(raceTeamName))
										{
											chosenCount++ ;
										}
									}
								}

								// Take into account the current selection
								if (chosenCount < 5)
								{
									chosenCount++ ;
								}

								out.println("<td width=\"70\" height=\"1\" bgcolor=\"#E0E0E0\"><font size=2.5>" + chosenCount + " of 5</td>") ;
							}

							out.println("<td width=\"30\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>" + qualifyPosition + "</td>") ;
							out.println("<td width=\"30\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>" + finishPosition + "</td>") ;
							out.println("<td width=\"70\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>" + fastestLap + "</td>") ;
							out.println("<td width=\"30\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>" + score + "</td>") ;
						}

						out.println("</tr>") ;
						out.println("</table>") ;

						if (inWeekNum < weekNum)
						{
							out.println("<table border=\"0\" width=\"100%\" height=\"1\" cellpadding=\"2\">") ;
							out.println("<tr>") ;

							out.println("<td width=\"100%\" height=\"1\" bgcolor=\"#FFFFFF\" align=right><font color=\"#000000\"><strong>Score: " + totalScore + "</strong></font></td>") ;
							out.println("</tr>") ;
							out.println("</table>") ;
						}
					}
					else
					{
						out.println("<center>") ;

						out.println("<br><br>You cannot view this team until the deadline passes for this race.") ;

						out.println("<br><br><A HREF=\"login.jsp?log=x&id=" + session.getValue("sessionId") + "\">Continue</A>") ;
					}

					out.println("</center>") ;
				}
				else
				{
					out.println("<center>") ;

					out.println("<br><br>No information found for this team for this week.") ;
					out.println("<br><br><A HREF=\"login.jsp?log=x&id=" + session.getValue("sessionId") + "\">Continue</A>") ;

					out.println("</center>") ;
				}	
			}
		}
	}	
	catch (Exception e)
	{
		out.println("Problem reading the database") ;
		out.println(e) ;
	}
%>

<br>Search for driver and team news ...<br>

<!-- Search Google -->
<center>
<form method="get" action="http://www.google.com/custom" target="google_window">
<table bgcolor="#ffffff">
<tr><td nowrap="nowrap" valign="top" align="left" height="32">

<input type="text" name="q" size="20" maxlength="255" value=""></input>
<input type="submit" name="sa" value="Google Search"></input>
<input type="hidden" name="client" value="pub-9229293934937598"></input>
<input type="hidden" name="forid" value="1"></input>
<input type="hidden" name="ie" value="ISO-8859-1"></input>
<input type="hidden" name="oe" value="ISO-8859-1"></input>
<input type="hidden" name="cof" value="GALT:#008000;GL:1;DIV:#336699;VLC:663399;AH:center;BGC:FFFFFF;LBGC:0033CC;ALC:0000FF;LC:0000FF;T:000000;GFNT:0000FF;GIMP:0000FF;FORID:1;"></input>
<input type="hidden" name="hl" value="en"></input>
</td></tr></table>
</form>
</center>
<!-- Search Google -->

<br>
<br>

<table border="0" width="65%" height="1" cellpadding="4" cellspacing=0 align=center>
    <tr>
      <td width="50%" height="1" bgcolor="#FFFFFF" align=right vspace=0><font color="#000000" size=2><A HREF="help.html" target="_blank">Help</A></font></td>
	  <td width="50%" height="1" bgcolor="#FFFFFF" align=left vspace=0><font color="#000000" size=2><A HREF="mailto:support@fantasysportnet.com">Contact</A></font></td>
    </tr>
</table>

<img border=0 width=528 height=11 src="images/line.gif">

<br><font size=1.75>Copyright &copy; 2006 fantasysportnet. All
rights reserved.</font>

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

