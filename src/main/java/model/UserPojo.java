package model;

public class UserPojo {

private int userID;
private String mailID;
private String name;
private String password;
private String role;

public int getUserID() {
    return userID;
}

public void setUserID(int userID) {
    this.userID = userID;
}

public String getMailID() {
    return mailID;
}

public void setMailID(String mailID) {
    this.mailID = mailID;
}

public String getName() {
    return name;
}

public void setName(String name) {
    this.name = name;
}

public String getPassword() {
    return password;
}

public void setPassword(String password) {
    this.password = password;
}

public String getRole() {
    return role;
}

public void setRole(String role) {
    this.role = role;
}

}