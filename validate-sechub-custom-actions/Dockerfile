FROM python:3.6-alpine

RUN apk add --no-cache openssl \
    && pip install flask==1.0 \
    && echo 'print("Vulnerable App")' > app.py

CMD ["python", "app.py"]
