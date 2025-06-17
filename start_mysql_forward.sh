#!/bin/bash

# Danh sách forward: mỗi dòng là "ALIAS LOCAL_PORT TARGET_HOST TARGET_PORT"
FORWARDS_LIST=$(cat <<EOF
prod1     13306    10.10.0.5   3306
prod2     13307    10.10.0.6   3306
EOF
)

echo "🚀 Bắt đầu bật forwarding cho các MySQL host..."

while read -r ALIAS LOCAL_PORT TARGET_HOST TARGET_PORT; do
  # Bỏ qua dòng trống hoặc comment
  [[ -z "$ALIAS" || "$ALIAS" == \#* ]] && continue

  echo "👉 $ALIAS: localhost:$LOCAL_PORT ⇨ $TARGET_HOST:$TARGET_PORT"

  # Dừng tiến trình cũ nếu đang chạy
  PID=$(pgrep -f "socat TCP-LISTEN:$LOCAL_PORT")
  if [[ -n "$PID" ]]; then
    echo "   ↳ Đã có tiến trình cũ (PID=$PID), dừng..."
    kill -9 "$PID"
  fi

  # Chạy socat dưới nền
  nohup socat TCP-LISTEN:$LOCAL_PORT,fork,reuseaddr TCP:$TARGET_HOST:$TARGET_PORT > /dev/null 2>&1 &

done <<< "$FORWARDS_LIST"

echo "✅ Hoàn tất. Có thể kết nối qua IP server-dev và các port tương ứng."
