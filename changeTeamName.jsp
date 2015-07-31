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
	String teamid = request.getParameter("teamid") ;
	String teamName = request.getParameter("teamname") ;
	String submit = request.getParameter("submit") ;
	ResultSet rs, rs1 ;
	String query ;
	int ownerId ;
	int LinesAffected ;
	int i = 0, j = 0 ;
	StringBuffer dbTeamName = new StringBuffer() ;

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

			query = "SELECT updating FROM f1_admin WHERE updating >= 0" ;

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
				// Make sure that he owns the team
				java.sql.Statement stmt2 = con.createStatement();

				// Get the owner
				query = "SELECT userId FROM f1_userteam WHERE teamId = " + teamid ;

				rs1 = stmt2.executeQuery(query);

				rs1.next() ;

				if (rs1.getInt("userId") != Integer.parseInt(String.valueOf(session.getValue("sessionId"))))
				{
					out.println("<center>") ;

					out.println("<center><br><font color=red>You are not the owner of this team<br></font>") ;

					out.println("</center>") ;
				}
				else
				{
					if ((teamName == null) || (teamName.equals("")))
					{
						// Find the current team name
						query = "SELECT userTeamName FROM f1_userteam WHERE teamId = " + teamid ;

						rs = stmt.executeQuery(query);

						rs.next() ;

						teamName = rs.getString("userTeamName") ;

						for (i = 0 ; i < teamName.length() ; i++)
						{
							if (teamName.charAt(i) == '\"')
							{
								dbTeamName.append("''") ;
							}
							else
							{
								dbTeamName.append(teamName.charAt(i)) ;
							}
						}

						out.println("<center><br>") ;

						out.println("<form action=\"changeTeamName.jsp\" method=\"post\" name=\"changeForm\"><table><tr><td><b>Team name</b>    <td><input type=\"text\" name=\"teamname\" value=\"" + dbTeamName + "\"><input type=\"hidden\" name=\"teamid\" value=\"" + teamid + "\" readonly></table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;

						out.println("</center>") ;
					}
					else
					{
						out.println("<center>") ;

						// Make sure that he owns the team
						java.sql.Statement stmt1 = con.createStatement();

						// Get the existing name
						query = "SELECT userId FROM f1_userteam WHERE teamId = " + teamid ;

						rs1 = stmt1.executeQuery(query);

						rs1.next() ;

						if (rs1.getInt("userId") != Integer.parseInt(String.valueOf(session.getValue("sessionId"))))
						{
							out.println("<center>") ;

							out.println("<center><br><font color=red>You are not the owner of this team<br></font>") ;

							out.println("</center>") ;
						}
						else
						{
							// Check for invalid characters
							for (i = 0 ; i < teamName.length() ; i++)
							{
								dbTeamName.append(teamName.charAt(i)) ;
	
								if (teamName.charAt(i) == '\'')
								{
									dbTeamName.append('\'') ;
								}
							}

							// Now check to see it's not all spaces.
							for (j = 0 ; j < teamName.length() ; j++)
							{
								if (teamName.charAt(j) != ' ')
								{
									break ;
								}
							}

							if (j == teamName.length())
							{
								out.println("<center><br><font color=red>Invalid team name<br></font>") ;
							}
							else
							{
								// Check to see if the user already has a team with this name
								query = "SELECT COUNT(*) AS rowcount FROM f1_userteam WHERE userId = " + session.getValue("sessionId") + " AND userTeamName = '" + dbTeamName + "' AND teamId <> " + teamid ;

								rs = stmt.executeQuery(query);

								out.println("<center>") ;

								if (rs.next())
								{
									if (rs.getInt("rowCount") > 0)
									{
										out.println("<br><font color=red>You already have a team with that name<br></font>") ;
									}
									else
									{
										// Change the team name
										query = "UPDATE f1_userteam SET userTeamName = '" + dbTeamName + "' WHERE teamId = " + teamid ;

										LinesAffected = stmt.executeUpdate(query);

										if (LinesAffected != 1)
										{
											out.println("<center>") ;

											out.println("<center><font color=red>Problem changing the team name, try again later<br></font>") ;

											out.println("</center>") ;
										}
										else
										{
											con.close() ;
											response.sendRedirect("login.jsp?log=x&id=1");
										}
									}
								}
							}
						}
					}
				}
			}

			con.close() ;
		}
	}
	catch (Exception e)
	{
		out.println("<br>Problem reading the database - try again later<br><br><br>") ;
		//out.println(e) ;
	}
%>

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

