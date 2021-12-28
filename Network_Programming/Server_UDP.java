import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.util.ArrayList;
import java.util.List;

class ServerThread implements Runnable{

    private final int bufferSize = 256;

    File folder = new File("/Users/nahalkhalkhali/Dropbox/MSWE/SWE242P/Module 3");
   
    public void run(){

        //ByteArrayOutputStream bufferarray = new ByteArrayOutputStream(bufferSize);

        try {
            DatagramSocket socket = new DatagramSocket(6666);
            System.out.println("Server is running...");

            while(true){
                byte[] buffer = new byte[bufferSize];
                DatagramPacket packet = new DatagramPacket(buffer, buffer.length);
                try {
                    socket.receive(packet);
                    InetAddress address = packet.getAddress();
                    int port = packet.getPort();
                    String line = new String(packet.getData(),0,packet.getLength(),"ASCII");

                    if(line.equals("index")){
                        int index_count = 0;
                        String[] fileList = folder.list();
                        for(int i = 0; i < fileList.length; i++){
                            if(fileList[i].contains(".txt")){
                                ++index_count;
                                byte[] data = fileList[i].getBytes();
                                packet = new DatagramPacket(data, data.length, address, port);
                                socket.send(packet); 
                            }
                        }

                        String c1 = String.valueOf(index_count);
                        c1 = "Counter:" + c1;
                        byte[] counter1 = c1.getBytes();
                        packet = new DatagramPacket(counter1, counter1.length, address, port);
                        socket.send(packet);

                        byte[] data = "END OF LIST".getBytes();
                        packet = new DatagramPacket(data, data.length, address, port);
                        socket.send(packet); 
                    }

                    else if(line.contains("get")){
                        int get_counter = 0;
                        String getfile = line.substring(3);
                        String fString = getfile.substring(1, getfile.length()-1);

                        File[] files = folder.listFiles();
                        for(int i = 0; i < files.length; i++){
                            if(fString.equals(files[i].getName())){
                                byte[] start_data = "OK: FILE PRINTING...".getBytes();
                                packet = new DatagramPacket(start_data, start_data.length, address, port);
                                socket.send(packet); 
                                BufferedReader fileIn = new BufferedReader(new FileReader(files[i]));
                                while(true){
                                    String new_line = fileIn.readLine();
                                    ++get_counter;
                                    if(new_line == null){
                                        byte[] end_data = "END OF FILE".getBytes();
                                        packet = new DatagramPacket(end_data, end_data.length, address, port);
                                        socket.send(packet);
                                        break;
                                    }
                                    byte[] data = new_line.getBytes();
                                    packet = new DatagramPacket(data, data.length, address, port);
                                    socket.send(packet);
                                }
                                
                                String c1 = String.valueOf(get_counter);
                                c1 = "Counter:" + c1;
                                byte[] counter1 = c1.getBytes();
                                packet = new DatagramPacket(counter1, counter1.length, address, port);
                                socket.send(packet);                                
                            }
                        }
                        byte[] error_data = "ERROR FILE DOES NOT EXIST...".getBytes();
                        packet = new DatagramPacket(error_data, error_data.length, address, port);
                        socket.send(packet);
                        break;
        
                    }

                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            socket.close();
        } catch (SocketException e) {
        }

    }

}

public class Server {
    public static void main(String[] args) {
        Thread t = new Thread(new ServerThread());
        t.start();
    }  
}
