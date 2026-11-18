from pathlib import Path

import mlflow.pyfunc
import numpy as np
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

# chargement du modele telecharge pendant le docker build
model_path = next(Path("model").rglob("MLmodel")).parent
model = mlflow.pyfunc.load_model(str(model_path))

app = FastAPI()


class Image(BaseModel):
    pixels: list[float]


@app.post("/predict")
def predict(img: Image):
    if len(img.pixels) != 64:
        raise HTTPException(status_code=400, detail="l'image doit contenir 64 pixels")
    pred = model.predict(np.array([img.pixels]))
    return {"prediction": int(pred[0])}
