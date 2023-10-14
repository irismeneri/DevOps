FROM node:alpine
# Set the working directory
WORKDIR /app
COPY package-lock.json ./
COPY package.json ./
COPY . .
EXPOSE 5000
RUN npm install
# Run the application
CMD ["npm", "run", "start"]
ENV DATABASE_HOST ${DATABASE_HOST}
ENV DATABASE_PORT ${DATABASE_PORT}
ENV DATABASE_USER ${DATABASE_USER}
ENV DATABASE_PASSWORD ${DATABASE_PASSWORD}
ENV DATABASE_NAME ${DATABASE_NAME}






