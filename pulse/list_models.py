import os
import requests
from dotenv import load_dotenv

load_dotenv()
api_key = os.getenv('GEMINI_API_KEY')
url = f"https://generativelanguage.googleapis.com/v1beta/models?key={api_key}"

r = requests.get(url)
models = r.json()

if 'models' in models:
    print("AVAILABLE MODELS:")
    for m in models['models']:
        if 'generateContent' in m['supportedGenerationMethods']:
            print(f"- {m['name']}")
else:
    print("Error fetching models:", models)
