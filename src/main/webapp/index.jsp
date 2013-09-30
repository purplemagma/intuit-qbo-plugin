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
      var v3ServiceUrl;
      
      xhrget = function(url, callback) {
        var oReq = new XMLHttpRequest();
        oReq.onload = function() { if (this.readyState == 4) {callback(this)} };
        oReq.open("get", url, true);
        oReq.setRequestHeader("V3ServiceUrl", v3ServiceUrl);
        oReq.send();
      }
        // QBO will call you back when the channel is ready. Good place for initialization code
        qboXDMReady = function() {
          qboXDM.getContext(function(context) {
            // Demonstrate access to qbo context
            document.getElementById("id").innerHTML = context.qbo.realmId;
            document.getElementById("company").innerHTML = context.qbo.companyName;
            document.getElementById("firstname").innerHTML = context.qbo.user.firstName;
            document.getElementById("lastname").innerHTML = context.qbo.user.lastName;
            v3ServiceUrl = context.qbo.v3ServiceBaseUrl;

            // Get current status of oAuth from my server
            document.getElementById("oAuth").innerHTML = "Getting...";
            xhrget("rest/oAuthStatus", function(response) {
                  if (response.status == 200) {
                      document.getElementById("oAuth").innerHTML = "Ok";
                  } else {
                      document.getElementById("oAuth").innerHTML = "None";
                  }
            });

            // Open trowser example
            var baseUrl = document.location.origin + document.location.pathname.substr(0,document.location.pathname.lastIndexOf("/"));
            document.getElementById("openTrowser").onclick = function () {
                qboXDM.openTrowser("xdmtrowser://"+baseUrl+"/trowser.jsp");
            };
            
            // Get new oAuth 
            document.getElementById("getNewOAuthButton").onclick = function () {
              document.getElementById("oAuth").innerHTML = "Getting...";
              xhrget("rest/NewoAuth", function(response) {
                  if (response.status == 200) {
                      document.getElementById("oAuth").innerHTML = "Ok";
                  } else {
                      document.getElementById("oAuth").innerHTML = "Error";
                  }
              });
            };
            
            document.getElementById("countCustomersButton").onclick = function () {
              document.getElementById("customerCount").innerHTML = "Getting...";
              xhrget("rest/customerCount", function(response) {
                  if (response.status == 200) {
                      document.getElementById("customerCount").innerHTML = response.responseText;
                  } else {
                      document.getElementById("customerCount").innerHTML = "Error";
                  }
              });
            };
          });
        }
    </script>
    <div class="pageContent" style="margin: 10px;">
      <div style="border-style: solid; border-width: 1px; margin: 10px; padding: 10px;">
          Company Id: <span id="id" style="font-weight:bold;">loading...</span><br/>
          Company Name: <span id="company" style="font-weight:bold;">loading...</span><br/>
          Hello, <span id="firstname" style="font-weight:bold;">loading...</span>&nbsp;<span id="lastname">loading...</span>
      </div>
      <div style="border-style: solid; border-width: 1px; margin: 10px; padding: 10px;">
          oAuth: <span id="oAuth" style="font-weight:bold;">none</span><br/>
          <button class="button" id="getNewOAuthButton">Get New oAuth</button>
      </div>      
      
      <div style="border-style: solid; border-width: 1px; margin: 10px; padding: 10px;">
        Sample v3 Service call: <b>select count(*) from customer</b><br/>
        Result: <span id="customerCount" style="font-weight:bold;">None</span><br/>
        <button class="button" id="countCustomersButton">Do Customer Count</button>
      </div>      

      <button class="button primary" id="openTrowser">Open trowser</button>
    </div>
  </body>
</html>