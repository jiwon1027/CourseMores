FROM node:16.16.0 as build-stage
WORKDIR /var/jenkins_home/workspace/Frontend_react/FrontEnd/react/course_mores
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

EXPOSE 3000
CMD ["npm", "start"]
