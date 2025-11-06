# GIAI ĐOẠN 1: Xây dựng (Build) tệp .WAR bằng Ant
# Sử dụng image Eclipse Temurin (Java 11) làm image cơ sở
FROM eclipse-temurin:11-jdk AS build

# Cài đặt Ant (công cụ build) vào trong container
RUN apt-get update && apt-get install -y ant

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Sao chép toàn bộ mã nguồn của bạn (từ GitHub) vào thư mục /app
COPY . .

# Chạy lệnh Ant để build dự án
# (NetBeans mặc định tạo tệp .WAR trong thư mục 'dist')
RUN ant dist

# GIAI ĐOẠN 2: Chạy (Run) ứng dụng
# Sử dụng image Tomcat 9 chính thức (cũng dùng Java 11)
FROM tomcat:9.0-jdk11-openjdk

# Chỉ cho Render biết rằng container này lắng nghe trên cổng 8080
EXPOSE 8080

# Xóa các ứng dụng mặc định của Tomcat để dọn dẹp
RUN rm -rf /usr/local/tomcat/webapps/*

# Sao chép tệp .WAR đã được build ở Giai đoạn 1 vào Tomcat
# Đổi "ch02.war" thành tên tệp .war của bạn nếu nó khác
# Sao chép thành "ROOT.war" để chạy ở URL gốc
COPY --from=build /app/dist/ch02.war /usr/local/tomcat/webapps/ROOT.war