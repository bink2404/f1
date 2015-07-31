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

<p><center>

<%@ include file="header.txt" %>

<%@ include file="url.txt" %>

<% 
	String submit = request.getParameter("submit") ;
	String save = request.getParameter("save") ;
	String team = request.getParameter("team") ;
	String weekNum = request.getParameter("weekNum") ;
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
			out.println("<br><br><A HREF=\"login.jsp\">Sign In</A>") ;

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
				if ((weekNum == null) || (weekNum.equals("")))
				{
					query = "SELECT weekNum FROM f1_admin WHERE weekNum > 0" ;

					rs = stmt.executeQuery(query);

					rs.next() ;

					// Get the week to set
					out.println("<form action=\"setWeek.jsp\" method=\"post\"><table><br>Week ... <input type=\"text\" value=\"" + rs.getInt("weekNum") + "\" name=\"weekNum\"></table><br><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;

					out.println("<br><br><A HREF=\"admin.jsp\">Back</A>") ;
				}
				else
				{
					// Now set the week
					query = "UPDATE f1_admin SET weekNum = " + weekNum ;

					LinesAffected = stmt.executeUpdate(query);

                                        iWeekNum = Integer.valueOf(weekNum).intValue() - 1 ;

					query = "CREATE TABLE f1_driver" + iWeekNum + " SELECT * FROM f1_driver_blank" ;

					out.println(query) ;

					stmt.executeUpdate(query);

                                        query = "CREATE TABLE f1_raceteam" + iWeekNum + " SELECT * FROM f1_raceteam_blank" ;

					out.println(query) ;

					stmt.executeUpdate(query);

                                        query = "CREATE TABLE f1_userteam" + iWeekNum + " SELECT * FROM f1_userteam" ;

					out.println(query) ;

					stmt.executeUpdate(query);

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

