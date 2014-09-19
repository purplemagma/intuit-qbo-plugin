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
      xhrget = function(url, callback) {
        var oReq = new XMLHttpRequest();
        oReq.onload = function() { if (this.readyState == 4) {callback(this)} };
        oReq.open("get", url, true);
        oReq.send();
      };
      saveTryCount = 0;
      qboXDMReceiveMessage = function(message,s,f) {
        console.log("Received a message:");
        console.log(message);
        if (message) {
          if (message.eventName === "qbo-action-settings-dirty_check") {
            var dirtyAction = getRadioValue("settingsDirtyCheck");
            if (dirtyAction === "settingsDirtySuccess") {
              s({result: document.getElementById("settingsDirtyModel").checked});
            }
            if (dirtyAction === "settingsDirtyFailure") {
              f();
            }
            if (dirtyAction === "settingsDirtyTimeout") {
              // just waiting
            }
          }
          if (message.eventName === "qbo-action-settings-switch") {
            if (message.data.editMode) {
              document.getElementById("settingsStatus").innerHTML = new Date().getTime() + " Edit mode on";
            } else {
              document.getElementById("settingsStatus").innerHTML = new Date().getTime() + " Edit mode off";
            }
          }
          if (message.eventName === "qbo-action-settings-save") {
            var saveAction = getRadioValue("settingsSaveStatus");
            if (saveAction === "settingsSaveValidationFailure") {
              document.getElementById("settingsStatus").innerHTML = new Date().getTime() + " Validation failure! Edit mode on";
              f({handled: true});
            } else {
              document.getElementById("settingsStatus").innerHTML = new Date().getTime() + " Edit mode on";
            }
            if (saveAction === "settingsSaveSuccess") {
              s();
            }
            if (saveAction === "settingsSaveError") {
              f({message: "Failed to save your data in plugin!"});
            }
            if (saveAction === "settingsSaveTimeout") {
              // nothing, just waiting
            }
            if (saveAction === "settingsSaveTakesLong") {
              if (saveTryCount == 0) {
                setTimeout(f.bind(this, {extend: true}), message.data.timeout - 500);
                saveTryCount++;
              } else if (saveTryCount == 1) {
                setTimeout(s.bind(this), (message.data.timeout - 500));
                saveTryCount = 0;
              }
            }
            if (saveAction === "settingsSaveTakesTooLong") {
              if (saveTryCount == 0) {
                setTimeout(f.bind(this, {extend: true}), message.data.timeout - 500);
                saveTryCount++;
              } else if (saveTryCount == 1) {
                setTimeout(f.bind(this, {extend: true}), (message.data.timeout - 500));
                saveTryCount++;
              } else if (saveTryCount == 2) {
                setTimeout(f.bind(this, {extend: true}), (message.data.timeout - 500));
                saveTryCount = 0;
              }
            }
          }
        }
      };

      function getRadioValue(theRadioGroup) {
        var elements = document.getElementsByName(theRadioGroup);
        for (var i = 0, l = elements.length; i < l; i++)
        {
          if (elements[i].checked)
          {
            return elements[i].value;
          }
        }
      };
        // QBO will call you back when the channel is ready. Good place for initialization code
        qboXDMReady = function() {
          qboXDM.getContext(function(context) {
            // Demonstrate access to qbo context
            document.getElementById("id").innerHTML = context.qbo.realmId;
            document.getElementById("company").innerHTML = context.qbo.companyName;
            document.getElementById("firstname").innerHTML = context.qbo.user.firstName;
            document.getElementById("lastname").innerHTML = context.qbo.user.lastName;

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
            var path = document.location.pathname.substr(1,document.location.pathname.lastIndexOf("/")),
                baseUrl = document.location.origin+"/"+path,
                element;
            document.getElementById("navigateTrowser").onclick = function () {
                qboXDM.navigate("xdmtrowser://"+path+"trowser.jsp");
            };
            // Close trowser, available only if page is opened inside of a trowser
            if (context.qbo.trowser) {
              element = document.getElementById("closeTrowser");
              element.style.visibility = "visible";
              element.onclick = function () {
                  qboXDM.closeTrowser();
              };
            }
            // switches app to activated state on QBO side, doesn't affect IPP
            document.getElementById("activate").onclick = function () {
              qboXDM.updateAppSubscriptionState(function(){console.log("activate success");}, function(){console.log("activate failure");});
            };
            document.getElementById("navigate").onclick = function () {
              qboXDM.navigate(document.getElementById("navigateUrl").value);
            };
            document.getElementById("openDialog").onclick = function () {
              qboXDM.showDialog(document.getElementById("openDialogId").value);
            };
            document.getElementById("showMessage").onclick = function () {
              qboXDM.showPageMessage(document.getElementById("showMessageText").value, document.getElementById("showMessageAlert").checked);
            };
            document.getElementById("subscribe").onclick = function () {
              qboXDM.subscribe(document.getElementById("subscribePlanId").value, function(){console.log("subscribe success");}, function(){console.log("subscribe failure");});
            };
            document.getElementById("settingsDone").onclick = function () {
              setTimeout(qboXDM.emitEvent.bind(this, "close-settings-section"), 50);
            };
            document.getElementById("showSpinner").onclick = function () {
              qboXDM.showSpinner(function(response){console.log(response);});
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
        };
    </script>
    <div class="pageContent" style="margin: 10px;">
      <div style="border-style: solid; border-width: 1px; margin: 10px; padding: 10px;">
          Company Id: <span id="id" style="font-weight:bold;">loading...</span><br/>
          Company Name: <span id="company" style="font-weight:bold;">loading...</span><br/>
          Hello, <span id="firstname" style="font-weight:bold;">loading...</span>&nbsp;<span id="lastname" style="font-weight:bold;">loading...</span>
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

      <button class="button primary" id="navigateTrowser">Open trowser</button>
      <br/>
      <br/>
      <input type="text" id="navigateUrl">
      <button class="button primary" id="navigate">Navigate</button>
      <br/>
      <br/>
      <select id="openDialogId">
        <option value="qbo/lists/name/customer/CustomerDialogViewController" selected="selected">qbo/lists/name/customer/CustomerDialogViewController</option>
        <option value="qbo/lists/name/vendor/VendorDialogViewController">qbo/lists/name/vendor/VendorDialogViewController</option>
        <option value="qbo/lists/name/employee/EmployeeDialogViewController">qbo/lists/name/employee/EmployeeDialogViewController</option>
        <option value="qbo/lists/taxcode/TaxCodeDialogViewController">qbo/lists/taxcode/TaxCodeDialogViewController</option>
      </select>
      <button class="button primary" id="openDialog">Open dialog</button>
      <br/>
      <br/>
      <input type="text" id="showMessageText">
      <input type="checkbox" id="showMessageAlert"> (Alert)
      <button class="button primary" id="showMessage">Show Message</button>
      <br/>
      <br/>
      <button class="button primary" id="activate">Update subscription status</button>
      <br/>
      <br/>
      PlanId:<input type="text" id="subscribePlanId">
      <button class="button primary" id="subscribe">Subscribe</button>
      <br/>
      <br/>
      <button class="button primary" id="closeTrowser" style="visibility: hidden;">Close trowser</button>
      <br/>
      <br/>
      <button class="button primary" id="showSpinner">Show Spinner</button>
      Settings section
      <div>
        Status: <span id="settingsStatus"></span>
        <br/>
        <input type="checkbox" id="settingsDirtyModel"> Dirty model
        <br/>
        <input type="radio" name="settingsDirtyCheck" value="settingsDirtySuccess" checked> Successfull check for dirty model
        <br/>
        <input type="radio" name="settingsDirtyCheck" value="settingsDirtyFailure"> Failed check for dirty model
        <br/>
        <input type="radio" name="settingsDirtyCheck" value="settingsDirtyTimeout"> Timed out check for dirty model
        <br/>
        <input type="radio" name="settingsSaveStatus" value="settingsSaveSuccess" checked> Simulate save success
        <br/>
        <input type="radio" name="settingsSaveStatus" value="settingsSaveError"> Simulate save error
        <br/>
        <input type="radio" name="settingsSaveStatus" value="settingsSaveTimeout"> Simulate save timeout
        <br/>
        <input type="radio" name="settingsSaveStatus" value="settingsSaveTakesLong"> Simulate save taking more than timeout
        <br/>
        <input type="radio" name="settingsSaveStatus" value="settingsSaveTakesTooLong"> Simulate save taking more than cut off timeout
        <br/>
        <input type="radio" name="settingsSaveStatus" value="settingsSaveValidationFailure"> Simulate handled validation failure
        <br/>
        <button class="button primary" id="settingsDone">Done</button>
      </div>
    </div>
  </body>
</html>