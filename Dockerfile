# Use Node.js LTS image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and install dependencies (now includes mysql2)
COPY package*.json ./
RUN npm install --only=production

# Copy app source code
COPY . .

# Expose port
EXPOSE 3000

# Start app
CMD ["node", "server.js"]
