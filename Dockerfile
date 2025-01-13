# 构建 blog-view
FROM node:18 AS blog-view-build
WORKDIR /app/blog-view
COPY blog-view/package*.json ./
RUN npm install
COPY blog-view .
RUN npm run build

# 构建 blog-cms
FROM node:18 AS blog-cms-build
WORKDIR /app/blog-cms
COPY blog-cms/package*.json ./
RUN npm install
COPY blog-cms .
RUN npm run build

# 构建 blog-api
FROM maven:3.9.9-amazoncorretto-21 AS spring-build
WORKDIR /app/blog-api
COPY blog-api/pom.xml .
RUN mvn dependency:go-offline
COPY blog-api/src ./src
RUN mvn clean package -DskipTests

# 最终运行阶段
FROM alpine/java:21-jre AS final
# 安装 nginx
RUN apk add --no-cache nginx

# 复制前端构建结果
COPY --from=blog-view-build /app/blog-view/dist /usr/share/nginx/html/blog
COPY --from=blog-cms-build /app/blog-cms/dist /usr/share/nginx/html/admin

# 复制后端jar
COPY --from=spring-build /app/blog-api/target/*.jar /app/blog-api.jar

# 复制nginx配置
COPY nginx.conf /etc/nginx/nginx.conf

# 复制启动脚本
COPY start-services.sh /start-services.sh
RUN chmod +x /start-services.sh

EXPOSE 80 12090
CMD ["/start-services.sh"] 