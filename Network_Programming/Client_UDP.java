import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.net.UnknownHostException;

public class Client {
    public final static int port = 6666;
    public final static int MAX_PACKET_SIZE = 65507;
    public final static String hostName = "localhost";

    public static void main(String[] args) throws IOException {

        byte[] buffer = new byte[MAX_PACKET_SIZE];

        try {
            DatagramSocket socket = new DatagramSocket();
            InetAddress host = InetAddress.getByName(hostName);
            
            while(true){
                System.out.println("Pick 'index' or 'get<file.txt>'.");
                BufferedReader userInput = new BufferedReader(new InputStreamReader(System.in));
                String line = userInput.readLine();

                if(line.equals("index")){
                    int index_counter = 0;
                    byte[] data = line.getBytes();
                    DatagramPacket out = new DatagramPacket(data, data.length,host,port);
                    socket.send(out);
                    try {
                        System.out.println("List of Files: ");
                        DatagramPacket in = new DatagramPacket(buffer, buffer.length);
                        while(true){
                            socket.receive(in);
                            String resp = new String(in.getData(), 0, in.getLength(), "ASCII");
                            ++index_counter;
                            if(resp.contains("Counter:")){
                                String c2 = resp.substring(8);
                                index_counter = index_counter - 1;
                                String c1 = String.valueOf(index_counter);
                                if(!c1.equals(c2)){
                                    System.out.println("ERROR IN TRANSFERING DATA PACKAGES");
                                    break;
                                }
                            }
                            if(resp.equals("END OF LIST")){
                                System.out.println(resp);
                                in.setLength(buffer.length);
                                break;
                            }
                            else{
                                System.out.println(resp);
                                in.setLength(buffer.length);
                            }
                        }
                    } catch (IOException e) {
                        System.out.println(e.getMessage());
                    }
                }

                else if(line.startsWith("get")){
                    int get_counter = 0;
                    byte[] data = line.getBytes();
                    DatagramPacket out = new DatagramPacket(data, data.length,host,port);
                    socket.send(out);

                    DatagramPacket in = new DatagramPacket(buffer, buffer.length);
                    while(true){
                        socket.receive(in);
                        String resp = new String(in.getData(), 0, in.getLength(), "ASCII");
                        ++get_counter;
                        System.out.println(resp);
                        in.setLength(buffer.length);
                        if(resp.equals("ERROR FILE DOES NOT EXIST...")){
                            socket.close();
                        }
                        if(resp.equals("END OF FILE")){
                            socket.receive(in);
                            String c1 = new String(in.getData(), 0, in.getLength(), "ASCII");
                            c1 = c1.substring(8);
                            String c2 = String.valueOf(get_counter-1);
                            System.out.println(c2);
                            if(!c1.equals(c2)){
                                System.out.println("ERROR IN TRANSFERING DATA PACKAGES");
                            }
                            socket.close();
                        }

                    }
                }

            }                  
        } catch (SocketException e) {
            System.err.println(e.getMessage());
        } 
    }
}
