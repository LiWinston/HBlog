#!/bin/sh

# 启动 Spring Boot 应用
java -jar /app/blog-api.jar &

# 启动 nginx
nginx -g 'daemon off;' 