FROM python:3.11-alpine

WORKDIR /app


COPY requirements.txt .
RUN pip install -r requirements.txt 

COPY app.py .
COPY .env .

EXPOSE 5005

CMD ["python", "app.py"]