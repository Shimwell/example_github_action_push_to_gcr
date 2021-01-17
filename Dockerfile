# build with the following command
# sudo docker build -t example_jupyer_on_gcr .

# run with the following command
# sudo docker run -p 8888:8888 example_jupyer_on_gcr 

FROM continuumio/miniconda3

# installing cadquery and jupyter
RUN conda install jupyter -y

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

COPY tasks tasks

WORKDIR tasks

#this sets the port, gcr is looking for this varible
ENV PORT 8888

CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token='paramak'", "--NotebookApp.password='paramak'"]