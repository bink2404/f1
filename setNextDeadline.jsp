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

<p><center>

<%@ include file="header.txt" %>

<%@ include file="url.txt" %>

<% 
	String submit = request.getParameter("submit") ;
	String save = request.getParameter("save") ;
	String team = request.getParameter("team") ;
	String deadline = request.getParameter("deadline") ;
	ResultSet rs, rs1, rs2, rs3 ;
	int iWeekNum ;
	int numPlayers ;
	int messageCount ;
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
				if ((deadline == null) || (deadline.equals("")))
				{
					query = "SELECT nextDeadline FROM f1_admin WHERE updating >= 0" ;

					rs = stmt.executeQuery(query);

					rs.next() ;

					// Get the deadline to set
					out.println("<form action=\"setNextDeadline.jsp\" method=\"post\"><table><br>Deadline ... <input type=\"text\" value=\"" + rs.getString("nextDeadline") + "\" name=\"deadline\"></table><br><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;

					out.println("<br><br><A HREF=\"admin.jsp\">Back</A>") ;
				}
				else
				{
					// Now set the week
					query = "UPDATE f1_admin SET nextDeadline = '" + deadline + "'";

					LinesAffected = stmt.executeUpdate(query);

					if (LinesAffected != 1)
					{
						out.println("<center>") ;

						out.println("<center><font color=red>Problem updating the database<br></font>") ;

						out.println("</center>") ;
					}

					out.println("<br>Done") ;

					out.println("<br><br><A HREF=\"admin.jsp\">Continue</A>") ;
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

