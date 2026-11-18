import mlflow

# on recupere la derniere version du modele depuis dagshub
mlflow.artifacts.download_artifacts("models:/digits-rf/latest", dst_path="model")
print("modele telecharge")
