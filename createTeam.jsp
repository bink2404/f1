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
	String inTeamName = request.getParameter("teamName") ;
	StringBuffer dbTeamName = new StringBuffer() ;
	ResultSet rs, rs1 ;
	String query ;
	String insert ;
	int i, j ;

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
				if ((inTeamName == null) || inTeamName.equals(""))
				{
					// Check to see if the user already has the maximum number of teams allowed
					query = "SELECT COUNT(*) AS rowcount FROM f1_userteam WHERE userId = " + session.getValue("sessionId") ;

					rs = stmt.executeQuery(query);

					out.println("<center>") ;

					if (rs.next())
					{
						if (rs.getInt("rowcount") == 3)
						{
							out.println("<br><br>You already have the maximum number of teams allowed for a user<br><br>") ;

							out.println("<br><A HREF=\"login.jsp?log=x&id=" + session.getValue("sessionId") + "\">Continue</A>") ;
						}
						else
						{
							out.println("<center>") ;

							out.println("<br>Enter the team name") ;
							out.println("<form action=\"createTeam.jsp\" method=\"post\" name=\"createForm\"><table><tr><td><b>Team name</b>    <td><input type=\"text\" name=\"teamName\"></table><br><input type=\"submit\" value=\"Create team\"></form>") ;
		
							out.println("</center>") ;
						}
					}
					else
					{
						out.println("<center>") ;

						out.println("<br><br>Enter the team name") ;
						out.println("<form action=\"createTeam.jsp\" method=\"post\" name=\"createForm\"><table><tr><td><b>Team name</b>    <td><input type=\"text\" name=\"teamName\"></table><br><input type=\"submit\" value=\"Create team\"></form>") ;

						out.println("</center>") ;
					}
				}
				else
				{
					// Check for invalid characters
					for (i = 0 ; i < inTeamName.length() ; i++)
					{
						dbTeamName.append(inTeamName.charAt(i)) ;

						if (inTeamName.charAt(i) == '\'')
						{
							dbTeamName.append('\'') ;
						}
					}

					// Now check to see it's not all spaces.
					for (j = 0 ; j < inTeamName.length() ; j++)
					{
						if (inTeamName.charAt(j) != ' ')
						{
							break ;
						}
					}

					if (j == inTeamName.length())
					{
						out.println("<center><br><font color=red>Team name contains invalid characters<br></font>") ;
					}
					else
					{
						// Check to see if the user already has a team with this name
						query = "SELECT COUNT(*) AS rowcount FROM f1_userteam WHERE userId = " + session.getValue("sessionId") + " and userTeamName = '" + dbTeamName + "'" ;

						rs = stmt.executeQuery(query);

						out.println("<center>") ;

						if (rs.next())
						{
							if (rs.getInt("rowCount") > 0)
							{
								out.println("<br><br><font color=red>You already have a team with that name<br></font>") ;
							}
							else
							{
								// Insert team
								query = "SELECT MAX(teamId) AS maxId FROM f1_userteam" ;

								rs = stmt.executeQuery(query) ;

								rs.next();

								int insertTeamId = rs.getInt("maxId") + 1 ;

								insert = "INSERT INTO f1_userteam (userId, userTeamName, teamId) VALUES (" + session.getValue("sessionId") + ", '" + dbTeamName + "', " + insertTeamId + ")" ;

								int LinesAffected = stmt.executeUpdate(insert);

								out.println("<center>") ;

								if (LinesAffected != 1)
								{
									out.println("<br><font color=red>Problem creating team, try again later</font>") ;
								}
								else
								{
									out.println("<br>Team name " + inTeamName + " created successfully<br>") ;
								}
							}

							out.println("<br><A HREF=\"login.jsp?log=x&id=" + session.getValue("sessionId") + "\">Continue</A>") ;

							con.close() ;
							response.sendRedirect("login.jsp?log=x&id=1");
						}
					}
				}

				out.println("</center>") ;
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
