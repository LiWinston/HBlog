#!/bin/bash
# 简化版部署脚本 - 适用于 macOS (Intel) 环境

# 获取脚本所在目录的绝对路径
project_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function echo_msg()
{
  case $1 in
    0)
      echo -e "\033[30;42m $2 \033[0m"
      ;;
    1)
      echo -e "\033[30;41m $2 \033[0m"
      ;;
    *)
      echo "$2"
      ;;
  esac
}

function menu()
{
  echo -e "\033[35m(1)blog-api\033[0m"
  echo -e "\033[35m(2)blog-cms\033[0m"
  echo -e "\033[35m(3)blog-view\033[0m"
  
  read -p "选择要部署的模块: " module
  case $module in
    1)
      echo_msg 0 "部署 blog-api"
      deploy_springboot
      ;;
    2)
      echo_msg 0 "部署 blog-cms" 
      deploy_vue "blog-cms"
      ;;
    3)
      echo_msg 0 "部署 blog-view"
      deploy_vue "blog-view"
      ;;
    *)
      echo_msg 1 "输入错误"
      exit 1
  esac
  echo_msg 0 "部署完成"
}

function deploy_springboot()
{
  cd "${project_path}/blog-api"
  echo_msg 0 "构建 blog-api"
  mvn clean package -Dmaven.test.skip=true
  echo_msg 0 "启动 Spring Boot 应用"
  java -jar target/blog-api-0.0.1.jar
}

function deploy_vue()
{
  local module_name=$1
  cd "${project_path}/${module_name}"
  echo_msg 0 "安装依赖"
  npm install
  echo_msg 0 "构建 ${module_name}"
  npm run serve
}

menu