#!/bin/bash

# 设置输出颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 停止并删除旧容器
echo -e "${YELLOW}Stopping and removing old containers...${NC}"
docker-compose down

# 删除旧镜像
IMAGE_NAME="nblog-local"
echo -e "${YELLOW}Removing old images...${NC}"
docker rmi $IMAGE_NAME -f

# 构建新镜像
echo -e "${GREEN}Building new image...${NC}"
docker-compose build

# 启动服务
echo -e "${GREEN}Starting services...${NC}"
docker-compose up -d

# 检查服务状态
echo -e "${CYAN}Checking service status...${NC}"
docker-compose ps

echo -e "\n${GREEN}Deployment completed!${NC}"
echo -e "${CYAN}Blog Frontend: http://localhost${NC}"
echo -e "${CYAN}Admin Frontend: http://localhost/admin${NC}"
echo -e "${CYAN}API Endpoint: http://localhost/api${NC}" 