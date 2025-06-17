#!/bin/bash

# Liệt kê các port đang mở forwarding
PORTS=(13306 13307)

echo "🛑 Đang dừng các forwarding socat..."

for PORT in "${PORTS[@]}"; do
  PID=$(pgrep -f "socat TCP-LISTEN:$PORT")
  if [[ -n "$PID" ]]; then
    echo "↳ Dừng forward tại cổng $PORT (PID=$PID)"
    kill -9 "$PID"
  else
    echo "↳ Không thấy tiến trình forward trên cổng $PORT"
  fi
done

echo "✅ Tất cả đã được dừng (nếu có)."
