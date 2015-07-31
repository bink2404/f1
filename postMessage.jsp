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
<br><br>

<%@ include file="url.txt" %>

<% 
	String inGroupId = request.getParameter("groupId") ;
	String inSubject = request.getParameter("subject") ;
	String inText = request.getParameter("text") ;
	String submit = request.getParameter("submit") ;
	String inRe = request.getParameter("re") ;
	ResultSet rs, rs1 ;
	String insert ;
	String query ;
	StringBuffer writeSubject = new StringBuffer() ;
	StringBuffer writeText = new StringBuffer() ;
	String playerName ;
	int i ;
	int messageCount ;
	int mId ;
	StringBuffer reSubject = new StringBuffer("") ;
	StringBuffer printSubject = new StringBuffer("") ;
	boolean isMember = false ;
	int id ;

	try
	{
		if ((submit != null) && submit.equals("Cancel"))
		{
			response.sendRedirect("messageBoard.jsp?groupId=" + inGroupId);
			return ;
		}

		if ((session.getValue("sessionId") == "0") || (session.getValue("sessionId") == null))
		{
			out.println("<br><br>You are logged-out, please sign in to continue") ;
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
				out.println("<br><br>The database is being updated, please try again later") ;
			}
			else
			{
				if (!inGroupId.equals("-1"))
				{
					// Check to see that you're a member of this group
					query = "SELECT userId from f1_userteam WHERE groupID = " + inGroupId ;

					rs = stmt.executeQuery(query);

					while (rs.next())
					{
						id = rs.getInt("userId") ; 

						if (id == Integer.parseInt(String.valueOf(session.getValue("sessionId"))))
						{
							isMember = true ;
							break ;
						}	
					}
				}

				if ((!inGroupId.equals("-1")) && (isMember == false))
				{
					out.println("<br><br>You are not a member of this group<br>") ;
				}
				else
				{
					if ((inSubject == null) || inSubject.equals(""))
					{
						if ((null != inRe) && (!inRe.equals("")))
						{
							query = "SELECT messageSubject FROM f1_messageboard WHERE groupId = " + inGroupId + " AND messageId = " + inRe ;

							rs = stmt.executeQuery(query);

							if (rs.next())
							{
								String reText = rs.getString("messageSubject") ;

								// Set up re: text
								if ((reText.length() < 3) || !reText.substring(0, 3).equals("re:"))
								{
									reSubject = reSubject.append("re: " + reText) ;
								}
								else
								{
									reSubject = reSubject.append(reText) ;
								}
							}

							for (i = 0 ; i < reSubject.length() ; i++)
							{
								if (reSubject.charAt(i) == '\"')
								{
									printSubject.append("''") ;
								}
								else
								{
									printSubject.append(reSubject.charAt(i)) ;
								}
							}
						}

						out.println("<form action=\"postMessage.jsp\" method=\"post\" name=\"messageForm\"><table><tr><td><b>Subject</b>    <td><input type=\"text\" name=\"subject\" value=\"" + printSubject + "\" size=60><tr><td><b>Text</b>    <td><textarea name=\"text\" rows=10 cols=60></textarea></table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"> <input type=\"submit\" name=\"submit\" value=\"Cancel\"><input type=\"hidden\" name=\"groupId\" value=\"" + inGroupId + "\"></form>") ;

						if ((null != inRe) && (!inRe.equals("")))
						{
							out.println("<script>putFocus(0,1);</script>") ;
						}
						else
						{
							out.println("<script>putFocus(0,0);</script>") ;
						}
					}
					else
					{
						// Check for invalid characters
						for (i = 0 ; i < inSubject.length() ; i++)
						{
							writeSubject.append(inSubject.charAt(i)) ;

							if (inSubject.charAt(i) == '\'')
							{
								writeSubject.append('\'') ;
							}
						}

						for (i = 0 ; i < inText.length() ; i++)
						{
							writeText.append(inText.charAt(i)) ;

							if (inText.charAt(i) == '\'')
							{
								writeText.append('\'') ;
							}
						}

						if (writeSubject.length() > 0)
						{
							// Find the signed-on user's name
							query = "SELECT name from f1_user WHERE userId = " + String.valueOf(session.getValue("sessionId")) ;

							rs = stmt.executeQuery(query);

							rs.next() ;

							playerName = rs.getString("name") ;

							// Get the date/time and convert it to GMT 
							java.text.DateFormat format = java.text.DateFormat.getDateTimeInstance( 
								                java.text.DateFormat.MEDIUM, java.text.DateFormat.MEDIUM); 

							format.setCalendar(java.util.Calendar.getInstance(java.util.TimeZone.getTimeZone("GMT+0"))); 

							java.util.Date date = new java.util.Date(); 
    
							String s = format.format(date) + " (GMT)" ;     

							// Get the total number of messages for this group
							query = "SELECT COUNT(*) AS messageCount FROM f1_messageboard WHERE groupId = " + inGroupId ;

							rs = stmt.executeQuery(query);

							rs.next() ;
						
							messageCount = rs.getInt("messageCount") ;

							if (messageCount >= 25)
							{
								// Max is 25 messages per group. Delete the oldest.
								query = "SELECT MIN(messageId) AS mId FROM f1_messageboard WHERE groupId = " + inGroupId ;

								rs = stmt.executeQuery(query) ;

								rs.next();

								mId = rs.getInt("mId") ;

								query = "DELETE FROM f1_messageboard WHERE groupId = " + inGroupId + " AND messageId = " + mId ;

								stmt.executeUpdate(query);
							}

							// Now get the next id and insert the new record
							query = "SELECT MAX(messageId) AS mId FROM f1_messageboard WHERE groupId = " + inGroupId ;

							rs = stmt.executeQuery(query) ;

							rs.next();

							mId = (rs.getInt("mId") + 1) ;

							if ((inGroupId == null) || inGroupId.equals(""))
							{
								insert = "INSERT INTO f1_messageboard (messageId, groupId, playerName, messageSubject, messageDateTime, messageText) VALUES ('" + mId + "', '0', '" + playerName + "', '" + writeSubject + "', '" + s + "', '" + writeText + "')" ;
							}
							else
							{
								insert = "INSERT INTO f1_messageboard (messageId, groupId, playerName, messageSubject, messageDateTime, messageText) VALUES ('" + mId + "', '" + inGroupId + "', '" + playerName + "', '" + writeSubject + "', '" + s + "', '" + writeText + "')" ;
							}

							int LinesAffected = stmt.executeUpdate(insert);

						}

						con.close() ;
						response.sendRedirect("messageBoard.jsp?groupId=" + inGroupId);
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
