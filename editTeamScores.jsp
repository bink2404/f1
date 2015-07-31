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

<title>fantasysportnet - F1</title>

<meta name="keywords" content="fantasy, sports, sport, game, games, free, soccer, football, premiership, footy, fantasysportnet">
<meta name="description" content="FantasySportNet - fantasy sports.">

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

<%@ include file="url.txt" %>

<% 
	String submit = request.getParameter("submit") ;
	String save = request.getParameter("save") ;
	String team = request.getParameter("team") ;
	String weekNum = request.getParameter("weekNum") ;
	ResultSet rs, rs1, rs2, rs3 ;
	int numPlayers ;
	int messageCount ;
	int i, j ;
	int goals ;
	int shots ;
	int shotsOnTarget ;
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
	int Win ;
	int Draw ;
	int Lose ;
	int defensiveCleanSheet ;
	int defensiveGoalsConceded ;
	int ownGoal ;
	int penaltyCommited ;
	int substituted ;
	int offside ;
	int offensiveCleanSheet ;
	double score ;
	int LinesAffected ;
	int driverId ;
	int teamId ;
	int position, calcPosition ;
	double price, oldPrice ;
	String query = "" ;
	int updatingFlag ;
	int userCount ;
	int[] pId = new int[12] ;
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

				out.println("</center>") ;
			}
			else
			{
				if ((weekNum == null) || (weekNum.equals("")))
				{
					// Get the week to display
					out.println("<form action=\"editTeamScores.jsp\" method=\"post\"><table><br>Week ... <input type=\"text\" name=\"weekNum\"></table><br><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;

					out.println("<br><br><A HREF=\"admin.jsp\">Back</A>") ;
				}
				else
				{
					if ((save == null) || (save.equals("")))
					{
						// Display all teams.
						query = "SELECT teamId, raceTeamName, finishPosition, qualifyPosition, fastestLap FROM f1_raceteam" + weekNum + " ORDER BY raceTeamName";

						rs = stmt.executeQuery(query);

						out.println("<form action=\"editTeamScores.jsp\" method=\"post\">") ;

						out.println("<table border=\"0\" width=\"100%\" height=\"1\" cellpadding=\"2\">") ;

						numPlayers = 1 ;
						StringBuffer col = new StringBuffer() ;
						StringBuffer white = new StringBuffer("#FFFFFF") ;
						StringBuffer shaded = new StringBuffer("#CACACA") ;

						out.println("<td width=\"2\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Team</b></font></td>") ;
						out.println("<td width=\"2\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Finish Pos</b></font></td>") ;
						out.println("<td width=\"2\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Qual. Pos</b></font></td>") ;
						out.println("<td width=\"2\" height=\"1\" bgcolor=\"#969696\"><font color=\"#FFFFFF\" size=2.5><b>Fastest Lap</b></font></td>") ;
							
						out.println("</tr>") ;

						while (rs.next())
						{
							if ((numPlayers % 2) == 0)
							{
								col = white ;
							}
							else
							{
								col = shaded ;
							}
							
							out.println("<td width=\"27\" height=\"1\" bgcolor=\"" + col + "\">" + rs.getString("raceTeamName") + "</td>") ;
							out.println("<td width=\"27\" height=\"1\" bgcolor=\"" + col + "\"><input type=\"text\" size=\"1\" name=\"finishPos" + numPlayers + "\" value=\"" + rs.getInt("finishPosition") + "\"></td>") ;
							out.println("<td width=\"27\" height=\"1\" bgcolor=\"" + col + "\"><input type=\"text\" size=\"1\" name=\"qualifyPos" + numPlayers + "\" value=\"" + rs.getInt("qualifyPosition") + "\"></td>") ;
							out.println("<td width=\"27\" height=\"1\" bgcolor=\"" + col + "\"><input type=\"text\" size=\"1\" name=\"fastestLap" + numPlayers + "\" value=\"" + rs.getInt("fastestLap") + "\"></td>") ;
							
							out.println("<input type=\"hidden\" name=\"id" + numPlayers + "\" value=\"" + rs.getInt("teamId") + "\">") ;

							out.println("</tr>") ;

							numPlayers++ ;
						}

						out.println("</table>") ;

						out.println("<input type=\"hidden\" name=\"team\" value=\"" + team + "\">") ;
						out.println("<input type=\"hidden\" name=\"weekNum\" value=\"" + weekNum + "\">") ;

						out.println("<br><input type=\"submit\" name=\"save\" value=\"Save\"></form>") ;

						out.println("<br><A HREF=\"admin.jsp\">Continue</A>") ;
					}
					else
					{
						// Now save the information
						query = "SELECT COUNT(*) AS messageCount FROM f1_raceteam" + weekNum ;

						rs = stmt.executeQuery(query);

						rs.next() ;

						messageCount = rs.getInt("messageCount") ;

						for (i = 1 ; i <= messageCount ; i++)
						{
							query = "UPDATE f1_raceteam" + weekNum + " SET finishPosition = " + request.getParameter("finishPos" + i) + 
									", qualifyPosition = " + request.getParameter("qualifyPos" + i) + 
									", fastestLap = " + request.getParameter("fastestLap" + i) +
									" WHERE teamId = " + request.getParameter("id" + i) ;

							LinesAffected = stmt.executeUpdate(query);

							if (LinesAffected != 1)
							{
								out.println("<center>") ;

								out.println("<center><font color=red>Problem updating the database<br></font>") ;

								out.println("</center>") ;
							}
						}

						out.println("<br>Done") ;

						out.println("<br><br><A HREF=\"admin.jsp\">Continue</A>") ;
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

