# TpDockerOptimisation
# Etape 1 : Baseline
Cette étape permet correspond à l'image non optimisée de l'application  pour avoir une vue globale sur l'image de depart à fin de comparaiser aprés. 
# Construction de l'image
C:\Users\marie\Documents\tpdockeroptimisation>docker build -t myapp:baseline .
[+] Building 28.8s (12/12) FINISHED                    docker:desktop-linux
 => [internal] load build definition from dockerfile                   0.1s
 => => transferring dockerfile: 360B                                   0.0s
 => [internal] load metadata for docker.io/library/node:latest         2.5s
 => [internal] load .dockerignore                                      0.0s
 => => transferring context: 2B                                        0.0s
 => [1/7] FROM docker.io/library/node:latest@sha256:82a1d74c5988b72e8  0.0s
 => => resolve docker.io/library/node:latest@sha256:82a1d74c5988b72e8  0.0s
 => [internal] load build context                                      0.3s
 => => transferring context: 87.28kB                                   0.3s
 => CACHED [2/7] WORKDIR /app                                          0.0s
 => [3/7] COPY package*.json ./                                        0.1s
 => [4/7] COPY . /app                                                  1.2s
 => [5/7] RUN npm install                                              5.0s
 => [6/7] RUN apt-get update && apt-get install -y build-essential c  15.0s
 => [7/7] RUN npm run build                                            0.5s
 => exporting to image                                                 3.9s
 => => exporting layers                                                2.4s
 => => exporting manifest sha256:fc59b402f0a53d3d05ba1d96e2b03388a55e  0.0s
 => => exporting config sha256:1d6c865bab42ff37ce2c9aec263c49630f7880  0.0s
 => => exporting attestation manifest sha256:361b8fd3a7d9854861629fb2  0.0s
 => => exporting manifest list sha256:f2c9971a01807cb55cffa580d1ff2e4  0.0s
 => => naming to docker.io/library/myapp:baseline                      0.0s
 => => unpacking to docker.io/library/myapp:baseline                   1.3s

# Vérification de la taille de l'image
C:\Users\marie\Documents\tpdockeroptimisation>docker images myapp:baseline
REPOSITORY   TAG        IMAGE ID       CREATED         SIZE
myapp        baseline   f2c9971a0180   3 minutes ago   1.73GB

#Lancement du conteneur 
C:\Users\marie\Documents\tpdockeroptimisation>docker run -p 3000:3000 myapp:baseline
Serveur démarré sur le port 3000

# Etape 2: Optimisation avec node: 18-alpine et cache dépendances
Dans cette étape j'ai remplacé "node:latest" par "node:18-alpine", qui va aléger l'image de base.
J'ai aussi séparé la copie des fichiers de dépendances "package*.json) de la copie du code dans le but de profiter du cache Docker. 

# Reconstruction de l'image apres optimisation 
C:\Users\marie\Documents\tpdockeroptimisation>docker build -t myapp:step2 .
[+] Building 9.0s (10/10) FINISHED                                                                 docker:desktop-linux
 => [internal] load build definition from dockerfile                                                               0.0s
 => => transferring dockerfile: 186B                                                                               0.0s
 => [internal] load metadata for docker.io/library/node:18-alpine                                                  0.7s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load build context                                                                                  0.2s
 => => transferring context: 202.83kB                                                                              0.2s
 => [1/5] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8c  0.1s
 => => resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8c  0.1s
 => CACHED [2/5] WORKDIR /app                                                                                      0.0s
 => CACHED [3/5] COPY package*.json ./                                                                             0.0s
 => [4/5] RUN npm install --only=production                                                                        5.0s
 => [5/5] COPY . .                                                                                                 0.9s
 => exporting to image                                                                                             1.9s
 => => exporting layers                                                                                            0.9s
 => => exporting manifest sha256:15c2db9e04b91e968681037554d7f6da4ae0d741d32662710f47f1d213f09b8b                  0.0s
 => => exporting config sha256:2fcb47b3e31fca0315f5aab874f60b05db30618579b8e29a937227c50a559226                    0.0s
 => => exporting attestation manifest sha256:47824821659dc816d18c662f412cdc715334aacd8815610086f358256abec9ee      0.0s
 => => exporting manifest list sha256:e95093b8412a99efdde86f57eed9ff06a8f77abbfd1f6cc90cb2d358440de78a             0.0s
 => => naming to docker.io/library/myapp:step2                                                                     0.0s
 => => unpacking to docker.io/library/myapp:step2

 # Vérification et comaraison de la taille de l'image
 C:\Users\marie\Documents\tpdockeroptimisation>docker images myapp
REPOSITORY   TAG        IMAGE ID       CREATED              SIZE
myapp        step2      e95093b8412a   About a minute ago   233MB
myapp        baseline   f2c9971a0180   3 hours ago          1.73GB

=> Les points améliorés: * Image beaucoup plus légère ( de 1,73BG --> 233MB)
                         * Installation que des dépendances de production
                         * Meilleure gestion du cache Docker

# Etape 3: Ajout d'un .dockerignore
Dans cette étape, j'ai ajouté un fichier ".dockerignore" à fin de réduire le contexte enovoyé à Docker à l'instant de build.
c'est ce qui va éviter l'envoie de "node_modules" qui n'a pas beaucoup de sens vue qu'on a les dépendances déja réinstallées dans l'image, ca va aussi exclure les fichiers Git, logs et les autres fichiers temporaires et par la suite ca va rendre les builds plus rapides.

# Reconstruction de l'image
C:\Users\marie\Documents\tpdockeroptimisation>docker build -t myapp:step3 .
[+] Building 2.1s (10/10) FINISHED                                                                 docker:desktop-linux
 => [internal] load build definition from dockerfile                                                               0.0s
 => => transferring dockerfile: 186B                                                                               0.0s
 => [internal] load metadata for docker.io/library/node:18-alpine                                                  1.5s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 129B                                                                                  0.0s
 => [1/5] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8c  0.0s
 => => resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8c  0.0s
 => [internal] load build context                                                                                  0.1s
 => => transferring context: 287B                                                                                  0.1s
 => CACHED [2/5] WORKDIR /app                                                                                      0.0s
 => CACHED [3/5] COPY package*.json ./                                                                             0.0s
 => CACHED [4/5] RUN npm install --only=production                                                                 0.0s
 => [5/5] COPY . .                                                                                                 0.0s
 => exporting to image                                                                                             0.2s
 => => exporting layers                                                                                            0.1s
 => => exporting manifest sha256:12daf6ec167e540b88b417c5f075835a06b1fca1ae64c8e8cda5e2f3a1a8f5ff                  0.0s
 => => exporting config sha256:2b5f5552a94ffa6f6e81510f65f1d836f5559fd33e637eef73dd42c71c9301fd                    0.0s
 => => exporting attestation manifest sha256:772404d8261a4b445d5183b6b9644bef2459a62c555f94ed8ce287a36175c508      0.0s
 => => exporting manifest list sha256:99775ecb9263bc18bbcb024c5777706f793195da69a1c6e2c425f329866bfd3c             0.0s
 => => naming to docker.io/library/myapp:step3                                                                     0.0s
 => => unpacking to docker.io/library/myapp:step3

 # Vérifications et comparaison des images
 C:\Users\marie\Documents\tpdockeroptimisation>docker images myapp
REPOSITORY   TAG        IMAGE ID       CREATED             SIZE
myapp        step3      99775ecb9263   46 seconds ago      204MB
myapp        step2      e95093b8412a   About an hour ago   233MB
myapp        baseline   f2c9971a0180   4 hours ago         1.73GB

=> Les points améliorés: * Image un peu plus légère ( de 233MB --> 204MB)

# Etape 4: Multi - stage build
Dans cette étape, j'ai séparé le build en 2 étapes:
1. Builder: installation de toutes les dépendances.
2. Runner : uniquemenet copie du code source et installation des dépendance de production.
=> Cela permet d'obtenir une image finale plus légere et plus sécurisée car elle ne contient pas les outils de développement.

# Reconstruction de l'image aprés modification du code dockerfile
C:\Users\marie\Documents\tpdockeroptimisation>docker build -t myapp:step4 .
[+] Building 6.6s (12/12) FINISHED                                                                 docker:desktop-linux
 => [internal] load build definition from dockerfile                                                               0.1s
 => => transferring dockerfile: 359B                                                                               0.0s
 => [internal] load metadata for docker.io/library/node:18-alpine                                                  1.5s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 129B                                                                                  0.0s
 => [builder 1/5] FROM docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35c  0.0s
 => => resolve docker.io/library/node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8c  0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 10.37kB                                                                               0.0s
 => CACHED [builder 2/5] WORKDIR /app                                                                              0.0s
 => CACHED [builder 3/5] COPY package*.json ./                                                                     0.0s
 => CACHED [runner 4/5] RUN npm install --only=production                                                          0.0s
 => [builder 4/5] RUN npm install                                                                                  4.6s
 => [builder 5/5] COPY . .                                                                                         0.1s
 => [runner 5/5] COPY --from=builder /app/server.js ./                                                             0.0s
 => exporting to image                                                                                             0.2s
 => => exporting layers                                                                                            0.1s
 => => exporting manifest sha256:f433be3d37775ef402df4c78dd929038db292c87d05c861f3f6976799828757e                  0.0s
 => => exporting config sha256:c78c3e2fe0a54d74f960061dcbf629f216acdc2b465396acf130e7cfa12a1403                    0.0s
 => => exporting attestation manifest sha256:fd33a016bd10f33daa9fffbda0d084dd3230c3a4d896059db872d6c254de5cde      0.0s
 => => exporting manifest list sha256:8dec92515449694dfbd068b18d318c550010ecef3019d814d7977cf52beeedec             0.0s
 => => naming to docker.io/library/myapp:step4                                                                     0.0s
 => => unpacking to docker.io/library/myapp:step4 

# Vérification et comparaison des images 
C:\Users\marie\Documents\tpdockeroptimisation>docker images myapp
REPOSITORY   TAG        IMAGE ID       CREATED             SIZE
myapp        step4      8dec92515449   9 seconds ago       204MB
myapp        step3      99775ecb9263   14 minutes ago      204MB
myapp        step2      e95093b8412a   About an hour ago   233MB
myapp        baseline   f2c9971a0180   4 hours ago         1.73GB

=> Les points améliorés: * Séparation claire entre le build et le run
                         * Plus sécurisée (Les outils build ne sont pas exposés).
                         
