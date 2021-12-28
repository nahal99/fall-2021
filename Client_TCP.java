import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;

//https://docs.oracle.com/javase/tutorial/networking/sockets/readingWriting.html

public class Client {
    public static void main(String[] args) throws IOException {
        String hostName = "localhost"; //127.0.0.1 
        int port = Integer.parseInt(args[0]);

        try {
            Socket socket = new Socket(hostName, port);
            OutputStream out = socket.getOutputStream();
            InputStream in = socket.getInputStream();
            handle(in, out);
            socket.close();
            // PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
            // BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        } catch (Exception e) {
            //TODO: handle exception
            System.out.println("Error: " + e.getMessage());
        }

    }
    
    public static void handle(InputStream in, OutputStream out) throws IOException{
        // OutputStreamWriter  writer = new OutputStreamWriter(out, "ASCII");
        // InputStreamReader reader = new InputStreamReader(in, "ASCII");

        BufferedReader reader = new BufferedReader(new InputStreamReader(in, "ASCII"));
        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(out, "ASCII"));

        while(true){
            System.out.println("Pick 'index' or 'get<file.txt>'.");
            BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));

            String line = stdIn.readLine();

            if(line.equals("index")){
                writer.write(line + "\r\n");
                writer.flush();

                String resp = reader.readLine();
                System.out.println("List of Files: " + resp);
            }

            else if(line.startsWith("get")){
                writer.write(line + "\r\n");
                writer.flush();

                while(true){
                    String resp = reader.readLine();
                    if(resp.equals("ERROR FILE DOES NOT EXIST...")){
                        System.out.println(resp);
                        break;
                    }
                    System.out.println(resp);
                    if(resp.equals("END OF FILE")){
                        break;
                    }
                }
                reader.close();
                writer.close();
                break;
            }
 
        }
    }
}
