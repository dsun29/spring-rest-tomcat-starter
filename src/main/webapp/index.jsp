<%@ page language="java"  %>
<%@ page session ="true"%>
<%@ page import = "java.net.*" %>
<%@ page import = "java.lang.String" %>
<%@ page import = "javax.servlet.http.Cookie" %>
<%@ page import="edu.olemiss.ws.*" %>
<%@ page import="com.mysap.sso.SSO_Authenticate" %>

<%
    SSO_Authenticate auth = new SSO_Authenticate();
    if (!auth.authenticate(request)) {
        out.write("Session expired. Please log on to <a href=\"http://myu.umc.edu\">MyU Portal</a> again.");
        return;
    }

    String referer = (String)request.getHeader("Referer");

    if (referer == null) {
        out.write("Session expired. Please start over" );
        return;
    }

    if (!(referer.startsWith("https://umepd1.olemiss.edu") ||
            referer.startsWith("https://umepp1.olemiss.edu") ||
            referer.startsWith("https://umepp2.olemiss.edu") ||
            referer.startsWith("https://umepp3.olemiss.edu") ||
            referer.startsWith("https://umepp4.olemiss.edu") ||
            referer.startsWith("https://umepp5.olemiss.edu") ||
            referer.startsWith("https://mydev.olemiss.edu") ||
            referer.startsWith("https://my.olemiss.edu") ||
            referer.startsWith("http://mydev.olemiss.edu") ||
            referer.startsWith("https://myudev.umc.edu") ||
            referer.startsWith("https://myu.umc.edu") ||
            referer.startsWith("https://secure1.olemiss.edu") ||
            referer.startsWith("https://secure6.olemiss.edu") ||
            referer.startsWith("https://secure20.olemiss.edu") ||
            referer.startsWith("https://secure26.olemiss.edu") ||
            referer.startsWith("http://ummcepp1.olemiss.edu") ||
            referer.startsWith("https://ummcepp1.olemiss.edu") ||
            referer.startsWith("http://ummcepp2.olemiss.edu") ||
            referer.startsWith("https://ummcepp2.olemiss.edu")
    ))  {
        out.write("Invalid Referer: " + referer);
        return;
    }


    String user = (String) auth.getUserID();


%>
<!doctype html>
<html lang="en">

<head>
    <title>Main Sub Report</title>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="./public/semantic.min.css">
    <script
            src="https://code.jquery.com/jquery-3.1.1.min.js"
            integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
            crossorigin="anonymous"></script>
    <script src="./public/semantic.min.js"></script>

</head>

<body>

<div class="ui labeled icon menu">
    <a href="#" class="header item">
        Main Sub Report
    </a>

    <a class="item">
        <i class="search icon"></i>
        Search
    </a>
    <a class="item">
        <i class="Setting icon"></i>
        Fields
    </a>

</div>


</body>
</html>
