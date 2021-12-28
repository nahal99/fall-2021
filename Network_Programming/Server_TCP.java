import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Dictionary;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Handler;

public class Server {

    static final int port = 3210;
    public static void main(String[] args) throws IOException{
        int n = Runtime.getRuntime().availableProcessors();
        ExecutorService exec = Executors.newFixedThreadPool(n);

        exec.execute(new Runnable() {
            public void run(){
                try {
                    ServerSocket ss = new ServerSocket(port);
                    System.out.println("Server is running...");
                    Socket socket = ss.accept();
                    System.out.println("Connected from " + socket.getRemoteSocketAddress());
                    InputStream in = socket.getInputStream();
                    OutputStream out = socket.getOutputStream();
                    handle(in, out, ss, socket);
                    ss.close();      
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                    System.out.println("Client disconnected");
                }

            }
        });

        exec.shutdown();
                
              
    }
    

    public static void handle(InputStream in, OutputStream out, ServerSocket ss, Socket socket) throws IOException{

        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(out, "ASCII"));
        BufferedReader reader = new BufferedReader(new InputStreamReader(in, "ASCII"));

        File folder = new File("/Users/nahalkhalkhali/Dropbox/MSWE/SWE242P/Module 3");


        while(true){
            String line = reader.readLine();

            if(line.equals("index")){
                List<String> resp = new ArrayList<String>();
                String[] fileList = folder.list();
                for(int i = 0; i < fileList.length; i++){
                    if(fileList[i].contains(".txt")){
                        resp.add(fileList[i]);
                    }
                }
                writer.write(resp + "\r\n");
                writer.flush();
            }
            
            else if(line.contains("get")) {
                String getfile = line.substring(3);
                String fString = getfile.substring(1, getfile.length()-1);

                File[] files = folder.listFiles();
                for(int i = 0; i < files.length; i++){
                    if(fString.equals(files[i].getName())){
                        writer.write("OK: FILE PRINTING..." + "\r\n");
                        writer.flush();
                        BufferedReader fileIn = new BufferedReader(new FileReader(files[i]));
                        while(true){
                            String new_line = fileIn.readLine();
                            if(new_line == null){
                                writer.write("END OF FILE" + "\r\n");
                                break;
                            }
                            writer.write(new_line + "\r\n");
                        }
                        fileIn.close();
                        writer.flush();
                    }
                }
                
                writer.write("ERROR FILE DOES NOT EXIST..."+"\r\n");
                writer.flush();
                writer.close();
                
            }

            
            
        }

    }

}
