# Stage 1: Build the application
FROM node:18-alpine AS build

WORKDIR /app

# Copy dependency files
COPY package*.json ./

# Install dependencies
RUN npm install

ARG VITE_BACKEND_URL=http://localhost:3000/api
ENV VITE_BACKEND_URL=$VITE_BACKEND_URL

# Copy source code and build the project
COPY . .


RUN npm run build

# Stage 2: Serve the application using Nginx
FROM nginx:alpine

# Copy the static files from the build stage to Nginx html folder
# Note: Ensure your build output folder is actually named 'dist'
COPY --from=build /app/dist /usr/share/nginx/html

# Expose HTTP port
EXPOSE 80

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]