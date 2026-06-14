# 1. Базовый образ с установленным Python
FROM python:3.10-slim

# 2. Указываем рабочую директорию внутри контейнера
WORKDIR /app

# 3. Копируем файл с зависимостями в контейнер
COPY requirements.txt .

# 4. Устанавливаем библиотеки из requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# 5. Копируем наше Python-приложение (app.py) в контейнер
COPY app.py .

# 6. Команда, которая запустит приложение при старте контейнера
CMD ["python", "app.py"]