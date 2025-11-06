# Use the official Node.js base image
FROM node:18-alpine

# Set working directory inside container
WORKDIR /app

# Copy package.json first (for dependency caching)
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the app files
COPY . .

# Expose the app port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
