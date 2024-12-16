### STAGE 1: Build ###
# 1. Utiliser node:12.7-alpine comme base pour la construction
FROM node:12.7-alpine AS build

# 2. Définir le répertoire de travail
WORKDIR /usr/src/app

# 3. Copier les fichiers package.json et package-lock.json
COPY package.json package-lock.json ./

# 4. Installer les dépendances
RUN npm install

# 5. Copier le contenu du projet dans l'image
COPY . .

# 6. Construire le projet Angular
RUN npm run build

### STAGE 2: Run ###
# 1. Utiliser nginx:1.17.1-alpine comme base pour le serveur
FROM nginx:1.17.1-alpine

# 2. Copier le fichier de configuration nginx.conf dans le répertoire Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# 3. Copier le build Angular depuis le stage "build"
COPY --from=build /usr/src/app/dist/aston-villa-app /usr/share/nginx/html

# 4. Exposer le port 80 pour les connexions HTTP
EXPOSE 80

# 5. Démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
