FROM tensorflow/tensorflow:latest-gpu
RUN echo "Custom container downloaded!"

RUN pip install jupyterlab
RUN pip install whitebox
RUN pip install geopandas
RUN pip install rasterio
