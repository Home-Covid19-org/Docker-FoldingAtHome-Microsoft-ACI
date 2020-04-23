![](https:/home-covid19.org/android-chrome-192x192.png)

# WeAd@Home-Covid19.org

We are WeAd, a collaborative project made for the ad industry to help fight COVID-19.
We’ve joined the global initiative Folding@home by offering the best of us – our brains and our computers.

##  About Folding@home 

[Folding@home](https://foldingathome.org/) is a biomedical research project that uses the distributed computing power of volunteers arround the world. It consist on a client program that retrieves a computing workload from a server, processes it and return the results back. There are client versions for Windows, macOS or GNU/Linux.

The biomedical research is focused in the complex calculations of proteins folding that would allow scientist to develop a drug or antibody targeting. This would have impact in the treatment of a wide range of diseases.


# Packaged solution for deploying Folding@home in Microsoft ACI

As organization you can colaborate using part of your cloud for taking advantages of his features, such as hyper-scale, pay as you go model, instant provisioning of compute resources... With this packaged solution you are on the fasttrack for donating a bit or a lot of your compute spending on Azure and helping the with the research involving all the colleagues on your company.

This repository includes:

* A **Dockerfile** that builds a Docker image with the Folding@home (FAH from now) client ready to run as a container.
* **Azure Resource Manager templates** that is able to deploy a CPU-enabled **Azure Container Instance** (ACI). 
* One **docker-entrypoint** that setup customized enviroment.
* One **monitoring script** that allows to runs once the instance in case you would like to create one run for user.

The package of this repository is inteded to be run from GNU/Linux compatible system, WSL included.

## Quickstart - Prerequisites and ACI Deployment

Follow these steps to have your FAH client running on ACI:

  1. Install git and clone this repository
  ```
    git clone https://github.com/cmilanf/docker-foldingathome.git
  ```
  2. Install [Docker CLI](https://docs.docker.com/engine/reference/commandline/cli/) on your GNU/Linux distribution.
  3. Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) on your GNU/Linux distribution.
  4. Edit file **.env** and add your own custom values. 
  ```
    FAHWEBCONTROL_PORT=7396
    FAHCONTROL_PORT=36331
    FAHCLIENT_POWER=full
    FAHCLIENT_PASSKEY=<PASSKEY>
    FAHCLIENT_TEAM=253920
    FAHCLIENT_USER=<USER>
  ```
  Please, have in mind `monitrc` by default will kill FaH **process once is completed**. 
  The package is designed to be run at least one by each of yours teammates from an custom built-in app at Microsoft Teams.
   
  ```
   check file messages with path /var/lib/fahclient/log.txt
     stop program = "/bin/bash -c 'killall -9 /usr/bin/FAHClient'"
     if match "Cleaning up" then stop
   ```
  
  5. Navigate to the folder and run following commands to compile your local docker image:
   ```
      docker-compose build
      docker-compose up -d
   ```
  6. Tag the created image to refer in a easy way
  ```
    docker tag <your_image>/homecovid19:7.5.1 homecovid19.azurecr.io/home-covid19
  ```
  5. Login into Azure by typing `az login`, if you have already a Container Registry on Azure.
  ```
    az acr login --name <Container_Registry>
   ```
  6. Now you can send the image to your Azure repository 
  ```
    docker push homecovid19.azurecr.io/home-covid19
  ```
  7. Your image will be available in the Container Registry in Azure.
  
  ![](https://www.home-covid19.org/github/ms-aci-repo.png)
  
  8. The easiest way to deploy the instance is using the AZ CLI o Azure Powershell, just tun this command:
   ```python
   az container create --resource-group <RESOURCE_GROUP>
    --name <INSTANCE_NAME> 
    --image homecovid19.azurecr.io/home-covid19:latest 
    --ip-address Public 
    --ports 80 7396 
    --environment-variables 
    FAHWEBCONTROL_PORT=7396 
    FAHCONTROL_PORT=36331 
    FAHCLIENT_POWER=full 
    FAHCLIENT_PASSKEY=<PASSKEY> 
    FAHCLIENT_TEAM=253920 
    FAHCLIENT_USER=<USER>
   ```
![](https://www.home-covid19.org/github/aci-powershell.png)
   

## Integration with your Microsoft Teams Organization


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
