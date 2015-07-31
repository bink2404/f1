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

<title>FantasySportNet - Formula One</title>

<SCRIPT LANGUAGE="JavaScript">
 function putFocus(formInst, elementInst) {
  if (document.forms.length > 0) {
   document.forms[formInst].elements[elementInst].focus();
  }
 }
</script>

</head>

<body onLoad="putFocus(0,0);" bgcolor=white>

<p><center>

<%@ include file="header.txt" %>

<%@ include file="url.txt" %>

<% 
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
	String query = "" ;
	int updatingFlag ;
	int userCount ;
	int LinesAffected ;
	int teamId ;
	int driverId ;
	int chosenCount ;
	String name, email, password, tn ;

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
				if ((submit == null) || (submit.equals("")))
				{
					query = "SELECT updating FROM f1_admin WHERE updating >= 0" ;

					rs = stmt.executeQuery(query);

					rs.next() ;

					out.println("<center>") ;

					out.println("<br>") ;

					out.println("<A HREF=\"editScores.jsp\">Edit driver scores</A><br>") ;
					out.println("<A HREF=\"editTeamScores.jsp\">Edit team scores</A><br>") ;
					out.println("<A HREF=\"addDriver.jsp\">Add driver</A><br>") ;
					out.println("<A HREF=\"setWeek.jsp\">Set week</A><br>") ;
					out.println("<A HREF=\"setDeadline.jsp\">Set deadline</A><br>") ;
					out.println("<A HREF=\"setNextDeadline.jsp\">Set next deadline</A><br>") ;

					// Get the total number of users
					query = "SELECT COUNT(*) AS userCount FROM f1_user WHERE userId > 0" ;

					rs2 = stmt2.executeQuery(query);

					rs2.next() ;
					
					userCount = rs2.getInt("userCount") ;

					out.println("<br><br><b>There are currently " + userCount + " users registered</b>") ;

					out.println("<br><br>Recalculate all scores and points") ;
					out.println("<form action=\"admin.jsp\" method=\"post\"><table></table><input type=\"submit\" name=\"submit\" value=\"Calculate\"><br><br><br><br>Set the updating flag<br><br><input type=\"submit\" name=\"submit\" value=\"Updating\"><br><br>Current updating flag = " + String.valueOf(rs.getInt("updating")) + "<br><br><br>Clear the password reminder table<br><br><input type=\"submit\" name=\"submit\" value=\"Clear\"></form>") ;

					out.println("Current password reminder requests ...<br><br>") ;

					query = "SELECT userId FROM f1_passwordreminder" ;

					rs = stmt.executeQuery(query);

					while(rs.next())
					{
						name = rs.getString("userId") ;

						out.println(name + " ... ") ;

						query = "SELECT name, emailAddress, password FROM f1_user WHERE name = '" + name + "'" ;

						rs2 = stmt2.executeQuery(query);

						if (rs2.next())
						{
							name = rs2.getString("name") ;
							email = rs2.getString("emailAddress") ;
							password = rs2.getString("password") ;

							out.println(name + ", " + email + ", " + password + "<br>") ;
						}
						else
						{
							query = "SELECT name, emailAddress, password FROM f1_user WHERE emailAddress = '" + name + "'" ;

							rs2 = stmt2.executeQuery(query);

							if (rs2.next())
							{
								name = rs2.getString("name") ;
								email = rs2.getString("emailAddress") ;
								password = rs2.getString("password") ;

								out.println(name + ", " + email + ", " + password + "<br>") ;
							}
							else
							{
								query = "SELECT name, emailAddress, password FROM f1_user WHERE password = '" + name + "'" ;

								rs2 = stmt2.executeQuery(query);

								if (rs2.next())
								{
									name = rs2.getString("name") ;
									email = rs2.getString("emailAddress") ;
									password = rs2.getString("password") ;

									out.println(name + ", " + email + ", " + password + "<br>") ;
								}
								else
								{
									out.println("no data found<br>") ;
								}
							}
						}
					}

					out.println("</center>") ;
				}
				else
				{
					out.println("<center>") ;

					if (submit.equals("Calculate"))
					{
						out.println("<br>Calculating<br>") ;

						// First clean the teams to enforce the 5 time rule
						query = "SELECT weekNum FROM f1_admin WHERE weekNum > 0" ;

						rs = stmt.executeQuery(query);

						rs.next() ;

						weekNum = rs.getInt("weekNum") ;

						// Blank out any drivers or teams that have already been picked 3 times.
						query = "SELECT driver1Id, driver2Id, driver3Id, raceTeamName, teamId FROM f1_userteam WHERE teamId >= 1" ;

						rs2 = stmt4.executeQuery(query);

						while (rs2.next())
						{
							teamId = rs2.getInt("teamId") ;
							raceTeamName = rs2.getString("raceTeamName") ;

							driverId = rs2.getInt("driver1Id") ;
							chosenCount = 0 ;

							// Find the number of times this driver has already been chosen
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
								query = "UPDATE f1_userteam SET driver1Id = 0 WHERE teamId = " + teamId ;

								LinesAffected = stmt5.executeUpdate(query);
							}

							driverId = rs2.getInt("driver2Id") ;
							chosenCount = 0 ;

							// Find the number of times this driver has already been chosen
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
								query = "UPDATE f1_userteam SET driver2Id = 0 WHERE teamId = " + teamId ;

								LinesAffected = stmt5.executeUpdate(query);
							}

							driverId = rs2.getInt("driver3Id") ;
							chosenCount = 0 ;

							// Find the number of times this driver has already been chosen
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
								query = "UPDATE f1_userteam SET driver3Id = 0 WHERE teamId = " + teamId ;

								LinesAffected = stmt5.executeUpdate(query);
							}

							chosenCount = 0 ;

							// Find the number of times this driver has already been chosen
							for (i = 1 ; i < weekNum ; i++)
							{
								query = "SELECT raceTeamName FROM f1_userteam" + i + " WHERE teamId = " + teamId ;

								rs3 = stmt3.executeQuery(query);

								if (rs3.next())
								{
tn = rs3.getString("raceTeamName") ;

									if ((null != raceTeamName) && (null != tn) && (tn.equals(raceTeamName)))
									{
										chosenCount++ ;
									}
								}
							}

							if (chosenCount >= 5)
							{
								query = "UPDATE f1_userteam SET raceTeamName = ' ' WHERE teamId = " + teamId ;

								LinesAffected = stmt5.executeUpdate(query);
							}
						}

						out.println("<br>Done<br>") ;

						out.println("<br><A HREF=\"admin.jsp\">Continue</A>") ;
					}

					if (submit.equals("Updating"))
					{
						query = "SELECT updating FROM f1_admin WHERE updating >= 0" ;

						rs = stmt.executeQuery(query);

						rs.next() ;	

						updatingFlag = rs.getInt("updating") ;

						if (updatingFlag == 0)
						{
							query = "UPDATE f1_admin SET updating = 1 WHERE updating >= 0" ;
						}
						else
						{
							query = "UPDATE f1_admin SET updating = 0 WHERE updating >= 0" ;
						}

						LinesAffected = stmt2.executeUpdate(query);

						query = "SELECT updating FROM f1_admin WHERE updating >= 0" ;

						rs = stmt.executeQuery(query);

						rs.next() ;

						out.println("<center>") ;

						out.println("<br>") ;

						out.println("<A HREF=\"editScores.jsp\">Edit driver scores</A><br>") ;
						out.println("<A HREF=\"editTeamScores.jsp\">Edit team scores</A><br>") ;
						out.println("<A HREF=\"addDriver.jsp\">Add driver</A><br>") ;
						out.println("<A HREF=\"setWeek.jsp\">Set week</A><br>") ;
						out.println("<A HREF=\"setDeadline.jsp\">Set deadline</A><br>") ;
						out.println("<A HREF=\"setNextDeadline.jsp\">Set next deadline</A><br>") ;

						// Get the total number of users
						query = "SELECT COUNT(*) AS userCount FROM f1_user WHERE userId > 0" ;

						rs2 = stmt2.executeQuery(query);

						rs2.next() ;
					
						userCount = rs2.getInt("userCount") ;

						out.println("<br><br><b>There are currently " + userCount + " users registered</b>") ;

						out.println("<br><br>Recalculate all scores and points") ;
						out.println("<form action=\"admin.jsp\" method=\"post\"><table></table><input type=\"submit\" name=\"submit\" value=\"Calculate\"><br><br><br><br>Set the updating flag<br><br><input type=\"submit\" name=\"submit\" value=\"Updating\"><br><br>Current updating flag = " + String.valueOf(rs.getInt("updating")) + "<br><br><br>Clear the password reminder table<br><br><input type=\"submit\" name=\"submit\" value=\"Clear\"></form>") ;

						out.println("Current password reminder requests ...<br><br>") ;

						query = "SELECT userId FROM f1_passwordreminder" ;

						rs = stmt.executeQuery(query);

						while(rs.next())
						{
							name = rs.getString("userId") ;

							out.println(name + " ... ") ;

							query = "SELECT name, emailAddress, password FROM f1_user WHERE name = '" + name + "'" ;

							rs2 = stmt2.executeQuery(query);

							if (rs2.next())
							{
								name = rs2.getString("name") ;
								email = rs2.getString("emailAddress") ;
								password = rs2.getString("password") ;

								out.println(name + ", " + email + ", " + password + "<br>") ;
							}
							else
							{
								query = "SELECT name, emailAddress, password FROM f1_user WHERE emailAddress = '" + name + "'" ;

								rs2 = stmt2.executeQuery(query);

								if (rs2.next())
								{
									name = rs2.getString("name") ;
									email = rs2.getString("emailAddress") ;
									password = rs2.getString("password") ;

									out.println(name + ", " + email + ", " + password + "<br>") ;
								}
								else
								{
									query = "SELECT name, emailAddress, password FROM f1_user WHERE password = '" + name + "'" ;

									rs2 = stmt2.executeQuery(query);

									if (rs2.next())
									{
										name = rs2.getString("name") ;
										email = rs2.getString("emailAddress") ;
										password = rs2.getString("password") ;

										out.println(name + ", " + email + ", " + password + "<br>") ;
									}
									else
									{
										out.println("no data found<br>") ;
									}
								}
							}
						}

						// Now recalculate
						query = "SELECT weekNum FROM f1_admin WHERE weekNum > 0" ;

						rs = stmt.executeQuery(query);

						rs.next() ;

						weekNum = rs.getInt("weekNum") ;

						query = "UPDATE f1_driver SET score = 0, finishPosition = 0, qualifyPosition = 0, fastestLap = 0 WHERE driverId >= 1" ;

						LinesAffected = stmt5.executeUpdate(query);

						for (i = 1 ; i < weekNum ; i++)
						{
							// First update all of the driver scores
							query = "SELECT driverId, finishPosition, qualifyPosition, fastestLap FROM f1_driver" + i + " WHERE driverId >= 1" ;

							rs = stmt.executeQuery(query);

							while (rs.next())
							{
								driverId = rs.getInt("driverId") ;
								finishPosition = rs.getInt("finishPosition") ;
								qualifyPosition = rs.getInt("qualifyPosition") ;
								fastestLap = rs.getInt("fastestLap") ;

								score = 0 ;

								score += finishPosition ;
								score += qualifyPosition ;
								score += fastestLap ;

								query = "UPDATE f1_driver" + i + " SET score = " + score + " WHERE driverId = " + driverId ;

								LinesAffected = stmt2.executeUpdate(query);

								if (i == 1)
								{
									query = "UPDATE f1_driver SET score = " + score + 
										", finishPosition = " + finishPosition + 
										", qualifyPosition = " + qualifyPosition +
										", fastestLap = " + fastestLap +
										" WHERE driverId = " + driverId ;
									LinesAffected = stmt2.executeUpdate(query);
								}
								else
								{
									query = "SELECT score, finishPosition, qualifyPosition, fastestLap FROM f1_driver WHERE driverId = " + driverId ;

									rs1 = stmt3.executeQuery(query);

									if (rs1.next())
									{
										query = "UPDATE f1_driver SET score = " + (score + rs1.getInt("score")) + 
											", finishPosition = " + (finishPosition + rs1.getInt("finishPosition")) + 
											", qualifyPosition = " + (qualifyPosition + rs1.getInt("qualifyPosition")) +
											", fastestLap = " + (fastestLap + rs1.getInt("fastestLap")) +
											" WHERE driverId = " + driverId ;

										LinesAffected = stmt2.executeUpdate(query);
									}
								}
							}
						}

						query = "UPDATE f1_raceteam SET score = 0, finishPosition = 0, qualifyPosition = 0, fastestLap = 0 WHERE teamId >= 1" ;

						LinesAffected = stmt5.executeUpdate(query);

						for (i = 1 ; i < weekNum ; i++)
						{
							// Now update all of the raceTeam scores
							query = "SELECT raceTeamName, finishPosition, qualifyPosition, fastestLap FROM f1_raceteam" + i + " WHERE teamId >= 1" ;

							rs = stmt.executeQuery(query);

							while (rs.next())
							{
								raceTeamName = rs.getString("raceTeamName") ;
								finishPosition = rs.getInt("finishPosition") ;
								qualifyPosition = rs.getInt("qualifyPosition") ;
								fastestLap = rs.getInt("fastestLap") ;

								score = 0 ;

								score += finishPosition ;
								score += qualifyPosition ;
								score += fastestLap ;

								query = "UPDATE f1_raceteam" + i + " SET score = " + score + " WHERE raceTeamName = '" + raceTeamName + "'" ;

								LinesAffected = stmt2.executeUpdate(query);

								if (i == 1)
								{
									query = "UPDATE f1_raceteam SET score = " + score + 
										", finishPosition = " + finishPosition + 
										", qualifyPosition = " + qualifyPosition +
										", fastestLap = " + fastestLap +
										" WHERE raceTeamName = '" + raceTeamName + "'" ;
									LinesAffected = stmt2.executeUpdate(query);
								}
								else
								{
									query = "SELECT score, finishPosition, qualifyPosition, fastestLap FROM f1_raceteam WHERE raceTeamName = '" + raceTeamName + "'" ;

									rs1 = stmt3.executeQuery(query);

									if (rs1.next())
									{
										query = "UPDATE f1_raceteam SET score = " + (score + rs1.getInt("score")) + 
											", finishPosition = " + (finishPosition + rs1.getInt("finishPosition")) + 
											", qualifyPosition = " + (qualifyPosition + rs1.getInt("qualifyPosition")) +
											", fastestLap = " + (fastestLap + rs1.getInt("fastestLap")) +
											" WHERE raceTeamName = '" + raceTeamName + "'" ;

										LinesAffected = stmt2.executeUpdate(query);
									}
								}
							}
						}

						query = "UPDATE f1_userteam SET score = 0 WHERE teamId >= 1" ;

						LinesAffected = stmt5.executeUpdate(query);

						for (i = 1 ; i < weekNum ; i++)
						{
							// Now update all of the group scores
							query = "SELECT driver1Id, driver2Id, driver3Id, teamId, raceTeamName FROM f1_userteam" + i + " WHERE teamId >= 1" ;

							rs2 = stmt4.executeQuery(query);

							while (rs2.next())
							{
								teamId = rs2.getInt("teamId") ;
								raceTeamName = rs2.getString("raceTeamName") ;

								score = 0 ;

								// First the drivers
								for (j = 1 ; j <= 3 ; j++)
								{
									query = "SELECT score FROM f1_driver" + i + " WHERE driverId = " + rs2.getInt("driver" + j + "Id") ;

									rs3 = stmt5.executeQuery(query);

									if (rs3.next())
									{
										score += rs3.getInt("score") ;
									}
								}

								// Now the raceTeam
								query = "SELECT score FROM f1_raceteam" + i + " WHERE raceTeamName = '" + raceTeamName + "'" ;

								rs3 = stmt5.executeQuery(query);

								if (rs3.next())
								{
									score += rs3.getInt("score") ;
								}

								query = "UPDATE f1_userteam" + i + " SET score = " + score + " WHERE teamId = " + teamId ;

								LinesAffected = stmt5.executeUpdate(query);

								if (i == 1)
								{
									query = "UPDATE f1_userteam SET score = " + score + " WHERE teamId = " + teamId ;

									LinesAffected = stmt5.executeUpdate(query);
								}
								else
								{
									query = "SELECT score FROM f1_userteam WHERE teamId = " + teamId ;

									rs1 = stmt3.executeQuery(query);

									if (rs1.next())
									{
										query = "UPDATE f1_userteam SET score = " + (score + rs1.getInt("score")) + " WHERE teamId = " + teamId ;

										LinesAffected = stmt5.executeUpdate(query);
									}
								}
							}
						}

						out.println("<br>Done<br>") ;

						out.println("<br><A HREF=\"admin.jsp\">Continue</A>") ;
					}

					if (submit.equals("Updating"))
					{
						query = "SELECT updating FROM f1_admin WHERE updating >= 0" ;

						rs = stmt.executeQuery(query);

						rs.next() ;	

						updatingFlag = rs.getInt("updating") ;

						if (updatingFlag == 0)
						{
							query = "UPDATE f1_admin SET updating = 1 WHERE updating >= 0" ;
						}
						else
						{
							query = "UPDATE f1_admin SET updating = 0 WHERE updating >= 0" ;
						}

						LinesAffected = stmt2.executeUpdate(query);

						query = "SELECT updating FROM f1_admin WHERE updating >= 0" ;

						rs = stmt.executeQuery(query);

						rs.next() ;

						out.println("<center>") ;

						out.println("<br>") ;

						out.println("<A HREF=\"editScores.jsp\">Edit driver scores</A><br>") ;
						out.println("<A HREF=\"editTeamScores.jsp\">Edit team scores</A><br>") ;
						out.println("<A HREF=\"addDriver.jsp\">Add driver</A><br>") ;
						out.println("<A HREF=\"setWeek.jsp\">Set week</A><br>") ;
						out.println("<A HREF=\"setDeadline.jsp\">Set deadline</A><br>") ;
						out.println("<A HREF=\"setNextDeadline.jsp\">Set next deadline</A><br>") ;

						// Get the total number of users
						query = "SELECT COUNT(*) AS userCount FROM f1_user WHERE userId > 0" ;

						rs2 = stmt2.executeQuery(query);

						rs2.next() ;
					
						userCount = rs2.getInt("userCount") ;

						out.println("<br><br><b>There are currently " + userCount + " users registered</b>") ;

						out.println("<br><br>Recalculate all scores and points") ;
						out.println("<form action=\"admin.jsp\" method=\"post\"><table></table><input type=\"submit\" name=\"submit\" value=\"Calculate\"><br><br><br><br>Set the updating flag<br><br><input type=\"submit\" name=\"submit\" value=\"Updating\"><br><br>Current updating flag = " + String.valueOf(rs.getInt("updating")) + "<br><br><br>Clear the password reminder table<br><br><input type=\"submit\" name=\"submit\" value=\"Clear\"></form>") ;

						out.println("Current password reminder requests ...<br><br>") ;

						query = "SELECT userId FROM f1_passwordreminder" ;

						rs = stmt.executeQuery(query);

						while(rs.next())
						{
							name = rs.getString("userId") ;

							out.println(name + " ... ") ;

							query = "SELECT name, emailAddress, password FROM f1_user WHERE name = '" + name + "'" ;

							rs2 = stmt2.executeQuery(query);

							if (rs2.next())
							{
								name = rs2.getString("name") ;
								email = rs2.getString("emailAddress") ;
								password = rs2.getString("password") ;

								out.println(name + ", " + email + ", " + password + "<br>") ;
							}
							else
							{
								query = "SELECT name, emailAddress, password FROM f1_user WHERE emailAddress = '" + name + "'" ;

								rs2 = stmt2.executeQuery(query);

								if (rs2.next())
								{
									name = rs2.getString("name") ;
									email = rs2.getString("emailAddress") ;
									password = rs2.getString("password") ;

									out.println(name + ", " + email + ", " + password + "<br>") ;
								}
								else
								{
									query = "SELECT name, emailAddress, password FROM f1_user WHERE password = '" + name + "'" ;

									rs2 = stmt2.executeQuery(query);

									if (rs2.next())
									{
										name = rs2.getString("name") ;
										email = rs2.getString("emailAddress") ;
										password = rs2.getString("password") ;

										out.println(name + ", " + email + ", " + password + "<br>") ;
									}
									else
									{
										out.println("no data found<br>") ;
									}
								}
							}
						}
					}

					if (submit.equals("Clear"))
					{
						query = "DELETE FROM f1_passwordreminder" ;

						LinesAffected = stmt.executeUpdate(query);

						query = "SELECT updating FROM f1_admin WHERE updating >= 0" ;

						rs = stmt.executeQuery(query);

						rs.next() ;

						out.println("<center>") ;

						out.println("<br>") ;

						out.println("<A HREF=\"editScores.jsp\">Edit driver scores</A><br>") ;
						out.println("<A HREF=\"editTeamScores.jsp\">Edit team scores</A><br>") ;
						out.println("<A HREF=\"addDriver.jsp\">Add driver</A><br>") ;
							out.println("<A HREF=\"setWeek.jsp\">Set week</A><br>") ;
						out.println("<A HREF=\"setDeadline.jsp\">Set deadline</A><br>") ;
						out.println("<A HREF=\"setNextDeadline.jsp\">Set next deadline</A><br>") ;

						// Get the total number of users
						query = "SELECT COUNT(*) AS userCount FROM f1_user WHERE userId > 0" ;

						rs2 = stmt2.executeQuery(query);

						rs2.next() ;
					
						userCount = rs2.getInt("userCount") ;

						out.println("<br><br><b>There are currently " + userCount + " users registered</b>") ;

						out.println("<br><br>Recalculate all scores and points") ;
						out.println("<form action=\"admin.jsp\" method=\"post\"><table></table><input type=\"submit\" name=\"submit\" value=\"Calculate\"><br><br><br><br>Set the updating flag<br><br><input type=\"submit\" name=\"submit\" value=\"Updating\"><br><br>Current updating flag = " + String.valueOf(rs.getInt("updating")) + "<br><br><br>Clear the password reminder table<br><br><input type=\"submit\" name=\"submit\" value=\"Clear\"></form>") ;

						out.println("Current password reminder requests ...<br><br>") ;

						query = "SELECT userId FROM f1_passwordreminder" ;

						rs = stmt.executeQuery(query);

						while(rs.next())
						{
							name = rs.getString("userId") ;

							out.println(name + " ... ") ;

							query = "SELECT name, emailAddress, password FROM f1_user WHERE name = '" + name + "'" ;

							rs2 = stmt2.executeQuery(query);

							if (rs2.next())
							{
								name = rs2.getString("name") ;
								email = rs2.getString("emailAddress") ;
								password = rs2.getString("password") ;

								out.println(name + ", " + email + ", " + password + "<br>") ;
							}
							else
							{
								query = "SELECT name, emailAddress, password FROM f1_user WHERE emailAddress = '" + name + "'" ;

								rs2 = stmt2.executeQuery(query);

								if (rs2.next())
								{
									name = rs2.getString("name") ;
									email = rs2.getString("emailAddress") ;
									password = rs2.getString("password") ;

									out.println(name + ", " + email + ", " + password + "<br>") ;
								}
								else
								{
									query = "SELECT name, emailAddress, password FROM f1_user WHERE password = '" + name + "'" ;

									rs2 = stmt2.executeQuery(query);

									if (rs2.next())
									{
										name = rs2.getString("name") ;
										email = rs2.getString("emailAddress") ;
										password = rs2.getString("password") ;

										out.println(name + ", " + email + ", " + password + "<br>") ;
									}
									else
									{
										out.println("no data found<br>") ;
									}
								}
							}
						}
					}

					out.println("</center>") ;
				}
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

<%@ include file="footer.txt" %>

</center>
</div>
<p><center>
<br>
</center></p>

</body>

</html>
