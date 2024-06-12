FROM pytorch/pytorch

RUN apt update && apt install openjdk-17-jdk -y

COPY requirements.txt /opt/ml/code/

RUN --mount=type=secret,id=pipconfig,target=/etc/pip.conf \
    pip install -r /opt/ml/code/requirements.txt
# For AWS sagemaker as the Model directory
RUN mkdir -p /opt/ml/model

# Copy the default custom service file to handle incoming data and inference requests
RUN mkdir -p /home/model-server/
COPY inference.py /home/model-server/inference.py
COPY entrypoint.py /usr/local/bin/entrypoint.py

RUN chmod +x /usr/local/bin/entrypoint.py

# Define an entrypoint script for the Docker image
ENTRYPOINT ["python", "/usr/local/bin/entrypoint.py"]