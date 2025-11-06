package murach.data;

import java.sql.*;
import murach.business.User;

public class UserDB {

    private static final String URL = "jdbc:mysql://localhost:3306/userdb";
    private static final String USER = "root";
    private static final String PASSWORD = "290125"; // đổi lại cho đúng

    public static void insert(User user) {
        String sql = "INSERT INTO Users (firstName, lastName, email) VALUES (?, ?, ?)";

        try (
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getEmail());
            ps.executeUpdate();

            System.out.println("✅ Đã lưu user: " + user.getFirstName() + " " + user.getLastName());
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi lưu user: " + e.getMessage());
        }
    }
}
