import os
import psutil
import requests
from dotenv import load_dotenv

load_dotenv()

def get_system_stats():
    ram = psutil.virtual_memory().percent
    cpu = psutil.cpu_percent(interval=1)
    disk = psutil.disk_usage('/').percent
    return f"RAM: {ram}%, CPU: {cpu}%, Disk: {disk}%"

def consult_kimi(stats):
    """Primary Brain: Moonshot Kimi"""
    api_key = os.getenv('KIMI_API_KEY')
    url = "https://api.moonshot.cn/v1/chat/completions"
    headers = {"Authorization": f"Bearer {api_key}"}
    payload = {
        "model": "moonshot-v1-8k", # Using stable model for failover logic
        "messages": [{"role": "system", "content": "You are Chulo, CEO of Zaaka Digital."},
                     {"role": "user", "content": f"Analyze these VPS stats: {stats}"}]
    }
    response = requests.post(url, json=payload, headers=headers, timeout=10)
    response.raise_for_status() # Trigger error if auth or tier fails
    return response.json()['choices'][0]['message']['content']

def consult_gemini(stats):
    """Backup Brain: Google Gemini"""
    api_key = os.getenv('GEMINI_API_KEY')
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={api_key}"
    payload = {
        "contents": [{"parts": [{"text": f"You are Chulo, CEO of Zaaka Digital. Analyze: {stats}"}]}]
    }
    response = requests.post(url, json=payload, timeout=10)
    response.raise_for_status()
    return response.json()['candidates'][0]['content']['parts'][0]['text']

def send_telegram(message):
    token = os.getenv('TELEGRAM_TOKEN')
    chat_id = os.getenv('CHAT_ID')
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    requests.post(url, json={"chat_id": chat_id, "text": f"🦁 CHULO VISION PULSE:\n\n{message}"})

if __name__ == "__main__":
    print("Gathering telemetry...")
    stats = get_system_stats()
    
    analysis = None
    # FAILOVER LOGIC
    try:
        print("Attempting to consult Kimi (Primary)...")
        analysis = consult_kimi(stats)
    except Exception as e:
        print(f"Kimi failed: {e}. Switching to Gemini (Secondary)...")
        try:
            analysis = consult_gemini(stats)
        except Exception as e2:
            analysis = f"All brains offline. Raw Stats: {stats}"
    
    print("Pushing to Telegram...")
    send_telegram(analysis)
    print("Done.")
