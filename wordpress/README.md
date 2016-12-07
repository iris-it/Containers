# A propos

Ceci est le repository pour les applications Wordpress hebergées sur la plateforme DC/OS (Marathon) d'Iris IT

Chaque modification est automatiquement envoyé sur les applications en production ( à enlever surement )

assez important pour fix certains soucis lors de la build et du reste 

```
# WIN fix

RUN apt-get update && apt-get install -y dos2unix

# OTHER fix

RUN apt-get update && apt-get install -y unzip rsync && rm -r /var/lib/apt/lists/*

########################## Code 

# WIN fix

RUN dos2unix /entrypoint.sh

RUN apt-get --purge remove -y dos2unix && rm -rf /var/lib/apt/lists/*
```