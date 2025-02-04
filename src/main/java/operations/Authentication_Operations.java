package operations;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;
import model.UserPojo;
import db.GetConnection;
import interfaces.Authentication_Operations_Interface;

public class Authentication_Operations<Struct, JSONObject> implements Authentication_Operations_Interface {

    private static final Authentication_Operations instance = new Authentication_Operations();

    public static Authentication_Operations getInstance() {
        return instance;
    }

    // Check if user exists
    public boolean userExists(String mailID) {
        String callFunction = "{? = CALL get_user_role(?)}";
        try (Connection conn = GetConnection.getConnection(); CallableStatement stmt = conn.prepareCall(callFunction)) {

            stmt.registerOutParameter(1, Types.VARCHAR);
            stmt.setString(2, mailID);

            stmt.execute();
            String role = stmt.getString(1);
            return !role.equals("UNKNOWN");
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Register new user
    public boolean registerUser(UserPojo user) {
        // Don't allow registration with admin email
        if (user.getMailID().equals("admin@example.com")) {
            return false;
        }

        String callProcedure = "{CALL register_user(?, ?, ?, ?)}";
        try (Connection conn = GetConnection.getConnection();
                CallableStatement stmt = conn.prepareCall(callProcedure)) {

            stmt.setString(1, user.getMailID());
            stmt.setString(2, user.getName());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, "CUSTOMER"); // Default role for new users

            stmt.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Authenticate user
    public boolean authenticateUser(String mailID, String password, String role) {
        String callFunction = "{? = CALL authenticate_user(?, ?)}";
        try (Connection conn = GetConnection.getConnection(); CallableStatement stmt = conn.prepareCall(callFunction)) {

            stmt.registerOutParameter(1, Types.TINYINT); // Expect a TINYINT return type
            stmt.setString(2, mailID);
            stmt.setString(3, password);

            stmt.execute();
            boolean isAuthenticated = stmt.getInt(1) == 1;

            // If authenticated, verify the role matches
            if (isAuthenticated) {
                String userRole = getUserRole(mailID); // Assume this retrieves the user's role
                return userRole != null && userRole.equalsIgnoreCase(role);
            }
            return false; // Authentication failed
        } catch (Exception e) {
            e.printStackTrace();
            return false; // Handle exception gracefully
        }
    }

    // Get user role
    public String getUserRole(String mailID) {
        String callFunction = "{? = CALL get_user_role(?)}";
        try (Connection conn = GetConnection.getConnection(); CallableStatement stmt = conn.prepareCall(callFunction)) {

            // Register output parameter
            stmt.registerOutParameter(1, Types.VARCHAR);
            stmt.setString(2, mailID); // Set input parameter

            stmt.execute();
            return stmt.getString(1); // Return the role
        } catch (Exception e) {
            e.printStackTrace();
            return "UNKNOWN"; // Handle exceptions gracefully
        }
    }

    // Check if user is deactivated
    public boolean isUserDeactivated(String mailID) {
        String role = getUserRole(mailID);
        return role.endsWith("_DEACTIVATED");
    }

    public boolean deactivateUser(String mailID) {
        String callProcedure = "{CALL deactivate_user(?)}";
        try (Connection conn = GetConnection.getConnection();
                CallableStatement stmt = conn.prepareCall(callProcedure)) {

            stmt.setString(1, mailID);
            stmt.execute();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to reactivate user
    public boolean reactivateUser(String mailID) {
        String callProcedure = "{CALL reactivate_user(?)}";
        try (Connection conn = GetConnection.getConnection();
                CallableStatement stmt = conn.prepareCall(callProcedure)) {

            stmt.setString(1, mailID);
            stmt.execute();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}