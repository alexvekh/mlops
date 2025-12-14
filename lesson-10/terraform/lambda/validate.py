def handler(event, context):
    print("✅ Validating input data...")
    # У реальному житті — schema validation або перевірка CSV
    return {"status": "valid"}