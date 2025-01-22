package interfaces;
import java.util.List;
import model.UserPojo;

public interface User_Operations_Interface {
    boolean addUser(UserPojo user);
    List<UserPojo> fetchAllUsers();
    boolean updateUserDetails(UserPojo user);
    boolean deleteUserByMail(String mailID);
    UserPojo fetchUserByMail(String mailID);
}