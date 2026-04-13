FROM python:3.11-slim
WORKDIR /app
COPY pulse.py .env ./
RUN pip install psutil requests python-dotenv
CMD ["python", "pulse.py"]
