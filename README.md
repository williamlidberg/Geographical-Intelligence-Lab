# Geographical-Intelligence-Lab
Instructions on how to set up a jupterlab workspace at a remote server. Download the github repo to your local machine

        git clone https://github.com/williamlidberg/Geographical-Intelligence-Lab.git /home/training/test

Navigate to the directory and list files

        cd /home/training/test/

List files in the directory

        ls


# Dockerfile
The dockerfile is used to specify what should be installed in the docker container. Fill it out with relevant python packages that you need for your project. Store the dockerfile within your project on the NAS where you can find it from the server.

# Build a docker image
you need to ssh into the remote server and navigate to where the dockerfile is stored. To build a docker image. Note that the -t command is used to give the image a name. In this case it will be called notebook. The trailing dot is to indicate to docker that the docker file is in the current directory

        docker build -t notebook .

You can also build it from a path like this

        docker build -t notebook /home/training/test/

It takes a while to build the image the first time. You are downloading and building an small viritual computer after all.

# Start a docker continer
The docker image is the blueprint for the actual docker container. It can be started with the command "docker run notebook". We will use the -it command to make it interactive. 

        docker run -it notebook bash

We want to pass some arguments in order to connect to storage and forward a port. The port forwarding is used to enable us to reach the notebook that is running within the container from our laptops. Note that the port 8886 is used here but you can choose something like 8885, 8887 8888, 8889 instead if your selected number is already taken. --gpus all will anable us to use the GPU within the cotnainer and the -v command is used to map a directory on the NAS to a directory inside the cotnainer. Since we want to run this in the background we can start a screen session before starting the container.

        screen -S notebook

        docker run -it --rm -p 8886:8886 -v /home/training/data:/workspace/data notebook:latest bash

Note that without the bash command the container we have built will start a notebook.

# Start a notebook
Start jupyter labs inside the docker container (When you start a Jupyter notebook you are starting a small web server that your browser connects to) note that the port needs to be the same as above, in this case 8886:

First we need to set a password to reach the notebook

        jupyter notebook password

Then we can start the notebook with this command:

        jupyter lab \
        --ip=0.0.0.0 \
        --port=8886 \
        --allow-root \
        --no-browser \
        --NotebookApp.allow_origin='*'


The next step is to open your terminal on your laptop (cmd on windows) and ssh into the open port on the remote server. Note that your server username is required and you have to log in with your password. The ip address should be the address to the remote server. for example training.froglich.net

        ssh -L 8886:localhost:8886 training@training.froglich.net

Awnser yes to the first question when asked.         

        https://training.froglich.net/:8886

Log in using the password you set above. Congratualtions, you have now set up jupterlab on a remote server using docker! For more information on jupyterlab look here: https://jupyterlab.readthedocs.io/en/stable/ Note that jupyterlab keeps running in the background when you close the browser. Just go to the adress from above http://localhost:8886/ again to get back to jupyterlab. This works from any computer. You can now detach the docker container so it can run in the background on the server.

        ctrl+a d


# Docker compose


Mounting code and data seperatly can be a good idea to avoid having data in the github repo. For example: 

        docker run -it --rm -p 8887:8887 --gpus all -v /mnt/Extension_100TB/William/GitHub/Remnants-of-charcoal-kilns:/workspace/code -v /mnt/Extension_100TB/William/Projects/Cultural_remains/data:/workspace/data segmentation:latest bash
