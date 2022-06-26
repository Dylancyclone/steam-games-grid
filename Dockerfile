FROM node:14 as steam-games-grid
# ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
# ENV PATH=$PATH:/home/node/.npm-global/bin

WORKDIR /home/node/app

# Install the UI dependencies
COPY package.json ./
COPY yarn.lock ./
RUN yarn global add @quasar/cli@1.3.2
ENV PATH="$(yarn global bin):$PATH"
RUN yarn install --frozen-lockfile

# Copy in the project files
COPY . .

# Configure the launch commands
EXPOSE 8080
CMD ["quasar", "dev"]
# USER node

