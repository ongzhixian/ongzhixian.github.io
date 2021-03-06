package jacon;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
// import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
// import java.net.MalformedURLException;
// import java.net.ProtocolException;
import java.net.URL;
import org.json.simple.JSONObject;



public class ApiHelper {

    public static void MyGETRequest() throws IOException {

        URL urlForGetRequest = new URL("https://us-central1-zxshell.cloudfunctions.net/hello_world?name=javathehut");
        String readLine = null;
        HttpURLConnection conection = (HttpURLConnection) urlForGetRequest.openConnection();
        conection.setRequestMethod("GET");
        // Set header info
        conection.setRequestProperty("name", "jaba a1bcdef"); // set userId its a sample here
        
        int responseCode = conection.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conection.getInputStream()));
            StringBuffer response = new StringBuffer();
            while ((readLine = in.readLine()) != null) {
                response.append(readLine);
            }
            in.close();
            // print result
            System.out.println("JSON String Result " + response.toString());
            // GetAndPost.POSTRequest(response.toString());
        } else {
            System.out.println("GET NOT WORKED");
        }
    }

    public static void POSTRequest() throws IOException {
        final String POST_PARAMS = 
        "{" +
        "    \"msg\" : \"workding post to httpurlconnection\"" +
        "}";
        
        // creating JSONObject 
        JSONObject jo = new JSONObject(); 
          
        // putting data to JSONObject 
        jo.put("msg", "using simple json object");


        // "{\n" + "\"userId\": 101,\r\n" +
        //     "    \"id\": 101,\r\n" +
        //     "    \"title\": \"Test Title\",\r\n" +
        //     "    \"body\": \"Test Body\"" + "\n}";

        System.out.println(POST_PARAMS);
        URL obj = new URL("https://asia-east2-zxshell.cloudfunctions.net/tea_message");
        HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
        postConnection.setRequestMethod("POST");
        postConnection.setRequestProperty("userId", "a1bcdefgh");
        postConnection.setRequestProperty("Content-Type", "application/json");
        postConnection.setDoOutput(true);
        OutputStream os = postConnection.getOutputStream();
        //os.write(POST_PARAMS.getBytes());
        os.write(jo.toJSONString().getBytes());
        os.flush();
        os.close();
        int responseCode = postConnection.getResponseCode();
        System.out.println("POST Response Code :  " + responseCode);
        System.out.println("POST Response Message : " + postConnection.getResponseMessage());
        if (responseCode == HttpURLConnection.HTTP_CREATED) { //success
            BufferedReader in = new BufferedReader(new InputStreamReader(
                postConnection.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = in .readLine()) != null) {
                response.append(inputLine);
            } in .close();
            // print result
            System.out.println(response.toString());
        } else {
            System.out.println(responseCode);
            System.out.println("POST NOT WORKED");
        }
    }

    public void DoWork() {
        try {
            ApiHelper.MyGETRequest();

            ApiHelper.POSTRequest();
        } catch (Exception e) {
            //TODO: handle exception
            System.out.println(e);
        }
        

    }
}