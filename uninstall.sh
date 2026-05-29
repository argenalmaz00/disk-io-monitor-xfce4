#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════
#  Удаление Disk I/O Monitor
# ═══════════════════════════════════════════════════════════

BIN_MAIN="/usr/local/bin/disk-io-monitor"
BIN_CFG="/usr/local/bin/disk-io-monitor-settings"
STATE="/tmp/disk_io_monitor_state.json"
IMG="/tmp/disk_io_monitor_bars.png"

echo "═══════════════════════════════════════════════════"
echo "  💾  Disk I/O Monitor — удаление"
echo "═══════════════════════════════════════════════════"
echo ""

_remove() {
    if [ -f "$1" ]; then
        ${2:-rm -f} "$1" && echo "  ✓ Удалён: $1"
    else
        echo "  ℹ  Не найден: $1"
    fi
}

_remove "$BIN_MAIN"  "sudo rm -f"
_remove "$BIN_CFG"   "sudo rm -f"
_remove "$STATE"
_remove "$IMG"

echo ""
echo "═══════════════════════════════════════════════════"
echo "  ✅  Скрипты удалены."
echo ""
echo "  ⚠️   Удали Generic Monitor с панели вручную:"
echo "       ПКМ на элементе → «Удалить»"
echo ""
echo "  📋  Для повторной установки:"
echo "       ./install.sh"
echo ""
echo "  💡  После переустановки мониторинг запустится"
echo "      сразу после добавления элемента на панель."
echo "═══════════════════════════════════════════════════"
