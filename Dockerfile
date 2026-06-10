FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y \
    gcc \
    libffi-dev \
    pkg-config \
    default-libmysqlclient-dev\
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["gunicorn", "--bind" , "0.0.0.0:8000" ,"bookvault.wsgi"]


# Commands
docker images
docker build -f Dockerfile.multistage -t my-book-app:multistage . 
docker build -t my-book-app:no-stage .
docker run -it --rm my-book-app:no-stage sh
docker rmi image-name
