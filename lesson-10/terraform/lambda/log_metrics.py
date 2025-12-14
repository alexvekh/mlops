def handler(event, context):
    print("📈 Logging metrics to MLflow...")
    # Тут можна було б зробити запит до MLflow API
    return {"status": "logged"}