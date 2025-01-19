package operations;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import db.GetConnection;
import model.UserPojo;

public class User_Operations {

    // Method to add a new user to the database
    public static boolean addUser(UserPojo user) {
        String query = "INSERT INTO users (mailID, name, password, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            stmt.setString(1, user.getMailID());
            stmt.setString(2, user.getName());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getRole());

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0; // Return true if the user was added successfully
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to retrieve a list of all users
    public static List<UserPojo> fetchAllUsers() {
        List<UserPojo> userList = new ArrayList<>();
        String query = "SELECT userID, mailID, name, role FROM users"; // Excluding passwords for security
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                UserPojo user = new UserPojo();
                user.setUserID(rs.getInt("userID"));
                user.setMailID(rs.getString("mailID"));
                user.setName(rs.getString("name"));
                user.setRole(rs.getString("role"));
                userList.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userList;
    }

    // Method to update user information
    public static boolean updateUserDetails(UserPojo user) {
        String query = "UPDATE users SET name = ?, password = ?, role = ? WHERE mailID = ?";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getRole());
            stmt.setString(4, user.getMailID());

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0; // Return true if any rows were updated
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to delete a user based on mailID
    public static boolean deleteUserByMail(String mailID) {
        String query = "DELETE FROM users WHERE mailID = ?";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, mailID);
            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0; // Return true if the user was deleted successfully
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to fetch a single user by mailID
    public static UserPojo fetchUserByMail(String mailID) {
        String query = "SELECT userID, mailID, name, role FROM users WHERE mailID = ?";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, mailID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                UserPojo user = new UserPojo();
                user.setUserID(rs.getInt("userID"));
                user.setMailID(rs.getString("mailID"));
                user.setName(rs.getString("name"));
                user.setRole(rs.getString("role"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Return null if no user was found
    }
}
