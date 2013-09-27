<?xml version="1.0" encoding="UTF-8" ?> 
<html
  xmlns:jsp="http://java.sun.com/JSP/Page"
  xmlns:c="http://java.sun.com/jsp/jstl/core"
  xmlns:fn="http://java.sun.com/jsp/jstl/functions" >
  <head>
    <jsp:directive.page contentType="text/html;charset=UTF-8"></jsp:directive.page> 
  </head>
  <body bgcolor="white">
    <h2>Sample intuit.com QBO plugin</h2>
    Frame origin: <div id="frameOrigin">...</div><br/>
    
    <div style="float: left">
        V3 Service call to company info via XHR<div id="urlLabelV3">...</div><br/>
        <textarea id="V3Result" disabled="true" rows="60" cols="80">Loading...</textarea><br/>
    </div>
    <div>
        Neo Service call to user profile info via XHR<div id="urlLabelUserInfo">...</div><br/>
        <textarea id="userInfoResult" disabled="true" rows="60" cols="80">Loading...</textarea><br/>
    </div>
    <script type="text/javascript">
      function xhr(url, responseElementId) {
            var myRequest = new XMLHttpRequest();
            myRequest.onreadystatechange=function() {
                if (myRequest.readyState==4 && myRequest.status==200) {
                    var result = JSON.stringify(JSON.parse(myRequest.responseText), null, 4);
                    document.getElementById(responseElementId).value = result;
                }
            }
            myRequest.open("GET",url,true);
            myRequest.withCredentials = true;
            myRequest.setRequestHeader("Content-Type","application/json");
            myRequest.setRequestHeader("Accept","application/json");
            myRequest.setRequestHeader("CsrfToken", '${cookie["qbn.ptc.tkt"].value}');
            myRequest.send();
      }

      document.getElementById("frameOrigin").innerHTML = location.href;
      var parts = document.referrer.split("/");
      var baseUrl = parts[0]+"//"+parts[2]+"/"+parts[3].replace("c","qbo");
      
       // V3 Service call
       var url = baseUrl+'/v3/company/${cookie["qbn.ptc.parentid"].value}/companyinfo/${cookie["qbn.ptc.parentid"].value}';
       document.getElementById("urlLabelV3").innerHTML = url;
       xhr(url, "V3Result");

      // user profile call     
       var url = baseUrl+'/neoservice/authmgmt/userProfile';
       document.getElementById("urlLabelUserInfo").innerHTML = url;
       xhr(url, "userInfoResult");
      
    </script>
  </body>
</html>
