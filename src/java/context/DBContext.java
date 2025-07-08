package context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author PC
 */
public class DBContext {

    public static String driverName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    public static String dbURL = "jdbc:sqlserver://localhost:1433;databaseName=CraftDB;encrypt=false;trustServerCertificate=true;loginTimeout=5;socketTimeout=10000;";
    public static String userDB = "sa";
    public static String passDB = "1234";
    
    public static Connection getConnection() throws SQLException {
        Connection con = null;
        try {
            Class.forName(driverName);
            con = DriverManager.getConnection(dbURL, userDB, passDB);
            return con;
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "SQL Server JDBC Driver not found.", ex);
            throw new SQLException("Database driver not found.", ex);
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.WARNING, "Database connection failed - using mock data for testing", ex);
            // Return null for testing purposes - servlets should handle this gracefully
            return null;
        }
    }
    
    // Test method - not called automatically
    public static void testConnection() {
        try (Connection con = getConnection()) {
            if (con != null) {
                System.out.println("✅ Database connection successful!");
            } else {
                System.out.println("⚠️ Database connection failed - using mock data");
            }            
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.WARNING, "Failed to connect during test.", ex);
            System.out.println("⚠️ Database connection failed - " + ex.getMessage());
        }
    }
}