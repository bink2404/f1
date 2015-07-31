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

<div align="center">
<center>

<%@ include file="url.txt" %>

<% 
	String teamName = request.getParameter("name") ;
	String teamId = request.getParameter("teamId") ;
	String changeId = request.getParameter("id") ;
	String submit = request.getParameter("submit") ;
	ResultSet rs, rs2 ;
	int tId ;
	String currentTeamName ;
	int i ;
	String query ;
	int weekNum ;
	int finishPosition = 0 ;
	int qualifyPosition = 0 ;
	int fastestLap = 0 ;
	int score = 0 ;
	String firstName ;
	String lastName ;
	String raceTeamName ;
	String tempName ;
	int		chosenCount ;
	boolean validEdit = true ;
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

			out.println("</center>") ;
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
			java.sql.Statement stmt2 = con.createStatement();

			query = "SELECT updating, deadline FROM f1_admin WHERE updating >= 0" ;

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

					if (((changeId == null) || (changeId.equals(""))) || (submit == null))
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

								out.println("</center>") ;
							}
							else
							{
								out.println("<center>") ;

								out.println("<A HREF=\"team.jsp?id=" + teamId + "&weekNum=" + weekNum + "\">Return to team page</A>") ;

								query = "SELECT raceTeamName  FROM f1_userteam WHERE teamId = " + teamId ;

								rs = stmt.executeQuery(query);

								rs.next() ;

								currentTeamName = rs.getString("raceTeamName") ;
								
								// Display the team being changed
								if ((teamName != null) && (!teamName.equals("")) && (!teamName.equals("null")) && (!teamName.equals(" ")))
								{
									out.println("<table border=\"0\" width=\"100%\" height=\"1\" cellpadding=\"2\">") ;
									out.println("<tr>") ;

									out.println("<td width=\"100%\" height=\"1\" bgcolor=\"#FFFFFF\" align=left><b><font color=\"#000000\" size=2.5>" + currentTeamName + "</font></b></td>") ;

									out.println("</tr>") ;

									out.println("</table>") ;
								}

								out.println("<form action=\"editTeam.jsp\" method=\"post\">") ;

								out.println("<input type=\"submit\" name=\"submit\" value=\"Submit\"><br><br>") ;

								out.println("<table border=\"0\" width=\"100%\" height=\"1\" cellpadding=\"2\">") ;

								out.println("<td width=\"100%\" height=\"1\" bgcolor=\"#001480\" align=center><font color=\"#FFFFFF\"><b>Constructors</b></font></td>") ;
								
								out.println("</table>") ;

								out.println("<table width=\"100%\">") ;
								out.println("<td width=\"10\" height=\"1\" bgcolor=\"#969696\"></td>") ;
								out.println("<td width=\"250\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Constructor</b></font></td>") ;

								out.println("<td width=\"70\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Selected</b></font></td>") ;
								out.println("<td width=\"30\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Qualifying</b></font></td>") ;
								out.println("<td width=\"30\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Race</b></font></td>") ;
								out.println("<td width=\"70\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Fastest Lap</b></font></td>") ;

								out.println("<td width=\"30\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Total</b></font></td>") ;

								query = "SELECT teamId, raceTeamName, finishPosition, qualifyPosition, fastestLap, score FROM f1_raceteam ORDER BY score DESC" ;
								rs = stmt.executeQuery(query);

								while (rs.next())
								{
									finishPosition = rs.getInt("finishPosition") ;
									qualifyPosition = rs.getInt("qualifyPosition") ;
									fastestLap = rs.getInt("fastestLap") ;
									score = rs.getInt("score") ;

									tId = rs.getInt("teamId") ;

									out.println("<tr>") ;

									String tName = rs.getString("raceTeamName") ;

									chosenCount = 0 ;

									// Find the number of times this raceTeam has already been chosen
									for (i = 1 ; i < weekNum ; i++)
									{
										// First update all of the driver scores
										query = "SELECT raceTeamName FROM f1_userteam" + i + " WHERE teamId = " + teamId ;

										rs2 = stmt2.executeQuery(query);

										if (rs2.next())
										{
											tempName = rs2.getString("raceTeamName") ;

											if ((tempName != null) && tempName.equals(tName))
											{
												chosenCount++ ;
											}
										}
									}

									// Have a different background colour if the team is in your team or not
									if (tName.equals(teamName))
									{
										out.println("<td width=\"10\" height=\"28\" bgcolor=\"#B5B5B5\"></td>") ;
										out.println("<td width=\"250\" height=\"28\" bgcolor=\"#B5B5B5\"><font size=2.5>  " + tName) ;
										out.println("<a href=\"teamGraphs.jsp?name=" + tName + "&team=" + teamId + "\"><img src=\"images/graphs.gif\" alt=\"performance\" width=\"13\" height=\"14\" border=\"0\"></a></td>") ;

										// Take into account the current selection
										if (tName.equals(teamName))
										{
											chosenCount++ ;
										}

										out.println("<td width=\"70\" height=\"1\" bgcolor=\"#B5B5B5\"><font size=2.5>" + chosenCount + " of 5</td>") ;
										out.println("<td width=\"27\" height=\"1\" bgcolor=\"#B5B5B5\"><font size=2.5>" + qualifyPosition + "</td>") ;
										out.println("<td width=\"27\" height=\"1\" bgcolor=\"#B5B5B5\"><font size=2.5>" + finishPosition + "</td>") ;
										out.println("<td width=\"70\" height=\"1\" bgcolor=\"#B5B5B5\"><font size=2.5>" + fastestLap + "</td>") ;
										out.println("<td width=\"27\" height=\"1\" bgcolor=\"#B5B5B5\"><font size=2.5>" + score + "</td>") ;
									}
									else
									{
										if (chosenCount >= 5)
										{
											out.println("<td width=\"10\" height=\"28\" bgcolor=\"#E0E0E0\">") ;
										}
										else
										{
											out.println("<td width=\"10\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5><input type=\"radio\" name=\"id\" value =\"" + tId + "\">") ;
										}

										out.println("<td width=\"250\" height=\"28\" bgcolor=\"#E0E0E0\"><font size=2.5>  " + tName) ;
										out.println("<a href=\"teamGraphs.jsp?name=" + tName + "&team=" + teamId + "\"><img src=\"images/graphs.gif\" alt=\"performance\" width=\"13\" height=\"14\" border=\"0\"></a></td>") ;

										out.println("<td width=\"70\" height=\"1\" bgcolor=\"#E0E0E0\"><font size=2.5>" + chosenCount + " of 5</td>") ;
										out.println("<td width=\"27\" height=\"1\" bgcolor=\"#E0E0E0\"><font size=2.5>" + qualifyPosition + "</td>") ;
										out.println("<td width=\"27\" height=\"1\" bgcolor=\"#E0E0E0\"><font size=2.5>" + finishPosition + "</td>") ;
										out.println("<td width=\"70\" height=\"1\" bgcolor=\"#E0E0E0\"><font size=2.5>" + fastestLap + "</td>") ;
										out.println("<td width=\"27\" height=\"1\" bgcolor=\"#E0E0E0\"><font size=2.5>" + score + "</td>") ;
									}

									out.println("</tr>") ;
								}

								out.println("<tr><td>    <td><input type=\"hidden\" name=\"name\" value =\"" + teamName + "\">") ;
								out.println("<tr><td>    <td><input type=\"hidden\" name=\"teamId\" value =\"" + teamId + "\">") ;
								out.println("</table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;

								out.println("</center>") ;
							}
						}
					}
					else
					{
						out.println("<center>") ;

						// Now do some extra validation just to make sure that this change is valid

						// Make sure that the team hasn't already been chosen 5 times
						query = "SELECT raceTeamName FROM f1_raceteam WHERE teamId = " + changeId ;

						rs = stmt.executeQuery(query);

						rs.next() ;

						String changeName = rs.getString("raceTeamName") ;

						query = "SELECT weekNum FROM f1_admin WHERE weekNum > 0" ;

						rs = stmt.executeQuery(query);

						rs.next() ;

						weekNum = rs.getInt("weekNum") ;

						chosenCount = 0 ;

						for (i = 1 ; i < weekNum ; i++)
						{
							query = "SELECT raceTeamName FROM f1_userteam" + i + " WHERE teamId = " + teamId ;

							rs2 = stmt2.executeQuery(query);

							if (rs2.next())
							{
								if (changeName.equals(rs2.getString("raceTeamName")))
								{
									chosenCount++ ;
								}
							}
						}

						if (chosenCount >= 5)
						{
							validEdit = false ;
						}

						// Now check that you are the owner of the team
						query = "SELECT userId FROM f1_userteam WHERE teamId = " + teamId ;

						rs = stmt.executeQuery(query);

						if (rs.next())
						{
							String strId = String.valueOf(session.getValue("sessionId")) ;

							if (Integer.parseInt(strId) != rs.getInt("userId"))
							{
								validEdit = false ;
							}
						}

						if (validEdit == false)
						{
							out.println("<br><br><font color=red>Invalid team edit</font><br>") ;
						}
						else
						{
							query = "SELECT raceTeamName FROM f1_raceteam WHERE teamId = " + changeId ;

							rs = stmt.executeQuery(query);

							rs.next() ;

							query = "UPDATE f1_userteam SET raceTeamName = '" + rs.getString("raceTeamName") + "' WHERE teamId = " + teamId ;

							int LinesAffected = stmt2.executeUpdate(query);

							if (LinesAffected != 1)
							{
								out.println("<br>Problem updating database") ;
							}
							else
							{
								con.close() ;
								response.sendRedirect("team.jsp?id=" + teamId + "&weekNum=" + weekNum);
							}
						}
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

<script type="text/javascript"><!--
google_ad_client = "pub-9229293934937598";
google_ad_width = 234;
google_ad_height = 60;
google_ad_format = "234x60_as";
google_ad_type = "text";
google_ad_channel = "";
google_color_border = "FFFFFF";
google_color_bg = "FFFFFF";
google_color_link = "001480";
google_color_text = "000000";
google_color_url = "001480";
//--></script>
<script type="text/javascript"
  src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>

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
