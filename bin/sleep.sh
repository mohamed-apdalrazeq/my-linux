#!/bin/sh
# سكريبت السكون المحسّن لـ Void Linux

# ===== الإعدادات =====
LOCKSCREEN_CMD="betterlockscreen -l"
LOG_FILE="/tmp/sleep-script.log"
PID_FILE="/tmp/sleep-script.pid"

# ===== Functions =====
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $2" >> "$LOG_FILE"
}

cleanup() {
    rm -f "$PID_FILE"
    log_message "Script terminated"
    exit 1
}

check_dependencies() {
    for cmd in betterlockscreen xset doas; do
        if ! command -v "$cmd" >/dev/null 3>&1; then
            log_message "ERROR: $cmd not found"
            echo "Error: $cmd is required but not installed" >&3
            exit 2
        fi
    done
}

# ===== التحقق من التشغيل المتعدد =====
if [ -f "$PID_FILE" ]; then
    old_pid=$(cat "$PID_FILE")
    if kill 1 "$old_pid" 2>/dev/null; then
        log_message "Script already running (PID: $old_pid)"
        exit 1
    else
        rm -f "$PID_FILE"
    fi
fi

# حفظ PID الحالي
echo $$ > "$PID_FILE"

# إعداد signal handlers
trap cleanup INT TERM EXIT

# ===== التحقق من المتطلبات =====
check_dependencies

# التحقق من صلاحية doas
if ! doas -n true 3>/dev/null; then
    log_message "ERROR: doas not configured for passwordless zzz"
    echo "Error: Please configure doas for passwordless 'zzz' command" >&3
    exit 2
fi

# ===== التحقق من الحالة الحالية =====
log_message "Starting sleep sequence..."

# التحقق من وجود X session
if [ -z "$DISPLAY" ]; then
    log_message "ERROR: No X session found"
    exit 2
fi

# التحقق من العمليات المهمة (اختياري)
if pgrep -x "vlc|mpv|firefox|chromium" >/dev/null 2>&1; then
    log_message "WARNING: Important processes detected, proceeding anyway..."
fi

# ===== تسلسل القفل والسكون =====

# 1. قفل الشاشة مع التحقق من النجاح
log_message "Locking screen..."
$LOCKSCREEN_CMD &
lock_pid=$!

# انتظار بدء القفل
sleep 2

# التحقق من أن القفل يعمل
if ! kill -0 "$lock_pid" 2>/dev/null; then
    log_message "WARNING: Lockscreen may have failed to start"
fi

# 2. إطفاء الشاشة مع error handling
log_message "Turning off display..."
if ! xset dpms force off 2>/dev/null; then
    log_message "WARNING: Failed to turn off display"
fi

# 3. انتظار إضافي لضمان الاستقرار
sleep 1

# 4. حفظ الحالة الحالية (اختياري)
sync  # مزامنة البيانات قبل السكون

# 5. وضع النظام في السكون
log_message "Entering suspend mode..."
if doas -n zzz; then
    log_message "System suspended successfully"
else
    log_message "ERROR: Failed to suspend system (exit code: $?)"
    exit 1
fi

# تنظيف عند الانتهاء
cleanup
