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
	import = "com.clix.*"
	import = "javax.mail.*"
	import = "javax.mail.internet.*"
%>

<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<meta http-equiv="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">

<title>FantasySportNet - Formula 1</title>

<meta name="keywords" content="fantasy, sports, sport, fantasy sport, fantasy league, fantasy manager, game, games, free, soccer, football, premiership, footy, fantasysportnet, motor racing, formula one, formula 1, formula1, f1, european championship, champions league, england, world cup, FA cup, goalkeeper, centre forward, defender, free kick, penalty, yellow card, red card, pele, maradonna, thierry henry, man utd">
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
	String inId = request.getParameter("id") ;
	ResultSet rs ;
	String query ;
	String insert ;
	int i = 0 ;
	String name = null ;
	String email = null ;
	String password = null ;
	boolean found = false ;
	StringWriter sw = new StringWriter(); 
	PrintWriter pw = new PrintWriter(sw);

	try
	{
%>
		<%@ include file="connection.txt" %>
<%

		java.sql.Statement stmt = con.createStatement();

		out.println("<center>") ;

		SendMailBean mail = null ;

		query = "SELECT emailAddress FROM epl_user WHERE userId > 7999 AND userId < 8210" ;

		rs = stmt.executeQuery(query);

		while (rs.next())
		{ 
			try 
			{ 
				i++ ;

				email = rs.getString("emailAddress") ;

				mail = new SendMailBean(); 

				mail.setHost("localhost"); 
				mail.setAuthenticate(true); 
				mail.setUserName("fantas15"); 
				mail.setPassword("joburg86"); 
				mail.setFrom("fantasysportnet@mail.com"); 

				mail.addTo(email); 

				mail.setSubject("fantasysportnet F1 game"); 
				mail.setBody("Check out this year's fantasysportnet F1 game.<br><br>It's free to play, so pit your wits against players from around the world<br><br><A HREF=\"http://www.fantasysportnet.com/f1/login.jsp\">http://www.fantasysportnet.com/f1/login.jsp</A>") ; 
				mail.setHTML(true); 

				mail.send();

				out.println("<br>" + i + " Mail sent.<br>") ;
			} 
			catch(Exception e) 
			{ 
				out.println("Problem " + i) ;
				continue ;
			} 
		}

		out.println("</center>") ;
	}
	catch (Exception e)
	{
		out.println("<table border=\"0\" width=\"65%\" height=\"1\" cellpadding=\"2\">") ;
			out.println("<tr>") ;
			out.println("<td width=\"100%\" height=\"1\" bgcolor=\"#FFFFFF\" align=center><font color=\"#000000\"><A HREF=\"login.jsp\">Home</A></font></td>") ;
			out.println("</tr>") ;
		out.println("</table>") ;

		out.println("<br><br>Problem reading the database") ;
		out.println(e) ;
	}
%>

<br><br>

<%@ include file="footer.txt" %>

</center>
</div>

</body>

</html>


