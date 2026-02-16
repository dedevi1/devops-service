FROM python:3.11-slim

WORKDIR /app
COPY app.py .

EXPOSE 8080

HEALTHCHECK --interval=5s --timeout=2s --retries=3 \
 CMD curl -f http://localhost:8080/health || exit 1

CMD ["python", "app.py"]
