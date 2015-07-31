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
	String id = request.getParameter("id") ;
	String userName = request.getParameter("userName") ;
	String eMail = request.getParameter("eMail") ;
	String currentPassword = request.getParameter("currentPassword") ;
	String password1 = request.getParameter("password1") ;
	String password2 = request.getParameter("password2") ;
	String submit = request.getParameter("submit") ;
	ResultSet rs, rs1 ;
	String query ;
	int i, j ;
	int LinesAffected ;
	boolean goAhead = true ;

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
				if (String.valueOf(session.getValue("sessionId")).equals(id) != true)
				{
					out.println("<center>") ;

					out.println("<br><br><font color=red>Invalid id</font>") ;

					out.println("</center>") ;
				}
				else
				{
					if ((submit == null) || (submit.equals("")) || (userName == null) || (userName.equals("")) ||
						(eMail == null) || (eMail.equals("")))
					{
						// Find the current user name and e-mail address
						query = "SELECT name, emailAddress FROM f1_user WHERE userId = " + id ;

						rs = stmt.executeQuery(query);

						rs.next() ;

						userName = rs.getString("name") ;
						eMail = rs.getString("emailAddress") ;

						out.println("<center>") ;

						out.println("<form action=\"changeInfo.jsp\" method=\"post\" name=\"changeForm\"><table><tr><td><b>User name</b>    <td><input type=\"text\" name=\"userName\" value=\"" + userName + "\"><tr><td><b>e-mail address</b>    <td><input type=\"text\" name=\"eMail\" value=\"" + eMail + "\"><tr><td><tr><td><tr><td><tr><td><input type=\"hidden\" name=\"id\" value=\"" + id + "\" readonly><tr><td><b>Current password</b>    <td><input type=\"password\" name=\"currentPassword\"><tr><td><b>New password</b>    <td><input type=\"password\" name=\"password1\"><tr><td><b>Re-Type Password</b>    <td><input type=\"password\" name=\"password2\"></table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;

						out.println("</center>") ;
					}
					else
					{
						out.println("<center>") ;

						// Check to see if the user name is being changed to an existing name
						String currentName ;

						java.sql.Statement stmt1 = con.createStatement();

						// Get the existing name
						query = "SELECT name FROM f1_user WHERE userId = " + session.getValue("sessionId") ;

						rs1 = stmt1.executeQuery(query);

						rs1.next() ;

						currentName = rs1.getString("name") ;

						if (!currentName.equals(userName))
						{
							query = "SELECT name FROM f1_user WHERE name = '" + userName + "'" ;

							rs1 = stmt1.executeQuery(query);

							if (rs1.next())
							{
								out.println("<center>") ;

								out.println("<form action=\"changeInfo.jsp\" method=\"post\" name=\"changeForm\"><table><tr><td><b>User name</b>    <td><input type=\"text\" name=\"userName\" value=\"" + userName + "\"><tr><td><b>e-mail address</b>    <td><input type=\"text\" name=\"eMail\" value=\"" + eMail + "\"><tr><td><tr><td><tr><td><tr><td><input type=\"hidden\" name=\"id\" value=\"" + id + "\" readonly><tr><td><b>Current password</b>    <td><input type=\"password\" name=\"currentPassword\"><tr><td><b>New password</b>    <td><input type=\"password\" name=\"password1\"><tr><td><b>Re-Type Password</b>    <td><input type=\"password\" name=\"password2\"></table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;
								out.println("<center><font color=red>The user name already exists<br></font>") ;

								out.println("</center>") ;

								goAhead = false ;
							}
						}

						// First change the password details
						if ((goAhead == true) && (currentPassword != null) && (!currentPassword.equals("")))
						{
							// Check for invalid characters
							for (i = 0 ; i < password1.length() ; i++)
							{
								if (password1.charAt(i) == '\'')
								{
									break ;
								}
							}

							if (i < password1.length())
							{
								out.println("<center>") ;

								out.println("<form action=\"changeInfo.jsp\" method=\"post\" name=\"changeForm\"><table><tr><td><b>User name</b>    <td><input type=\"text\" name=\"userName\" value=\"" + userName + "\"><tr><td><b>e-mail address</b>    <td><input type=\"text\" name=\"eMail\" value=\"" + eMail + "\"><tr><td><tr><td><tr><td><tr><td><input type=\"hidden\" name=\"id\" value=\"" + id + "\" readonly><tr><td><b>Current password</b>    <td><input type=\"password\" name=\"currentPassword\"><tr><td><b>New password</b>    <td><input type=\"password\" name=\"password1\"><tr><td><b>Re-Type Password</b>    <td><input type=\"password\" name=\"password2\"></table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;
								out.println("<center><font color=red>The password contains invalid characters<br></font>") ;

								out.println("</center>") ;

								goAhead = false ;
							}
							else
							{
								if (!password1.equals(password2) || (password1 == null) || (password1.equals("")) ||
									(password2 == null) || (password2.equals("")))
								{
									// Passwords must match
									out.println("<form action=\"changeInfo.jsp\" method=\"post\" name=\"changeForm\"><table><tr><td><b>User name</b>    <td><input type=\"text\" name=\"userName\" value=\"" + userName + "\"><tr><td><b>e-mail address</b>    <td><input type=\"text\" name=\"eMail\" value=\"" + eMail + "\"><tr><td><tr><td><tr><td><tr><td><input type=\"hidden\" name=\"id\" value=\"" + id + "\" readonly><tr><td><b>Current password</b>    <td><input type=\"password\" name=\"currentPassword\"><tr><td><b>New password</b>    <td><input type=\"password\" name=\"password1\"><tr><td><b>Re-Type Password</b>    <td><input type=\"password\" name=\"password2\"></table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;
									out.println("<font color=red>Passwords must be entered, and must match</font>") ;

									goAhead = false ;
								}
								else
								{
									// Check that the old password is correct
									query = "SELECT password FROM f1_user WHERE userId = " + id ;

									rs = stmt.executeQuery(query);

									if (rs.next() == false)
									{
										// User not found
										out.println("<form action=\"changeInfo.jsp\" method=\"post\" name=\"changeForm\"><table><tr><td><b>User name</b>    <td><input type=\"text\" name=\"userName\" value=\"" + userName + "\"><tr><td><b>e-mail address</b>    <td><input type=\"text\" name=\"eMail\" value=\"" + eMail + "\"><tr><td><tr><td><tr><td><tr><td><input type=\"hidden\" name=\"id\" value=\"" + id + "\" readonly><tr><td><b>Current password</b>    <td><input type=\"password\" name=\"currentPassword\"><tr><td><b>New password</b>    <td><input type=\"password\" name=\"password1\"><tr><td><b>Re-Type Password</b>    <td><input type=\"password\" name=\"password2\"></table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;
										out.println("<font color=red>User not found</font>") ;

										goAhead = false ;
									}
									else
									{
										if (!rs.getString("password").equals(currentPassword))
										{
											// Password doesn't match
											out.println("<form action=\"changeInfo.jsp\" method=\"post\" name=\"changeForm\"><table><tr><td><b>User name</b>    <td><input type=\"text\" name=\"userName\" value=\"" + userName + "\"><tr><td><b>e-mail address</b>    <td><input type=\"text\" name=\"eMail\" value=\"" + eMail + "\"><tr><td><tr><td><tr><td><tr><td><input type=\"hidden\" name=\"id\" value=\"" + id + "\" readonly><tr><td><b>Current password</b>    <td><input type=\"password\" name=\"currentPassword\"><tr><td><b>New password</b>    <td><input type=\"password\" name=\"password1\"><tr><td><b>Re-Type Password</b>    <td><input type=\"password\" name=\"password2\"></table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;
											out.println("<font color=red>Incorrect current password</font>") ;

											goAhead = false ;
										}
										else
										{
											// Change the password
											query = "UPDATE f1_user SET password = '" + password1 + "' WHERE userId = " + id ;

											LinesAffected = stmt.executeUpdate(query);

											session.putValue("sessionPw", password1) ;
										}
									}
								}
							}
						}

						if (goAhead == true)
						{
							// Now update the other values
							// Check for invalid characters
							for (i = 0 ; i < userName.length() ; i++)
							{
								if (userName.charAt(i) == '\'')
								{
									break ;
								}
							}

							for (j = 0 ; j < eMail.length() ; j++)
							{
								if (eMail.charAt(j) == '\'')
								{
									break ;
								}
							}

							if ((i < userName.length()) || (j < eMail.length()))
							{
								out.println("<center>") ;

								out.println("<form action=\"changeInfo.jsp\" method=\"post\" name=\"changeForm\"><table><tr><td><b>User name</b>    <td><input type=\"text\" name=\"userName\" value=\"" + userName + "\"><tr><td><b>e-mail address</b>    <td><input type=\"text\" name=\"eMail\" value=\"" + eMail + "\"><tr><td><tr><td><tr><td><tr><td><input type=\"hidden\" name=\"id\" value=\"" + id + "\" readonly><tr><td><b>Current password</b>    <td><input type=\"password\" name=\"currentPassword\"><tr><td><b>New password</b>    <td><input type=\"password\" name=\"password1\"><tr><td><b>Re-Type Password</b>    <td><input type=\"password\" name=\"password2\"></table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;
								out.println("<center><font color=red>The user name or email address contains invalid characters<br></font>") ;

								out.println("</center>") ;
							}
							else
							{
								query = "UPDATE f1_user SET name = '" + userName + "', emailAddress = '" + eMail + "' WHERE userId = " + id ;

								LinesAffected = stmt.executeUpdate(query);

								out.println("<br><br>Your details have been changed<br>") ;

								out.println("<br><A HREF=\"login.jsp?log=x&id=" + session.getValue("sessionId") + "\">Continue</A>") ;

								out.println("</center>") ;
							}
						}
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