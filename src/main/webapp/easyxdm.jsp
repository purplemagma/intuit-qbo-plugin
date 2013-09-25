<?xml version="1.0" encoding="UTF-8" ?> 
<html
  xmlns:jsp="http://java.sun.com/JSP/Page"
  xmlns:c="http://java.sun.com/jsp/jstl/core"
  xmlns:fn="http://java.sun.com/jsp/jstl/functions" >
  <head>
    <jsp:directive.page contentType="text/html;charset=UTF-8"></jsp:directive.page> 
    <script type="text/javascript" src="js/easyXDM/v2.4.18/easyXDM.js"><jsp:text/></script>
    <script type="text/javascript">
        var qbo = new easyXDM.Rpc({remote: document.referrer, onReady: function () {
          qbo.getContext(function (context) {
            var myRequest = new XMLHttpRequest();
            myRequest.onreadystatechange=function() {
                if (myRequest.readyState==4 && myRequest.status==200) {
                    document.getElementById("main").value = myRequest.responseText;
                }
            }
            var url = "https://qbo.local.intuit.com/qbo1/v3/company/"+context.qbo.realmId+"/companyinfo/"+context.qbo.realmId;
            document.getElementById("url").innerHTML = url;
            myRequest.open("GET",url,true);
            myRequest.withCredentials = true;
            myRequest.setRequestHeader("Content-Type","application/json");
            myRequest.setRequestHeader("Accept","application/json");
            myRequest.setRequestHeader("CsrfToken", '${cookie["qbn.ptc.tkt"].value}');
            myRequest.send();
        });
        }}, {
          remote: {
            closeTrowser: {},
            getContext: {}  
          },
          local: {}      
        });      
    </script>
  </head>
  <body bgcolor="white">
    <h2>Sample intuit.com QBO plugin</h2>
    V3 Service call to company info <div id="url">...</div><br/>
    <textarea id="main" disabled="true" rows="30" cols="80">Loading...</textarea>
  </body>
</html>
