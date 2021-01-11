# build with the following command, replace the 50 cores with however many you would like to use
# sudo docker build -t example_jupyer_on_gcr .

# run with the following command
# sudo docker run -p 8888:8888 example_jupyer_on_gcr /bin/bash -c "jupyter notebook --notebook-dir=/tasks --ip='*' --port=8888 --no-browser --allow-root"


FROM continuumio/miniconda3

# installing cadquery and jupyter
RUN conda install jupyter -y

# ENTRYPOINT [ "jupyter notebook --notebook-dir=/tasks --ip='*' --port=8888 --no-browser" ]
# ENTRYPOINT ["jupyter", "notebook", "--notebook-dir=/", "--ip=*", "--port=8888", "--no-browser", "--allow-root"]


# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

RUN mkdir src
WORKDIR src/
COPY . .


CMD ["jupyter", "notebook", "--port=$PORT", "--no-browser", "--ip=0.0.0.0", "--allow-root"]