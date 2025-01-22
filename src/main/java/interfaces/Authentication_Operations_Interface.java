package interfaces;

import model.UserPojo;

public interface Authentication_Operations_Interface {
    boolean userExists(String mailID);
    boolean registerUser(UserPojo user);
    boolean authenticateUser(String mailID, String password, String role);
    String getUserRole(String mailID);
    boolean isUserDeactivated(String mailID);
    boolean deactivateUser(String mailID);
    boolean reactivateUser(String mailID);
}