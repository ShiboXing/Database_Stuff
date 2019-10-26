

import java.sql.*;
import java.util.Properties;

public class JavaDemoInjection {
    private static boolean loggedIn;

    public static void main(String args[]) throws
            SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
        String url = "jdbc:postgresql://localhost/postgres";
        Properties props = new Properties();
        props.setProperty("user", "postgres");
        props.setProperty("password", "Bb!98102");
        Connection conn =
                DriverManager.getConnection(url, props);

        String username = "p'; select * from recitation9.users;";
        String password = "Bb!98102";//TODO CHANGE THIS
        String sql = "SELECT * FROM recitation9.users WHERE username= '" + username + "' and password='" + password + "'";
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery(sql);
        if (rs.next()) {
            loggedIn = true;
            System.out.println("Successfully logged in");
        } else {
            System.out.println("Username and/or password not recognized");
        }


    }
}