import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class TestDB {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=IELTSFlow;encrypt=true;trustServerCertificate=true";
        String user = "sa";
        String pass = "123456";
        try {
            Connection conn = DriverManager.getConnection(url, user, pass);
            System.out.println("SUCCESS: Connected to DB");
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
