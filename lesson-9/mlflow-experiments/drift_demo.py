import os
from dotenvimport load_dotenv
load_dotenv()  # підвантажує .env

import numpy as np
import mlflow
from tensorflow.keras.datasets import mnist
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, Flatten, Dense
from alibi_detect.cd import ClassifierDrift

# ==============================
# Конфіг MLflow
# ==============================
mlflow.set_tracking_uri(os.environ["MLFLOW_TRACKING_URI"])
experiment_name = "Alibi Drift Detection"

# Створюємо експеримент, якщо його немає
experiment = mlflow.get_experiment_by_name(experiment_name)
if experiment is None:
    experiment_id = mlflow.create_experiment(experiment_name)
    print(f"✅ Створено експеримент '{experiment_name}' (ID={experiment_id})")
else:
    experiment_id = experiment.experiment_id
    print(f"ℹ️ Використовується існуючий експеримент '{experiment_name}' (ID={experiment_id})")

# ==============================
# Дані MNIST
# ==============================
(x_train, _), (x_test, _) = mnist.load_data()
x_train = x_train.astype(np.float32) / 255
x_test = x_test.astype(np.float32) / 255

# Формат (n, 28, 28, 1)
x_train = x_train.reshape((-1, 28, 28, 1))
x_test = x_test.reshape((-1, 28, 28, 1))

# Створюємо аномальні дані (додаємо шум)
x_adv = x_test + np.random.normal(0, 0.3, x_test.shape)
x_adv = np.clip(x_adv, 0, 1)

# ==============================
# Модель-класифікатор для Alibi
# ==============================
model = Sequential([
    Conv2D(8, 4, strides=2, padding='same', activation='relu', input_shape=(28, 28, 1)),
    Conv2D(16, 4, strides=2, padding='same', activation='relu'),
    Flatten(),
    Dense(2, activation='softmax')
])

# Ініціалізація детектора
cd = ClassifierDrift(x_train, model=model, backend='tensorflow', p_val=0.05)

# ==============================
# Drift detection + логування
# ==============================
with mlflow.start_run(experiment_id=experiment_id):
    preds = cd.predict(x_adv)

    # Логування метрик
    is_drift = int(preds['data']['is_drift'])
    p_val = preds['data']['p_val'].mean()

    mlflow.log_metric("is_drift", is_drift)
    mlflow.log_metric("p_val", p_val)

    print("📊 Drift result:", "Виявлено" if is_drift else "Не виявлено")
    print("p-value:", p_val)

    print("✅ Експеримент завершено. Перевірте результати в MLflow UI.")
