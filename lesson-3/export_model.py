import torch
import torchvision.models as models

def main():
    model = models.mobilenet_v2(weights="MobileNet_V2_Weights.DEFAULT")
    model.eval()

    example = torch.randn(1, 3, 224, 224)
    traced = torch.jit.trace(model, example)

    traced.save("model.pt")
    print("✅ Model saved to model.pt")

if __name__ == "__main__":
    main()
