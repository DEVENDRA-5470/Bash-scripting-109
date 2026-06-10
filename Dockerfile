# stage-1 building phase
FROM python:3.11-slim AS builder

WORKDIR /install

RUN apt-get update && \
    apt-get install -y \
    gcc \
    libffi-dev \
    pkg-config \
    default-libmysqlclient-dev\
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --prefix=install --no-cache-dir -r requirements.txt

# stage-2 final phase

FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y libmariadb3 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /install /usr/local

COPY . .

EXPOSE 8000

CMD ["gunicorn", "--bind" , "0.0.0.0:8000" ,"bookvault.wsgi"]