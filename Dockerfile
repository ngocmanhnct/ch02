# GIAI ĐOẠN 1: Xây dựng (Build) tệp .WAR bằng Ant
# Sử dụng image Tomcat làm nền tảng build
FROM tomcat:9.0-jdk11-openjdk AS build

# Cài đặt Ant (công cụ build) vào trong container Tomcat
RUN apt-get update && apt-get install -y ant

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Sao chép toàn bộ mã nguồn của bạn (từ GitHub) vào thư mục /app
COPY . .

# Chạy lệnh Ant để build dự án
#
# ✨ THAY ĐỔI: Thêm cờ '-Djavac.source' và '-Djavac.target'
# (Ép Ant biên dịch cho Java 1.8 (Java 8) thay vì Java 24)
#
RUN ant dist \
    -Dj2ee.server.home=/usr/local/tomcat \
    -Dlibs.CopyLibs.classpath=/app/nb-ant-libs/org-netbeans-modules-java-j2seproject-copylibstask.jar \
    -Dlibs.javaee-api-7.0.classpath="" \
    -Djavac.source=1.8 \
    -Djavac.target=1.8

# GIAI ĐOẠN 2: Chạy (Run) ứng dụng
# (Phần này giữ nguyên, nó sử dụng một image Tomcat mới và sạch)
FROM tomcat:9.0-jdk11-openjdk

# Chỉ cho Render biết rằng container này lắng nghe trên cổng 8080
EXPOSE 8080

# Xóa các ứng dụng mặc định của Tomcat để dọn dẹp
RUN rm -rf /usr/local/tomcat/webapps/*

# Sao chép tệp .WAR đã được build ở Giai đoạn 1 vào Tomcat
# (Đảm bảo 'ch02.war' là tên tệp .war chính xác trong thư mục /dist của bạn)
COPY --from=build /app/dist/ch02.war /usr/local/tomcat/webapps/ROOT.war