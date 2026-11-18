FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ENV MLFLOW_TRACKING_URI=https://dagshub.com/zorobabel33/dvc.mlflow
ENV MLFLOW_TRACKING_USERNAME=zorobabel33

# change a chaque build pour forcer le telechargement du dernier modele
ARG CACHE_BUST=1

# le token dagshub est passe en secret pour ne pas rester dans l'image
COPY app/download_model.py .
RUN --mount=type=secret,id=dagshub_token \
    echo "build $CACHE_BUST" && \
    MLFLOW_TRACKING_PASSWORD=$(cat /run/secrets/dagshub_token) python download_model.py

COPY app/main.py .

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
