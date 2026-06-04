package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database connection utility for IELTSFlow.
 * Connects to SQL Server using JDBC.
 */
public class DBContext {

    private static final String SERVER   = "localhost";
    private static final String PORT     = "1433";
    private static final String DATABASE = "IELTSFlow";
    private static final String USER     = "sa";
    private static final String PASSWORD = "123456";

    private static final String URL =
            "jdbc:sqlserver://" + SERVER + ":" + PORT
            + ";databaseName=" + DATABASE
            + ";encrypt=true;trustServerCertificate=true";

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("SQL Server JDBC Driver not found: " + e.getMessage());
        }
    }

    /**
     * Opens and returns a new database connection.
     * Caller is responsible for closing the connection.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
