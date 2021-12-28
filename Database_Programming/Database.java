import java.sql.*;
import java.util.Scanner;

public class Database {

    final String DB_URL = "jdbc:mysql://localhost:3306/?user=root";
    final String user_name = "root";
    final String password = "nahal2017";

    public void createDatabase(){

        try {
            //Opens a connection
            Connection connection = DriverManager.getConnection(DB_URL, user_name, password);
            Statement stmt = connection.createStatement();

            String create_datanase = "CREATE DATABASE IF NOT EXISTS db";

            String student_table = "CREATE TABLE IF NOT EXISTS db.students" + 
                                "(student_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, " +
                                "first_name VARCHAR(50) NOT NULL, " +
                                "last_name VARCHAR(50) NOT NULL)";

            String course_table = "CREATE TABLE IF NOT EXISTS db.courses" +
                                "(course_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, " +
                                "course_name VARCHAR(50) NOT NULL UNIQUE, " +
                                "course_days VARCHAR(50) NOT NULL, " +
                                "course_times VARCHAR(50) NOT NULL)";
            
            String linking_table = "CREATE TABLE IF NOT EXISTS db.linking" +
                                "(default_course_id INT NOT NULL, " +
                                "default_student_id INT NOT NULL, " +
                                "CONSTRAINT fk_course_id FOREIGN KEY (default_course_id) REFERENCES db.courses (course_id), " +
                                "CONSTRAINT fk_student_id FOREIGN KEY (default_student_id) REFERENCES db.students (student_id))";


            stmt.executeUpdate(create_datanase);
            stmt.executeUpdate(student_table);
            stmt.executeUpdate(course_table);
            stmt.executeUpdate(linking_table);

        } catch (SQLException e) {
            e.printStackTrace();
        }


    }

    public void add_student() throws SQLException {
        //Connects to database
        Connection connection = DriverManager.getConnection(DB_URL, user_name, password);

        //userinput
        System.out.println("Insert student first name and last name: (ex: John Smith)");
        Scanner resp = new Scanner(System.in);
        String[] name = resp.nextLine().split(" ");

        String add_name = "INSERT INTO db.students" +
                        "(student_id, first_name, last_name)" +
                        "VALUES" +
                        "(DEFAULT, ?, ?)";
        PreparedStatement stmt = connection.prepareStatement(add_name);

        //Statement parameters
        stmt.setString(1, name[0]);
        stmt.setString(2, name[1]);

        //Executes query
        stmt.executeUpdate();

    }

    public void add_course() throws SQLException{
         //Connects to database
         Connection connection = DriverManager.getConnection(DB_URL, user_name, password);

         //userInput
         System.out.println("Insert course name: (ex: calculus001)");
         Scanner resp = new Scanner(System.in);
         String course = resp.nextLine();
         System.out.println("Insert course days (Monday-Friday): (ex: monday, wednesday, friday) ");
         Scanner resp2 = new Scanner(System.in);
         String days = resp2.nextLine();
         System.out.println("Insert course times (8am-5pm): (ex: 8:30am-12pm) ");
         Scanner resp3 = new Scanner(System.in);
         String times = resp3.nextLine();

         String add_course = "INSERT INTO db.courses" +
                            "(course_id, course_name, course_days, course_times)" +
                            "VALUES" +
                            "(DEFAULT, ?, ?, ?)";
         PreparedStatement stmt = connection.prepareStatement(add_course);

         //Statement Parameters
         stmt.setString(1, course);
         stmt.setString(2, days);
         stmt.setString(3, times);

         //Executes query
         stmt.executeUpdate();
        
    }

    public void add_linking() throws SQLException{
        //Connects to database
        Connection connection = DriverManager.getConnection(DB_URL, user_name, password);
        Statement stmt = connection.createStatement();
        
        //print out student table
        String sql = "SELECT * " +
                    "FROM db.students";
        ResultSet rs = stmt.executeQuery(sql);
        System.out.println("STUDENT ID_____________FIRST NAME_____________LAST NAME");
        while(rs.next()){
            int student_id = rs.getInt("student_id");
            String first_name = rs.getString("first_name");
            String last_name = rs.getString("last_name");
            System.out.println(student_id+"________________________"+first_name+"_________________"+last_name);
        }
        rs.close();

        System.out.println();

        //print out course table
        String sql2 = "SELECT * " +
                    "FROM db.courses";
        ResultSet rs2 = stmt.executeQuery(sql2);
        System.out.println("COURSE ID_____________COURSE NAME_____________COURSE DAYS_____________COURSE TIMES");
        while(rs2.next()){
            int course_id = rs2.getInt("course_id");
            String course_name = rs2.getString("course_name");
            String course_days = rs2.getString("course_days");
            String course_times = rs2.getString("course_times");
            System.out.println(course_id+"____________________"+course_name+"_____________"+course_days+"_____________"+course_times);
        }
        rs2.close();

        System.out.println();

        //userInput
        System.out.println("Pick Student ID: ");
        Scanner scan = new Scanner(System.in);
        int std_id = scan.nextInt();
        System.out.println("Pick Course ID: ");
        Scanner scan2 = new Scanner(System.in);
        int crs_id = scan2.nextInt();

        String add_linking = "INSERT INTO db.linking " +
                            "(default_course_id, default_student_id)" +
                            "VALUES" +
                            "(?,?)";
        PreparedStatement pstmt = connection.prepareStatement(add_linking);

        //sets parameters
        pstmt.setInt(1, crs_id);
        pstmt.setInt(2, std_id);

        //executs query
        pstmt.executeUpdate();

    }

    public void query_courses() throws SQLException{
        //Connects to database
        Connection connection = DriverManager.getConnection(DB_URL, user_name, password);

        //userinput
        System.out.println("Pick student id to see all courses: ");
        Scanner scan = new Scanner(System.in);
        String course = scan.nextLine();

        String sql = "SELECT course_name, CONCAT(first_name, ' ', last_name) AS student_name " +
                    "FROM db.courses c JOIN db.linking l " +
                    "ON c.course_id = l.default_course_id " +
                    "JOIN db.students s " +
                    "ON l.default_student_id = s.student_id " +
                    "WHERE s.student_id =  " + Integer.valueOf(course);

        //Executes query
        Statement stmt = connection.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        //prints out query
        System.out.println("STUDENT NAME_______________________COURSE NAME");
        while(rs.next()){
                String course_name = rs.getString("course_name");
                String student_name = rs.getString("student_name");
                System.out.println(student_name+"________________________"+course_name);
            }
    }

    public void query_students() throws SQLException {
        //Connects to database
        Connection connection = DriverManager.getConnection(DB_URL, user_name, password);

        //userinput
        System.out.println("Pick course id to see all students: ");
        Scanner scan = new Scanner(System.in);
        String course = scan.nextLine();

        String sql = "SELECT c.course_id, course_name, CONCAT(first_name, ' ', last_name) AS student_name " +
                    "FROM db.courses c JOIN db.linking l " +
                    "ON c.course_id = l.default_course_id " +
                    "JOIN db.students s " +
                    "ON l.default_student_id = s.student_id " +
                    "WHERE c.course_id =  " + Integer.valueOf(course);

        //Executes query
        Statement stmt = connection.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        //prints out query
        System.out.println("COURSE ID_______________________COURSE NAME_______________________STUDENT NAME");
        while(rs.next()){
                int course_id = rs.getInt("course_id");
                String course_name = rs.getString("course_name");
                String student_name = rs.getString("student_name");
                System.out.println(course_id+"______________________________"+course_name+"________________________"+student_name);
            }

    }

    public void query_time() throws SQLException{
        //Connects to database
        Connection connection = DriverManager.getConnection(DB_URL, user_name, password);

        //userinput
        System.out.println("Pick student id to see all courses and times: ");
        Scanner scan = new Scanner(System.in);
        String student = scan.nextLine();

        String sql = "SELECT course_name, course_times, course_days, CONCAT(first_name, ' ', last_name) AS student_name " +
                    "FROM db.courses c JOIN db.linking l " +
                    "ON c.course_id = l.default_course_id " +
                    "JOIN db.students s " +
                    "ON l.default_student_id = s.student_id " +
                    "WHERE s.student_id =  " + Integer.valueOf(student);

        //Executes query
        Statement stmt = connection.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        //prints out query
        System.out.println("STUDENT NAME__________________COURSE NAME__________________COURSE TIMES__________________COURSE DAYS");
        while(rs.next()){
                String course_day = rs.getString("course_days");
                String course_time = rs.getString("course_times");
                String course_name = rs.getString("course_name");
                String student_name = rs.getString("student_name");
                System.out.println(student_name+"__________________"+course_name+"__________________"+course_time+"__________________"+course_day);
            }
        
    }

    public static void main(String[] args) throws SQLException {

        //creates a database and tables
        Database data = new Database();
        data.createDatabase();

        while(true){
            System.out.println();
            System.out.println("1.) allow new students to enroll into the program");
            System.out.println("2.) new courses to be introduced");
            System.out.println("3.) students to enroll in courses");
            System.out.println("4.) querying to see which students are in each course");
            System.out.println("5.) querying to see which courses each student is in");
            System.out.println("6.) quering to see which courese and what times esch courses is for a given day of the week");
            System.out.println("7.) exit program");
            System.out.println("Please pick one of choices!");

            Scanner resp = new Scanner(System.in);
            int n = resp.nextInt();

            if(n == 1){
                data.add_student();
            }
            if(n == 2){
                data.add_course();
            }
            if(n == 3){
                data.add_linking();
            }
            if(n == 4){
                data.query_students();
            }
            if(n == 5){
                data.query_courses();
            }
            if(n == 6){
                data.query_time();
            }
            if(n == 7){
                System.exit(0);
            }
        }
    }

    
}