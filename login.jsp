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

<%@ include file="url.txt" %>

<% 
	String inUserId = request.getParameter("id") ;
	String inPassword = request.getParameter("password") ;
	String log = request.getParameter("log") ;
	ResultSet rs, rs1, rs2, rs3, rs4 ;
	int weekNum ;
	int gId, tId ;
	String deadline = new String() ;
	String nextDeadline = new String() ;
	int closeToDeadline = 0 ;
	int updating = 0 ;
	StringBuffer temp ;
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
		if (inUserId == null)
			inUserId = (String)request.getAttribute("id");

		if (log == null)
			log = (String)request.getAttribute("log");

		if ((inUserId == null) || inUserId.equals(""))
		{
			session.putValue("sessionId", "0") ;

%>
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
<%

			out.println("<center>") ;

			out.println("<form action=\"login.jsp\" method=\"post\" NAME=\"loginForm\"><table><tr><td><b>i.d.</b>    <td><input type=\"text\" name=\"id\"><tr><td><b>password</b>    <td><input type=\"password\" name=\"password\"></table><br><input type=\"submit\" value=\"Sign In\"><tr><td>    <td></form>") ;

			out.println("<br><br><A HREF=\"passwordReminder.jsp\">Forgot your password ?</A>") ;

			out.println("</table>") ;

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

			String query ;

%>
		<%@ include file="connection.txt" %>
<%

			java.sql.Statement stmt = con.createStatement();

			if ((log != null) && log.equals("x"))
			{
				// Already logged-in
				inUserId = String.valueOf(session.getValue("sessionId")) ;
				inPassword = String.valueOf(session.getValue("sessionPw")) ;

				query = "SELECT name, userId, password FROM f1_user WHERE userId = " + inUserId ;
			}
			else
			{
				query = "SELECT name, userId, password FROM f1_user WHERE name = '" + inUserId + "'" ;
			}

			rs = stmt.executeQuery(query);

			if (rs.next() == false)
			{
%>
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
<%
				out.println("<center>") ;

				out.println("<form action=\"login.jsp\" method=\"post\" NAME=\"loginForm\"><table><tr><td><b>i.d.</b>    <td><input type=\"text\" name=\"id\"><tr><td><b>password</b>    <td><input type=\"password\" name=\"password\"></table><br><input type=\"submit\" value=\"Sign In\"></form>") ;

				if (!inUserId.equals("0"))
				{
					out.println("<font color=red>This i.d. does not exist</font>") ;
				}

				out.println("<br><br><A HREF=\"passwordReminder.jsp\">Forgot your password ?</A>") ;

				out.println("</center>") ;
			}
			else
			{
				if (!rs.getString("password").equals(inPassword))
				{
%>
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
<%
					out.println("<center>") ;

					out.println("<form action=\"login.jsp\" method=\"post\" NAME=\"loginForm\"><table><tr><td><b>i.d.</b>    <td><input type=\"text\" name=\"id\"><tr><td><b>password</b>    <td><input type=\"password\" name=\"password\"></table><br><input type=\"submit\" value=\"Sign In\"></form>") ;

					out.println("<font color=red>Invalid password</font>") ;

					out.println("<br><br><A HREF=\"passwordReminder.jsp\">Forgot your password ?</A>") ;

					out.println("</center>") ;
				}
				else
				{
					int dbUserId = rs.getInt("userId") ;
					String name = rs.getString("name") ;

					session.putValue("sessionId", new Integer(dbUserId)) ;
					session.putValue("sessionPw", inPassword) ;
%>
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
<%

					synchronized(page)
					{
						// Compare the date / time with the deadline
						query = "SELECT weekNum, updating, deadline, nextDeadline, closeToDeadline FROM f1_admin WHERE updating >= 0" ;

						rs4 = stmt.executeQuery(query);

						rs4.next() ;

						deadline = rs4.getString("deadline") ;
						nextDeadline = rs4.getString("nextDeadline") ;
						weekNum = rs4.getInt("weekNum") ;
						closeToDeadline = rs4.getInt("closeToDeadline") ;
						updating = rs4.getInt("updating") ;

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
/*							if (hour < 12)
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

							// First update the deadline

                if (!deadline.equals(nextDeadline))
                {
							query = "UPDATE f1_admin SET deadline = '" + nextDeadline + "'" ;

							stmt.executeUpdate(query);

							deadline = nextDeadline ;

							// Now set the week num
							query = "UPDATE f1_admin SET weekNum = " + (weekNum+1) ;

							stmt.executeUpdate(query);

							// Now create the new tables
							query = "CREATE TABLE f1_driver" + weekNum + " SELECT * FROM f1_driver_blank" ;

							stmt.executeUpdate(query);

							// Now create the new tables
							query = "CREATE TABLE f1_raceteam" + weekNum + " SELECT * FROM f1_raceteam_blank" ;

							stmt.executeUpdate(query);

							query = "CREATE TABLE f1_userteam" + weekNum + " SELECT * FROM f1_userteam" ;

							stmt.executeUpdate(query);

							weekNum++ ;

							// Now set the updating flags back to zero
							query = "UPDATE f1_admin SET updating = 0, closeToDeadline = 0" ;

							stmt.executeUpdate(query);

							updating = 0 ;
							closeToDeadline = 0 ;
                }
						}
						else
						{
							// Check to see if the deadline is close
							if ((year == dyear) && (month == dmonth) && (day == (dday-1)) && 
								(AMPM.toString().equals("PM") && (hour >= 10)))
							{
								query = "UPDATE f1_admin SET closeToDeadLine = 1 WHERE updating >= 0" ;

								stmt.executeUpdate(query);

								closeToDeadline = 1 ;
							}
						}
					}

					java.sql.Statement stmt2 = con.createStatement();

					query = "SELECT weekNum FROM f1_admin WHERE weekNum > 0" ;

					rs2 = stmt2.executeQuery(query);

					rs2.next() ;

					weekNum = rs2.getInt("weekNum") ;

//					int dbUserId = rs.getInt("userId") ;

					out.println("<b>Welcome, " + name + "</b><br><br>") ;

					if (dbUserId == -1)
					{
						con.close() ;
						response.sendRedirect("admin.jsp");
					}

					query = "SELECT userTeamName, teamId, groupId FROM f1_userteam WHERE userId = " + dbUserId ;

					rs = stmt.executeQuery(query);
%>


<div align="center">
<center>
	<table border="0" width="65%" height="1" cellpadding="2">
    <tr>
      <td width="25%" height="1" bgcolor="#001480"><font color="#FFFFFF"><b>My Teams</b></font></td>
	  <td width="15%" height="1" bgcolor="#001480"><font color="#FFFFFF"><b>Points</b></font></td>
      <td width="60%" height="1" bgcolor="#001480"><font color="#FFFFFF"><b>Leagues</b></font></td>
    </tr>

<% 
					java.sql.Statement stmt1 = con.createStatement();

					int totTeams ;
					int teamPos ;
					int count = 0 ;

					while (rs.next())
					{
						count++ ;

						gId = rs.getInt("groupId") ;
						tId = rs.getInt("teamId") ;

						out.println("<tr>") ;
							out.println("<td width=\"25%\" height=\"28\" bgcolor=\"#E0E0E0\"><A HREF=\"team.jsp?id=" + tId + "&weekNum=" + weekNum + "\">" + rs.getString("userTeamName") + "</A> </td>") ;

						query = "SELECT score FROM f1_userteam WHERE teamId = " + tId ; 

						rs1 = stmt1.executeQuery(query);

						rs1.next() ;
		
						out.println("<td width=\"15%\" height=\"28\" bgcolor=\"#E0E0E0\">" + rs1.getInt("score") + "</td>") ;

						query = "SELECT groupName, groupId FROM f1_groupname WHERE groupId = " + gId ;

						rs1 = stmt1.executeQuery(query);

						if (rs1.next())
						{
							out.println("<td width=\"60%\" height=\"28\" bgcolor=\"#E0E0E0\"><a href=\"group.jsp?id=" + rs1.getInt("groupId") + "\">" + rs1.getString("groupName") + "</A>") ;
						}

						// Find your team's position within the group
						query = "SELECT teamId, score FROM f1_userteam WHERE groupId = " + gId + " ORDER BY score DESC" ;

						if (gId != 0)
						{
							rs1 = stmt1.executeQuery(query);
						
							totTeams = 0 ;
							teamPos = 0 ;

							while (rs1.next())
							{
								totTeams++ ;

								if (rs1.getInt("teamId") == tId)
									teamPos = totTeams ;
							}

							out.println("Rank : " + teamPos + " of " + totTeams + "<br>") ;
						}
						else
						{
							out.println("<td width=\"60%\" height=\"28\" bgcolor=\"#E0E0E0\"></A>") ;
						}

						// Find your team's overall position
						query = "SELECT teamId, score FROM f1_userteam WHERE groupId >= 0 ORDER BY score DESC" ;

						rs1 = stmt1.executeQuery(query);
						
						totTeams = 0 ;
						teamPos = 0 ;

						while (rs1.next())
						{
							totTeams++ ;

							if (rs1.getInt("teamId") == tId)
								teamPos = totTeams ;
						}

						out.println("Overall : " + teamPos + " of " + totTeams) ;

						out.println("</td>") ;
						out.println("</tr>") ;
					}

					if (count == 0)
					{
						// No teams, add an empty row
						out.println("<tr>") ;
						out.println("<td width=\"25%\" height=\"28\" bgcolor=\"#E0E0E0\">-</A>") ;
						out.println("</td>") ;
						out.println("<td width=\"15%\" height=\"28\" bgcolor=\"#E0E0E0\">-</A>") ;
						out.println("</td>") ;
						out.println("<td width=\"60%\" height=\"28\" bgcolor=\"#E0E0E0\">-</A>") ;
						out.println("</td>") ;
						out.println("</tr>") ;
					}

					out.println("<tr>") ;
					out.println("</tr>") ;

					out.println("<tr>") ;
					out.println("<td>") ;
					out.println("<width=\"25%\" height=\"28\" bgcolor=\"#FFFFFF\"><a href=\"createTeam.jsp\">Create a new team</a>") ;
					out.println("</td>") ;
					out.println("<td>") ;
					out.println("<width=\"15%\" height=\"28\" bgcolor=\"#FFFFFF\">") ;
					out.println("</td>") ;
					out.println("<td") ;
					out.println("<width=\"60%\" height=\"28\" bgcolor=\"#FFFFFF\"><a href=\"createGroup.jsp\">Create a new private league</a>") ;
					out.println("</td>") ;
					out.println("</tr>") ;

					out.println("<tr>") ;
					out.println("<td>") ;
					out.println("<width=\"25%\" height=\"28\" bgcolor=\"#FFFFFF\"><a href=\"highScores.jsp\">Top 50</a>") ;
					out.println("</td>") ;
					out.println("</tr>") ;
					out.println("<tr>") ;
					out.println("<td>") ;
					out.println("<width=\"25%\" height=\"28\" bgcolor=\"#FFFFFF\"><a href=\"otherTeams.jsp\">View other teams</a>") ;
					out.println("</td>") ;
					out.println("</tr>") ;
					out.println("<tr>") ;
					out.println("<td>") ;
					out.println("<width=\"25%\" height=\"28\" bgcolor=\"#FFFFFF\"><a href=\"messageBoard.jsp?groupId=-1\">Main message board</a>") ;
					out.println("</td>") ;
					out.println("<td>") ;
					out.println("<width=\"15%\" height=\"28\" bgcolor=\"#FFFFFF\">") ;
					out.println("</td>") ;
                                        
					out.println("<td") ;
					out.println("<width=\"60%\" height=\"28\" bgcolor=\"#FFFFFF\"><font size=2 ") ;
					
					if ((closeToDeadline == 1) || (updating == 1))
					{
						out.println("color = red") ;
					}	
					
					if (updating == 0)
					{					
						out.println(">Next deadline : " + deadline + " (GMT)</font>") ;
					}
					else
					{
						out.println(">The database is being updated</font>") ;
					}

					out.println("</td>") ;
					out.println("</tr>") ;
				}
			}

			con.close() ;
		}
	}
	catch (Exception e)
	{
		out.println("<br>Problem reading the database - try again later<br><br><br>") ;
		out.println(e) ;
	}
%>
</P>

</table>

<br><br>

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

<br><br>

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
