FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the script and .env
COPY . .

# Create the data directory for persistence
RUN mkdir -p /app/data

# Run the script
CMD ["python", "pulse.py"]
