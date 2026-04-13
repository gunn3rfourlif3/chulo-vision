import os
import psutil
import requests
import json
from dotenv import load_dotenv

# Load credentials from .env
load_dotenv()

# Path inside the Docker container for persistence
MEMORY_FILE = "/app/data/memory.json"

def get_system_stats():
    """Captures core VPS telemetry."""
    ram = psutil.virtual_memory().percent
    cpu = psutil.cpu_percent(interval=1)
    return {"ram": ram, "cpu": cpu}

def handle_memory(current):
    """Reads previous stats to calculate trends and saves current stats."""
    trend = ""
    if os.path.exists(MEMORY_FILE):
        try:
            with open(MEMORY_FILE, 'r') as f:
                prev = json.load(f)
                ram_diff = current['ram'] - prev.get('ram', current['ram'])
                # Only report changes greater than 0.1% to avoid noise
                if abs(ram_diff) > 0.1:
                    trend = f" (RAM change: {ram_diff:+.1f}%)"
        except Exception as e:
            print(f"Memory read error: {e}")
    
    # Ensure the directory exists before saving
    os.makedirs(os.path.dirname(MEMORY_FILE), exist_ok=True)
    with open(MEMORY_FILE, 'w') as f:
        json.dump(current, f)
    return trend

def consult_kimi(message):
    """Primary Brain: Moonshot Kimi"""
    url = "https://api.moonshot.cn/v1/chat/completions"
    headers = {"Authorization": f"Bearer {os.getenv('KIMI_API_KEY')}"}
    payload = {
        "model": "moonshot-v1-8k",
        "messages": [
            {"role": "system", "content": "You are Chulo, CEO of Zaaka Digital."},
            {"role": "user", "content": message}
        ]
    }
    r = requests.post(url, json=payload, headers=headers, timeout=10)
    r.raise_for_status()
    return r.json()['choices'][0]['message']['content']

def consult_gemini(message):
    """Secondary Brain: Gemini 2.5 Flash (Modern Endpoint)"""
    api_key = os.getenv('GEMINI_API_KEY')
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={api_key}"
    payload = {"contents": [{"parts": [{"text": message}]}]}
    
    try:
        r = requests.post(url, json=payload, timeout=10)
        data = r.json()
        if 'candidates' in data and data['candidates']:
            return data['candidates'][0]['content']['parts'][0]['text']
        else:
            return f"Gemini Error: {data.get('error', {}).get('message', 'Unknown Refusal')}"
    except Exception as e:
        return f"Gemini Connection Error: {e}"

def send_telegram(text):
    """Pushes final analysis to Telegram."""
    token = os.getenv('TELEGRAM_TOKEN')
    chat_id = os.getenv('CHAT_ID')
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    payload = {"chat_id": chat_id, "text": f"🦁 CHULO PULSE:\n\n{text}"}
    try:
        requests.post(url, json=payload, timeout=10)
    except Exception as e:
        print(f"Telegram push failed: {e}")

if __name__ == "__main__":
    print("Gathering telemetry...")
    stats = get_system_stats()
    trend_info = handle_memory(stats)
    
    # Construct the analytical prompt
    prompt = f"Analyze these stats as Chulo: RAM {stats['ram']}%, CPU {stats['cpu']}%{trend_info}"
    
    analysis = ""
    
    # Failover Chain
    try:
        print("Consulting Kimi...")
        analysis = consult_kimi(prompt)
    except Exception as e:
        print(f"Kimi unavailable. Consulting Gemini...")
        analysis = consult_gemini(prompt)
    
    # Final Safety Fallback: If both AI providers fail or are busy (503)
    if not analysis or "Error" in analysis:
        print("AI providers busy. Sending raw telemetry...")
        analysis = f"⚠️ SYSTEM PULSE (RAW): RAM {stats['ram']}%, CPU {stats['cpu']}%{trend_info}. [AI Brains Offline]"
    
    print(f"Final Message: {analysis}")
    send_telegram(analysis)
    print("Done.")
