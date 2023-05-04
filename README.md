# Geographical-Intelligence-Lab
Instructions on how to set up a jupterlab workspace at a remote server

# Dockerfile
The dockerfile is used to specify what should be installed in the docker container. Fill it out with relevant python packages that you need for your project. Store the dockerfile within your project on the NAS where you can find it from the server.

# Build a docker image
you need to ssh into the remote server and navigate to where the dockerfile is stored. For example:
        cd /mnt/Extension_100TB/William/GitHub/Geographical-Intelligence-Lab/

if you type ls you should see a file named Dockerfile in this directory. To build a docker image. Note that the -t command is used to give the image a name. In this case it will be called notebook.

        docker build -t notebook .

It takes a while to build the image the first time.

# Start a docker continer
The docker image is the blueprint for the actual docker container. It can be started with the command "docker run notebook" but we want to pass some arguments in order to connect to external storage and forward a port. The port forwarding is used to enable us to reach the notebook that is running within the container from our laptops. Note that the port 8886 is used here but you can choose something like 8885, 8887 8888, 8889 instead if your selected number is already taken. --gpus all will anable us to use the GPU within the cotnainer and the -v command is used to map a directory on the NAS to a directory inside the cotnainer. Since we want to run this in the background we can start a screen session before starting the container.

        screen -S notebook

        docker run -it --rm -p 8886:8886 --gpus all -v /mnt/Extension_100TB/William/GitHub/Geographical-Intelligence-Lab/:/workspace/lab notebook:latest bash

By default the notebook will start in a directory inside the container. Lets change that to a volume mapped from the NAS by changing directory.

        cd /workspace/lab/

# Start a notebook
Start jupyter labs inside the docker container (When you start a Jupyter notebook you are starting a small web server that your browser connects to) note that the port needs to be the same as above, in this case 8886:

        jupyter lab --ip=0.0.0.0 --port=8886 --allow-root --no-browser --NotebookApp.allow_origin='*'

This command should generate a bunch of text. Look for two URLs near the bottom that looks something like this: http://127.0.0.1:8886/lab?token=fd7e2dc517233f485cb0f42110403b18e4c929ff0d9a9da5 you will need this in a bit.

The next step is to open your terminal on your laptop (cmd on windows) and ssh into the open port on the remote server. Note that your server username is required and you have to log in with your password. The ip address should be the address to the remote server. for example lidar1-1.ad.slu.se

        ssh -L 8886:localhost:8886 wmli0001@lidar1-1.ad.slu.se

Awnser yes to the first question when asked. The next promt is for your password to that server. Once logged in you can now access jupyterlab from your browser using the IP address and the portnumber. Paste this in your browser and a window will apear asking for you to set a password. This is where you need the URL from before. 

        http://lidar1-1.ad.slu.se:8886

Paste the URL in the token window and chose a password for this notebook and press "login and set new password". Congratualtions, you have now set up jupterlab on a remote server using docker! For more information on jupyterlab look here: https://jupyterlab.readthedocs.io/en/stable/ Note that jupyterlab keeps running in the background when you close the browser. Just go to the adress from above http://lidar1-1.ad.slu.se:8886 again to get back to jupyterlab. This works from any computer as long as they are connected to the SLU network. You can now detach the docker container so it can run in the background on the server.

        ctrl+a d


# Notes
You can install additional packages but keep in mind that they are not saved when the container shuts down. The server is stable but is ocasinally rebooted for maintance. Add the python packages to the docker file if you want to keep them long term. 

Mounting code and data seperatly can be a good idea to avoid having data in the github repo. For example: 

        docker run -it --rm -p 8887:8887 --gpus all -v /mnt/Extension_100TB/William/GitHub/Remnants-of-charcoal-kilns:/workspace/code -v /mnt/Extension_100TB/William/Projects/Cultural_remains/data:/workspace/data segmentation:latest bash
