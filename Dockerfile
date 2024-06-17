
FROM node:14

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json ./
RUN npm install
# RUN npm install sequelize sequelize-cli pg pg-hstore

# Bundle app source
COPY . .

# Expose the port
EXPOSE 3000

# Run the app
CMD ["node", "app/app.js"]
