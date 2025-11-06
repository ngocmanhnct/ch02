# GIAI ĐOẠN 1: Xây dựng (Build) tệp .WAR bằng Ant
# ... (Phần này giữ nguyên) ...
FROM eclipse-temurin:11-jdk AS build
# ... (Phần này giữ nguyên) ...
RUN ant dist

# GIAI ĐOẠN 2: Chạy (Run) ứng dụng
# Sử dụng image Tomcat 9 chính thức
FROM tomcat:9.0-jdk11-openjdk

# ✨ THÊM DÒNG NÀY ✨
# Chỉ cho Render biết rằng container này lắng nghe trên cổng 8080
EXPOSE 8080

# Xóa các ứng dụng mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# Sao chép tệp .WAR đã build từ Giai đoạn 1 ...
# ... (Phần còn lại của tệp giữ nguyên) ...
COPY --from=build /app/dist/ch02email.war /usr/local/tomcat/webapps/ROOT.war