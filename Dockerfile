FROM tensorflow/tensorflow:latest-gpu-jupyter

RUN pip install whitebox
RUN pip install geopandas
RUN pip install rasterio

