FROM python:3.12-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt \
    && groupadd -g 10001 app \
    && useradd -u 10001 -g app -s /usr/sbin/nologin app

COPY app ./app

RUN chown -R 10001:10001 /app

USER 10001

EXPOSE 8080

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
