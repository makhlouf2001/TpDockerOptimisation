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

