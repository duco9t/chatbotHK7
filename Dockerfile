# Sử dụng Python làm base image
FROM python:3.10-slim

# Cài đặt thư viện hệ thống cần thiết
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    curl \
    libssl-dev \
    python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Cập nhật pip và công cụ
RUN pip install --upgrade pip setuptools wheel

# Cài đặt thư viện Python
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Tải trước dữ liệu NLTK
RUN python -m nltk.downloader punkt wordnet omw-1.4

# Vô hiệu hóa GPU
ENV CUDA_VISIBLE_DEVICES="-1"
ENV TF_CPP_MIN_LOG_LEVEL=2

# Copy mã nguồn
WORKDIR /app
COPY . /app/

# Chạy ứng dụng với Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "py:app"]
