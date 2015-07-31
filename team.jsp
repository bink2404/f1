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
<br>

<div align="center">
<center>

<%@ include file="url.txt" %>

<% 
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
	String tempName ;
	StringBuffer temp ;
	String deadline ;
	int year = 0 ;
	int month = 0 ;
	int day = 0 ;
	StringBuffer AMPM = new StringBuffer() ;
	int hour = 0 ;
	int minute = 0 ;
	int second = 0 ;
	int dyear = 0 ;
	int dmonth = 0 ;
	int dday = 0 ;
	StringBuffer dAMPM = new StringBuffer() ;
	int dhour = 0 ;
	int dminute = 0 ;
	int dsecond = 0 ;
	String[] months = new String[12] ;
	int j = 0 ;
	int k = 0 ;

	try
	{
		if ((session.getValue("sessionId") == "0") || (session.getValue("sessionId") == null))
		{
			out.println("<center>") ;

			out.println("<br><br>You are logged-out, please sign in to continue<br><br>") ;
		}
		else
		{
			months[0] = "Jan" ;
			months[1] = "Feb" ;
			months[2] = "Mar" ;
			months[3] = "Apr" ;
			months[4] = "May" ;
			months[5] = "Jun" ;
			months[6] = "Jul" ;
			months[7] = "Aug" ;
			months[8] = "Sep" ;
			months[9] = "Oct" ;
			months[10] = "Nov" ;
			months[11] = "Dec" ;

%>
		<%@ include file="connection.txt" %>
<%

			java.sql.Statement stmt = con.createStatement();
			java.sql.Statement stmt5 = con.createStatement();
			java.sql.Statement stmt7 = con.createStatement();

			String query = "SELECT updating, deadline FROM f1_admin WHERE updating >= 0" ;

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
				// Compare the date / time with the deadline
				deadline = rs.getString("deadline") ;

				if ((deadline != null) && !deadline.equals(""))
				{
					// Get the date/time and convert it to GMT 
					java.text.DateFormat format = java.text.DateFormat.getDateTimeInstance( 
					                java.text.DateFormat.MEDIUM, java.text.DateFormat.MEDIUM); 

					format.setCalendar(java.util.Calendar.getInstance(java.util.TimeZone.getTimeZone("Europe/London"))); 

					java.util.Date date = new java.util.Date(); 
    
					String s = format.format(date) ;

					temp = new StringBuffer() ;

					// Get the date / time int's
					for (j = 0 ; j < 80 ; j++)
					{
						if (s.charAt(j) != ' ')
						{
							temp.append(s.charAt(j)) ;
						}
						else
						{
							break ;
						}
					}

					for (k = 0 ; k < 12 ; k++)
					{
						if (temp.toString().equals(months[k]))
						{
							break ;
						}
					}

					month = k + 1 ;

					temp = new StringBuffer() ;
					j++ ;

					for ( ; j < 80 ; j++)
					{
						if (s.charAt(j) != ',')
						{
							temp.append(s.charAt(j)) ;
						}
						else
						{
							break ;
						}
					}

					day = Integer.valueOf(temp.toString()).intValue() ;

					temp = new StringBuffer() ;
					j += 2 ;

					for ( ; j < 80 ; j++)
					{
						if (s.charAt(j) != ' ')
						{
							temp.append(s.charAt(j)) ;
						}
						else
						{
							break ;
						}
					}

					year = Integer.valueOf(temp.toString()).intValue() ;

					temp = new StringBuffer() ;
					j++ ;

					for ( ; j < 80 ; j++)
					{
						if (s.charAt(j) != ':')
						{
							temp.append(s.charAt(j)) ;
						}
						else
						{
							break ;
						}
					}

					hour = Integer.valueOf(temp.toString()).intValue() ;

					temp = new StringBuffer() ;
					j++ ;

					for ( ; j < 80 ; j++)
					{
						if (s.charAt(j) != ':')
						{
							temp.append(s.charAt(j)) ;
						}
						else
						{
							break ;
						}
					}

					minute = Integer.valueOf(temp.toString()).intValue() ;

					temp = new StringBuffer() ;
					j++ ;

					for ( ; j < 80 ; j++)
					{
						if (s.charAt(j) != ' ')
						{
							temp.append(s.charAt(j)) ;
						}
						else
						{
							break ;
						}
					}

					second = Integer.valueOf(temp.toString()).intValue() ;

					temp = new StringBuffer() ;
					j++ ;

					for (k = 0 ; k < 2 ; k++, j++)
					{
						temp.append(s.charAt(j)) ;
					}

					AMPM = temp ;

					// Daylight savings
/*					if (hour < 12)
					{
						hour++ ;
					}
					else
					{
						hour = 1 ;
					}

					if (hour == 12)
					{
						if (AMPM.toString().equals("PM"))
						{
							AMPM = new StringBuffer("AM") ;
							day++ ;
						}
						else
						{
							AMPM = new StringBuffer("PM") ;
						}
					} */

					//out.println(month + " " + day + " " + year + " " + hour + " " + minute + " " + second + " " + AMPM) ;

					temp = new StringBuffer() ;

					// Get the date / time int's
					for (j = 0 ; j < 80 ; j++)
					{
						if (deadline.charAt(j) != ' ')
						{
							temp.append(deadline.charAt(j)) ;
						}
						else
						{
							break ;
						}
					}

					for (k = 0 ; k < 12 ; k++)
					{
						if (temp.toString().equals(months[k]))
						{
							break ;
						}
					}

					dmonth = k + 1 ;

					temp = new StringBuffer() ;
					j++ ;

					for ( ; j < 80 ; j++)
					{
						if (deadline.charAt(j) != ',')
						{
							temp.append(deadline.charAt(j)) ;
						}
						else
						{
							break ;
						}
					}

					dday = Integer.valueOf(temp.toString()).intValue() ;

					temp = new StringBuffer() ;
					j += 2 ;

					for ( ; j < 80 ; j++)
					{
						if (deadline.charAt(j) != ' ')
						{
							temp.append(deadline.charAt(j)) ;
						}
						else
						{
							break ;
						}
					}

					dyear = Integer.valueOf(temp.toString()).intValue() ;

					temp = new StringBuffer() ;
					j++ ;

					for ( ; j < 80 ; j++)
					{
						if (deadline.charAt(j) != ':')
						{
							temp.append(deadline.charAt(j)) ;
						}
						else
						{
							break ;
						}
					}

					dhour = Integer.valueOf(temp.toString()).intValue() ;

					temp = new StringBuffer() ;
					j++ ;

					for ( ; j < 80 ; j++)
					{
						if (deadline.charAt(j) != ':')
						{
							temp.append(deadline.charAt(j)) ;
						}
						else
						{
							break ;
						}
					}

					dminute = Integer.valueOf(temp.toString()).intValue() ;

					temp = new StringBuffer() ;
					j++ ;

					for ( ; j < 80 ; j++)
					{
						if (deadline.charAt(j) != ' ')
						{
							temp.append(deadline.charAt(j)) ;
						}
						else
						{
							break ;
						}
					}

					dsecond = Integer.valueOf(temp.toString()).intValue() ;

					temp = new StringBuffer() ;
					j++ ;

					for (k = 0 ; k < 2 ; k++, j++)
					{
						temp.append(deadline.charAt(j)) ;
					}

					dAMPM = temp ;

					//out.println(dmonth + " " + dday + " " + dyear + " " + dhour + " " + dminute + " " + dsecond + " " + dAMPM) ;
				}

				if ((year > dyear) ||
					((month == 1) && (dmonth == 12)) || 
					((day > dday) && (month == dmonth) && (year == dyear)) || 
					((day == dday) && (month == dmonth) && (year == dyear) && (AMPM.toString().equals("PM") && dAMPM.toString().equals("AM"))) || 
					((day == dday) && (month == dmonth) && (year == dyear) && AMPM.toString().equals(dAMPM.toString()) && (((hour > dhour) && (hour != 12)) || ((hour != 12) && (dhour == 12)) || (((hour == dhour) && (minute > dminute)) || ((hour == dhour) && (minute == dminute) && (second > dsecond))))))
				{
					query = "UPDATE f1_admin SET updating = 1 WHERE updating >= 0" ;

					stmt.executeUpdate(query);

					out.println("<center>") ;

					out.println("<br><br>The database is being updated, please try again later<br><br>") ;

					out.println("</center>") ;
				}
				else
				{
					// Check to see if the deadline is close
					if ((year == dyear) && (month == dmonth) && (day == dday) && 
						((AMPM.toString().equals(dAMPM.toString()) && ((hour >= (dhour - 2) && (hour != 12)) || ((hour == 12) && (dhour <= 2)))) ||
						(dAMPM.toString().equals("PM") && AMPM.toString().equals("AM") && ((hour >= 10 && (hour != 12)) && ((dhour <= 2) || (dhour == 12))))))
					{
						query = "UPDATE f1_admin SET closeToDeadLine = 1 WHERE updating >= 0" ;

						stmt.executeUpdate(query);
					}

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

						if (ownTeam == true)
						{
							out.println("<td width=\"100%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center colspan=\"25\"><font color=\"#000000\" size=2><b>Admin&nbsp;:&nbsp;&nbsp;</b></font>") ;
						}

						if (rs2.next())
						{
							gName = rs2.getString("groupName") ;

							if ((ownTeam == true) && (weekNum == inWeekNum))
							{
								out.println("<font color=\"#000000\" size=2><A HREF=\"removeFromGroup.jsp?id=" + teamId + "\">" + "Remove team from this league</A>&nbsp;&nbsp;</font>") ;
							}
						}
						else
						{
							if ((ownTeam == true) && (weekNum == inWeekNum))
							{
								out.println("<font color=\"#000000\" size=2><A HREF=\"addToGroup.jsp?id=" + teamId + "\">" + "Join a private league</A>&nbsp;&nbsp;</font>") ;
								out.println("<font color=\"#000000\" size=2><A HREF=\"addToPublicGroup.jsp?id=" + teamId + "\">" + "Join a public league</A>&nbsp;&nbsp;</font>") ;
							}
						}

						if (ownTeam == true)
						{
							out.println("<font color=\"#000000\" size=2><A HREF=\"deleteTeam.jsp?id=" + teamId + "\">" + "Delete this team</A>&nbsp;&nbsp;</font>") ;

							if (weekNum == inWeekNum)
							{
								out.println("<font color=\"#000000\" size=2><A HREF=\"changeTeamName.jsp?teamid=" + teamId + "\">Change team name</A></font>") ;
							}
						}

						out.println("</td></tr>") ;
						out.println("</table><br><br>") ;

						if (!"".equals(gName))
						{
							out.println("<A HREF=\"group.jsp?id=" + gId + "\">" + gName + "</A>") ;
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
							location = "Season over" ;

							out.println("<br>") ;

							out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=right><font color=\"#000000\"><A HREF=\"team.jsp?id=" + teamId + "&weekNum=" + (weekNum-1) + "\">Previous</A></font></td>") ;
							out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center><font color=\"#000000\"><b>" + location + "</b></font></td>") ;
							out.println("<td width=\"33%\" height=\"1\" bgcolor=\"#FFFFFF\" align=left><font color=\"#000000\"></font></td>") ;
						}

						out.println("</tr>") ;
						out.println("</table>") ;

						out.println("<table border=\"0\" width=\"100%\" height=\"1\" cellpadding=\"2\">") ;
							out.println("<tr>") ;
							out.println("<td width=\"100%\" height=\"1\" bgcolor=\"#001480\" align=center><font color=\"#FFFFFF\"><strong>" + rs.getString("userTeamName") + "</strong></font></td>") ;
							out.println("</tr>") ;
						out.println("</table>") ;

						if (location.equals("Season over"))
						{
							out.println("<br><br><b>") ;

							out.println("Total points = ") ;
	
							query = "SELECT score FROM f1_userteam WHERE teamId = " + teamId ;

							rs5 = stmt7.executeQuery(query);

							rs5.next() ;

							out.println(rs5.getInt("score")) ;

							out.println("<br><br></b>") ;
						}
						else
						{
							java.sql.Statement stmt2 = con.createStatement();

							totalScore = 0 ;

							if ((inWeekNum < weekNum) || (ownTeam == true))
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
										if ((ownTeam == true) && (weekNum == inWeekNum))
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
										if ((ownTeam == true) && (weekNum == inWeekNum))
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
									if ((ownTeam == true) && (weekNum == inWeekNum))
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
									if ((ownTeam == true) && (weekNum == inWeekNum))
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
	}	
	catch (Exception e)
	{
		out.println("<br>Problem reading the database - try again later<br><br><br>") ;
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
