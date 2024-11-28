# Sử dụng Python Alpine làm base image
FROM python:3.10-alpine

# Cài đặt thư viện hệ thống cần thiết
RUN apk update && apk add --no-cache \
    build-base \
    libffi-dev \
    curl \
    libssl-dev \
    python3-dev \
    && apk clean

# Cập nhật pip và công cụ
RUN pip install --upgrade pip setuptools wheel

# Copy requirements.txt và cài đặt thư viện Python
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Tải trước dữ liệu NLTK (nếu cần)
RUN python -m nltk.downloader punkt wordnet omw-1.4

# Vô hiệu hóa GPU
ENV CUDA_VISIBLE_DEVICES="-1"
ENV TF_CPP_MIN_LOG_LEVEL=2

# Copy mã nguồn
WORKDIR /app
COPY . /app/

# Chạy ứng dụng với Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "py:app"]
