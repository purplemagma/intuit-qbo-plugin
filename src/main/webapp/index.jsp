<?xml version="1.0" encoding="UTF-8" ?> 
<html
  xmlns:jsp="http://java.sun.com/JSP/Page"
  xmlns:c="http://java.sun.com/jsp/jstl/core"
  xmlns:fn="http://java.sun.com/jsp/jstl/functions" >
  <head>
    <jsp:directive.page contentType="text/html;charset=UTF-8"></jsp:directive.page> 
    <!-- Just include this wad of javascript in your page. -->
    <script type="text/javascript">
        window.addEventListener("message",function(a){if(a.origin.indexOf("intuit.com")>=1&&a.data&&a.data.initXDM)
        {var b=document.createElement("script");b.setAttribute("type","text/javascript");b.innerHTML=a.data.initXDM;
         document.getElementsByTagName("head")[0].appendChild(b)}});
    </script>
  </head>
  <body bgcolor="white">
    <script type="text/javascript">
        // QBO will call you back when the channel is ready 
        function qboXDMReady() {
          qboXDM.getContext(function(context) {
            document.getElementById("id").innerHTML = context.qbo.realmId;
            document.getElementById("company").innerHTML = context.qbo.companyName;
            document.getElementById("firstname").innerHTML = context.qbo.user.firstName;
            document.getElementById("lastname").innerHTML = context.qbo.user.lastName;

            var baseUrl = document.location.origin + document.location.pathname.substr(0,document.location.pathname.lastIndexOf("/"));
              
            document.getElementById("openTrowser").onclick = function () {
                qboXDM.openTrowser("xdmtrowser://"+baseUrl+"/trowser.html");
            };
          });
        }
    </script>
    <div class="pageContent" style="margin: 10px;">
      Company Id: <span id="id">loading</span><br/>
      Company Name: <span id="company">loading</span><br/>
      Hello, <span id="firstname">loading</span>&nbsp;<span id="lastname">loading</span><br/><br/>
    <button class="button primary" id="openTrowser">Open trowser</button>
    </div>
  </body>
</html>