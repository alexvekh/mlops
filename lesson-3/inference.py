# inference.py
import torch
import torchvision.transforms as T
from PIL import Image
import json
import sys

# Завантаження класів ImageNet
with open("imagenet_classes.json") as f:
    idx_to_class = json.load(f)

# Завантаження моделі
model = torch.jit.load("model.pt")
model.eval()

# Трансформації для входу
transform = T.Compose([
    T.Resize(256),
    T.CenterCrop(224),
    T.ToTensor(),
    T.Normalize(
        mean=[0.485, 0.456, 0.406],
        std=[0.229, 0.224, 0.225]
    )
])

def predict(image_path):
    img = Image.open(image_path).convert("RGB")
    x = transform(img).unsqueeze(0)

    with torch.no_grad():
        outputs = model(x)
        probs = torch.nn.functional.softmax(outputs, dim=1)[0]

    top3 = torch.topk(probs, 3)
    for i, (idx, prob) in enumerate(zip(top3.indices, top3.values)):
        print(f"{i+1}. {idx_to_class[str(idx.item())]} — {prob.item():.4f}")

if __name__ == "__main__":
    predict(sys.argv[1])
