# Моніторинг якості моделей (MLflow)

Проєкт встановлює локально MLflow і відстежує результати моделі
---



## 📦 Project Structure

        mlflow-experiments/
        ├── .env
        ├── train.py
        └── requirements.txt



## 🚀 Requirements

- Створи та активуй віртуальне середовище:

        python3 -m venv venv
        source venv/bin/activate

- встанови необхідні для роботи бібліотеки

        pip install -r requirements.txt


## ⚙️ How to Use

- створи файл секретів:

        MLFLOW_TRACKING_URI=http://localhost:5000
        AWS_ACCESS_KEY_ID=login
        AWS_SECRET_ACCESS_KEY='pasword'
        MLFLOW_S3_ENDPOINT_URL=http://localhost:port
        MLFLOW_BACKEND_STORE_URI=postgresql://mlflow:mlflowpass@mlflow-postgres-postgresql.application.svc.cluster.local:5432/mlflow


- запусти локально mlflow 

        mlflow server \
        --backend-store-uri sqlite:///mlflow.db \
        --default-artifact-root ./mlruns \
        --host 0.0.0.0 \
        --port 5000

- зайди на нього в браузері:

        http://localhost:5000/

- завускай файл для навчання - результати будуть зберышатися  

        python3 train.py

![alt text](image-1.png)
