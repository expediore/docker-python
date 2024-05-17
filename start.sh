#!/bin/sh

# 기본 포트를 5000으로 설정
PORT=${PORT:-5000}

# Gunicorn 실행
exec gunicorn --bind 0.0.0.0:$PORT app:app

