# base image
FROM node:alpine

# create & set working directory
RUN mkdir -p /usr/src
WORKDIR /usr/src

# copy source files
COPY . /usr/src

# install dependencies
RUN npm install --legacy-peer-deps
RUN npm install -g serve

# start app
RUN npm run build
EXPOSE 3000
CMD serve -s build