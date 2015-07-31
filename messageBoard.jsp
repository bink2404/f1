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

</head>

<script language=javascript>
function window.onload()
{
	if (window.messageForm)
		window.messageForm.subject.focus();
}
</script>

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
	String displayId = request.getParameter("displayId") ;
	ResultSet rs ;
	String query ;
	String messageSubject ;
	String playerName ;
	String messageDateTime ;
	String messageText ;
	StringBuffer writeText = new StringBuffer() ;
	String mId ;
	String groupName ;
	int i ;

	try
	{
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
				out.println("<br><br>The database is being updated, please try again later<br>") ;
			}
			else
			{
				out.println("<br>") ;

				if (!inGroupId.equals("-1"))
				{
					query = "SELECT groupName FROM f1_groupname WHERE groupId = " + inGroupId ;

					rs = stmt.executeQuery(query);

					rs.next() ;

					groupName = rs.getString("groupName") ;

					out.println("<b>Messages for <A HREF=\"group.jsp?id=" + inGroupId + "\">" + groupName + "</A></b>") ;
				}
				else
				{
					out.println("<b>Messages</b>") ;
				}

				out.println("<br><br><A HREF=\"postMessage.jsp?groupId=" + inGroupId + "\">Post a message</A>") ;

				if ((displayId != null) && (!displayId.equals("")))
				{
					// Show the message selected
					query = "SELECT playerName, messageSubject, messageText, messageDateTime FROM f1_messageboard WHERE groupId = " + inGroupId + " AND messageId = " + displayId ;

					rs = stmt.executeQuery(query);

					if (rs.next())
					{
						out.println("<br><br><table border=\"0\" width=\"65%\" height=\"1\" cellpadding=\"2\">") ;

						playerName = rs.getString("playerName") ;
						messageSubject = rs.getString("messageSubject") ;
						messageText = rs.getString("messageText") ;
						messageDateTime = rs.getString("messageDateTime") ;

						out.println("<tr>") ;
						out.println("<td height=\"1\" bgcolor=\"#FFFFFF\" align=left><font color=\"#000000\"><b>" + messageSubject + "  </b><A HREF=\"postMessage.jsp?groupId=" + inGroupId + "&re=" + displayId + "\">reply</A></font></td>") ;
						out.println("</tr>") ;

						out.println("<tr>") ;
						out.println("<td height=\"1\" bgcolor=\"#FFFFFF\" align=left><font color=\"#000000\">Posted by " + playerName + " on " + messageDateTime + "</font></td>") ;
						out.println("</tr>") ;

						out.println("<tr>") ;
						out.println("</tr>") ;
						out.println("<tr>") ;
						out.println("</tr>") ;

						// Replace any newline chars with a linebreak
						for (i = 0 ; i < messageText.length() ; i++)
						{
							if (messageText.charAt(i) == '\n')
							{
								writeText.append("<br>") ;
							}
							else
							{
								writeText.append(messageText.charAt(i)) ;
							}
						}

						out.println("<tr>") ;
						out.println("<td height=\"1\" bgcolor=\"#FFFFFF\" align=left><font color=\"#000000\">" + writeText + "</font></td>") ;
						out.println("</tr>") ;
						out.println("<td> ") ;
						out.println("</td>") ;
						out.println("<tr>") ;
						out.println("<td>") ;
						out.println("</td>") ;
						out.println("</tr>") ;
						out.println("</table>") ;

						out.println("<br><img border=0 width=528 height=11 src=\"images/line.gif\">") ;
					}
				}

				out.println("<br><br><table border=\"0\" width=\"65%\" height=\"1\" cellpadding=\"2\">") ;

				query = "SELECT playerName, messageSubject, messageDateTime, messageId FROM f1_messageboard WHERE groupId = " + inGroupId + " ORDER BY messageId DESC" ;

				rs = stmt.executeQuery(query);

				while (rs.next())
				{
					playerName = rs.getString("playerName") ;
					messageSubject = rs.getString("messageSubject") ;
					messageDateTime = rs.getString("messageDateTime") ;
					mId = rs.getString("messageId") ;

					out.println("<tr>") ;
					out.println("<td height=\"1\" bgcolor=\"#FFFFFF\" align=left><font color=\"#000000\"><A HREF=\"messageBoard.jsp?groupId=" + inGroupId + "&displayId=" + mId + "\">" + messageSubject + "</A> (" + playerName + ") " + messageDateTime + "</font></td>") ;
					out.println("<tr>") ;
					out.println("</tr>") ;
				}

				out.println("</table>") ;
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
