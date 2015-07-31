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
	String emailAddress = request.getParameter("email") ;
	String inUserId = request.getParameter("id") ;
	String inPassword1 = request.getParameter("password1") ;
	String inPassword2 = request.getParameter("password2") ;
	String submit = request.getParameter("submit") ;
	ResultSet rs ;
	int i ;

	try
	{
%>
		<%@ include file="connection.txt" %>
<%

		java.sql.Statement stmt = con.createStatement();

		String query = "SELECT updating FROM f1_admin WHERE updating >= 0" ;

		rs = stmt.executeQuery(query);

		rs.next() ;

		if (rs.getInt("updating") == 1)
		{
			out.println("<center>") ;

			out.println("<br><br>The database is being updated, please try again later") ;
		}
		else
		{
			if ((inUserId == null) || inUserId.equals("") || (emailAddress == null) || emailAddress.equals(""))
			{
				out.println("<form action=\"signup.jsp\" method=\"post\" name=\"signupForm\"><table><tr><td><b>i.d.</b>    <td><input type=\"text\" name=\"id\"><tr><td><b>e-mail address</b>    <td><input type=\"text\" name=\"email\"><tr><td><b>Password</b>    <td><input type=\"password\" name=\"password1\"><tr><td><b>Re-Type Password</b>    <td><input type=\"password\" name=\"password2\"></table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;

				if ((submit != null) && (!submit.equals("")) && submit.equals("Submit"))
				{
					out.println("<font color=red>The i.d. and e-mail address must be entered</font>") ;
				}
			}
			else
			{
				// Check for invalid characters
				for (i = 0 ; i < inUserId.length() ; i++)
				{
					if (inUserId.charAt(i) == '\'')
					{
						break ;
					}
				}

				if (i < inUserId.length())
				{
					// Invalid chars
					out.println("<form action=\"signup.jsp\" method=\"post\" name=\"signupForm\"><table><tr><td><b>i.d.</b>    <td><input type=\"text\" name=\"id\"><tr><td><b>e-mail address</b>    <td><input type=\"text\" name=\"email\"><tr><td><b>Password</b>    <td><input type=\"password\" name=\"password1\"><tr><td><b>Re-Type Password</b>    <td><input type=\"password\" name=\"password2\"></table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;

					out.println("<font color=red>The i.d. or password contains invalid characters</font>") ;
				}
				else
				{
					if (!inPassword1.equals(inPassword2) || (inPassword1 == null) || (inPassword2 == null) ||
						"".equals(inPassword1) || "".equals(inPassword2))
					{
						// Passwords must match
						out.println("<form action=\"signup.jsp\" method=\"post\" name=\"signupForm\"><table><tr><td><b>i.d.</b>    <td><input type=\"text\" name=\"id\"><tr><td><b>e-mail address</b>    <td><input type=\"text\" name=\"email\"><tr><td><b>Password</b>    <td><input type=\"password\" name=\"password1\"><tr><td><b>Re-Type Password</b>    <td><input type=\"password\" name=\"password2\"></table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;

						out.println("<font color=red>Passwords must be entered, and must match</font>") ;
					}
					else
					{
						query = "SELECT name FROM f1_user WHERE name = '" + inUserId + "'" ;

						rs = stmt.executeQuery(query);

						if (rs.next() != false)
						{
							out.println("<center>") ;

							out.println("<form action=\"signup.jsp\" method=\"post\" name=\"signupForm\"><table><tr><td><b>i.d.</b>    <td><input type=\"text\" name=\"id\"><tr><td><b>e-mail address</b>    <td><input type=\"text\" name=\"email\"><tr><td><b>Password</b>    <td><input type=\"password\" name=\"password1\"><tr><td><b>Re-Type Password</b>    <td><input type=\"password\" name=\"password2\"></table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;

							out.println("<font color=red>i.d. already exists</font>") ;
						}
						else
						{
							// Get the max userId
							query = "SELECT MAX(userId) AS maxId FROM f1_user" ;

							rs = stmt.executeQuery(query) ;

							rs.next();

							int id = rs.getInt("maxId") + 1 ;

							String insert = "INSERT INTO f1_user (userId, password, emailAddress, name) VALUES ('" + id + "', '" + inPassword1 + "', '" + emailAddress + "', '" + inUserId + "')" ;

							int LinesAffected = stmt.executeUpdate(insert);

							if (LinesAffected != 1)
							{
								out.println("<center>") ;

								out.println("<form action=\"signup.jsp\" method=\"post\" name=\"signupForm\"><table><tr><td><b>i.d.</b>    <td><input type=\"text\" name=\"id\"><tr><td><b>e-mail address</b>    <td><input type=\"text\" name=\"email\"><tr><td><b>Password</b>    <td><input type=\"password\" name=\"password1\"><tr><td><b>Re-Type Password</b>    <td><input type=\"password\" name=\"password2\"></table><br><input type=\"submit\" name=\"submit\" value=\"Submit\"></form>") ;

								out.println("<font color=red>Problem inserting i.d., try again later</font>") ;
							}
							else
							{
								out.println("<br><br><br>Congratulations, your i.d. has been created.<br><br>Click below to log-in and start creating your teams.") ;
								out.println("<br><br><A HREF=\"login.jsp\">Continue</A>") ;

								session.putValue("sessionId", new Integer(id)) ;
								session.putValue("sessionPw", inPassword1) ;

								con.close() ;
								response.sendRedirect("login.jsp?log=x&id=1");
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
