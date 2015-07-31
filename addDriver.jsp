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

</center>

<%@ include file="url.txt" %>

<% 
	String submit = request.getParameter("submit") ;
	String team = request.getParameter("team") ;
	ResultSet rs, rs1, rs2, rs3 ;
	int numPlayers ;
	int messageCount ;
	int weekNum ;
	int i, j ;
	int goals ;
	int shots ;
	int assist ;
	int yellowCard ;
	int redCard ;
	int foulsCommited ;
	int penaltyScored ;
	int penaltyMiss ;
	int GKSave ;
	int GKPenaltySave ;
	int GKCleanSheet ;
	int GKGoalsConceded ;
	int GKWin ;
	int GKDraw ;
	int GKLose ;
	int defensiveCleanSheet ;
	int defensiveGoalsConceded ;
	int ownGoal ;
	int penaltyCommited ;
	int minutes ;
	double score ;
	int LinesAffected ;
	int playerId ;
	int teamId ;
	int position, calcPosition ;
	double price, oldPrice ;
	String query ;
	int updatingFlag ;
	int userCount ;
	int pId ;
	String name, email, password ;

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
				if ((team == null) || (team.equals("")))
				{
					out.println("<center>") ;

					// Get the player details
					out.println("<form action=\"addDriver.jsp\" method=\"post\"><table>First name ... <input type=\"text\" name=\"firstName\"><br>Second name ... <input type=\"text\" name=\"secondName\"><br>Team ... <input type=\"text\" name=\"team\"></table><br><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;

					out.println("<br><br><A HREF=\"admin.jsp\">Back</A>") ;
				}
				else
				{
					// Now get the next driverid and insert the new record
					query = "SELECT MAX(driverId) AS pId FROM f1_driver" ;

					rs = stmt.executeQuery(query) ;

					rs.next();

					pId = (rs.getInt("pId") + 1) ;

					String insert = "INSERT INTO f1_driver (driverId, driverFirstName, driverLastName, raceTeamName) VALUES ('" + pId + "', '" + request.getParameter("firstName") + "', '" + request.getParameter("secondName") + "', '" + request.getParameter("team") + "')" ;

					LinesAffected = stmt.executeUpdate(insert);

					if (LinesAffected != 1)
					{
						out.println("<center>") ;

						out.println("<font color=red>Problem inserting driver</font>") ;
					}
					else
					{
						insert = "INSERT INTO f1_driver_blank (driverId, driverFirstName, driverLastName, raceTeamName) VALUES ('" + pId + "', '" + request.getParameter("firstName") + "', '" + request.getParameter("secondName") + "', '" + request.getParameter("team") + "')" ;

						LinesAffected = stmt.executeUpdate(insert);

						if (LinesAffected != 1)
						{
							out.println("<center>") ;

							out.println("<font color=red>Problem inserting driver</font>") ;
						}
						else
						{
							query = "SELECT weekNum FROM f1_admin WHERE weekNum > 0" ;

							rs = stmt.executeQuery(query);

							rs.next() ;

							weekNum = rs.getInt("weekNum") - 1 ;

							if (weekNum != 0)
							{
								insert = "INSERT INTO f1_driver" + weekNum + " (driverId, driverFirstName, driverLastName, raceTeamName) VALUES ('" + pId + "', '" + request.getParameter("firstName") + "', '" + request.getParameter("secondName") + "', '" + request.getParameter("team") + "')" ;

								LinesAffected = stmt.executeUpdate(insert);

								if (LinesAffected != 1)
								{
									out.println("<center>") ;

									out.println("<font color=red>Problem inserting driver</font>") ;
								}
							}

							out.println("<center>") ;

							out.println("<br>Done") ;

							out.println("<br><br><A HREF=\"admin.jsp\">Continue</A>") ;
						}
					}

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

