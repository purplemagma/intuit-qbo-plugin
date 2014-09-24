package com.codenvy;

import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import com.amazonaws.util.json.JSONException;
import com.amazonaws.util.json.JSONObject;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpParams;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class AppListener implements ServletContextListener
{
  private final static String VCAP_APPLICATION = "VCAP_APPLICATION";
  private final static String PROXY_BASE_POSTFIX = ".intuit.com";
  private final static String PROXY_UPDATE_URL = "http://proxy.codenvy.purplemagma.com/update_uri/";
  
  private static String codeEnvyProxyPrefix;
  private static String defaultAppRunUrl;
  private static String defaultProxyPrefix;
  
  /*
   * Check for the cloud foundry app run url in system environment properties - only works on codenvy
   */
  public static String getCodenvyAppRunUrl() {
      String appInstance = System.getenv(VCAP_APPLICATION);
      String appUrl = null;
      
      if (appInstance != null) {
        try {
          JSONObject appInstanceObj = new JSONObject(appInstance);
          appUrl = appInstanceObj.getJSONArray("uris").getString(0);
        } catch (JSONException ex) {
          
        }
      }
      
      return appUrl;
    
  }
  
  /*
   * Returns true if running inside codenvy
   */
  public static boolean isRunningInCodenvy() {
    return System.getenv(VCAP_APPLICATION) != null;
  }
  
  /*
   * Gets the url of where the app is running. In codenvy, read it from properties
   * In Amazon, it is specified in web.xml
   */
  public static String getAppRunUrl() {
    return isRunningInCodenvy() ? getCodenvyAppRunUrl() : defaultAppRunUrl;
  }
  
  /*
   * Get the url of the proxy server (e.g. aws.payroll.purplemagma.com)
   */
  public static String getProxyHost() {
    String prefix = isRunningInCodenvy() ? codeEnvyProxyPrefix : defaultProxyPrefix;
    return prefix+PROXY_BASE_POSTFIX;
  }
    
  public static void updateProxyUrl() {
    try {
      HttpParams httpParams = new BasicHttpParams();
      httpParams.setIntParameter("http.connection.timeout", 5000);
      httpParams.setIntParameter("http.socket.timeout", 5000);
      HttpClient httpClient = new DefaultHttpClient(httpParams);
      HttpGet httpGet = new HttpGet(PROXY_UPDATE_URL+getProxyHost()+".."+getAppRunUrl());
      httpClient.execute(httpGet);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  public void contextInitialized(ServletContextEvent event) {
    defaultAppRunUrl = event.getServletContext().getInitParameter("defaultAppRunUrl");
    codeEnvyProxyPrefix = event.getServletContext().getInitParameter("codEnvyProxyPrefix");
    defaultProxyPrefix = event.getServletContext().getInitParameter("defaultProxyPrefix");
    
    AppListener.updateProxyUrl();
  }
  
  public void contextDestroyed(ServletContextEvent event) {
  }
}
