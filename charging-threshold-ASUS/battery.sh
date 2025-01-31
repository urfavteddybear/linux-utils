#!/bin/bash

THRESHOLD_FILE="/sys/class/power_supply/BAT1/charge_control_end_threshold"

# Periksa apakah skrip dijalankan dengan hak akses root
if [[ $EUID -ne 0 ]]; then
    echo "Script ini harus dijalankan sebagai root." >&2
    exit 1
fi

# Periksa argumen
if [[ $# -ne 1 ]]; then
    echo "Penggunaan: $0 --<nilai_threshold>" >&2
    exit 1
fi

# Ambil nilai threshold dari argumen
if [[ $1 =~ ^--([0-9]+)$ ]]; then
    THRESHOLD=${BASH_REMATCH[1]}
    
    # Validasi nilai threshold
    if [[ $THRESHOLD -ge 1 && $THRESHOLD -le 100 ]]; then
        echo $THRESHOLD > "$THRESHOLD_FILE"
        echo "Charging threshold diatur ke $THRESHOLD%."
    else
        echo "Nilai threshold harus antara 1 dan 100." >&2
        exit 1
    fi
else
    echo "Format argumen salah. Gunakan --<nilai_threshold> (contoh: --60)." >&2
    exit 1
fi

