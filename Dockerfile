FROM tensorflow/tensorflow:latest-gpu-jupyter
RUN echo "Custom container downloaded!"

RUN pip install whitebox
RUN pip install jupyterlab
RUN echo "Installed python packages!"