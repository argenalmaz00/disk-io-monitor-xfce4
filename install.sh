#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════
#  Установка Disk I/O Monitor (xfce4-genmon)
#  Безопасно: НЕ встраивается в панель, не может уронить XFCE
# ═══════════════════════════════════════════════════════════
set -e

BIN_MAIN="/usr/local/bin/disk-io-monitor"
BIN_CFG="/usr/local/bin/disk-io-monitor-settings"

echo "═══════════════════════════════════════════════════"
echo "  💾  Disk I/O Monitor — установка"
echo "═══════════════════════════════════════════════════"
echo ""

# ── 1. Зависимости ──────────────────────────────
echo "▶ [1/4] Проверка зависимостей..."

# Python3
python3 --version &>/dev/null && echo "  ✓ Python3" || { echo "  ✗ Python3 не найден!"; exit 1; }

# pycairo — для рендера PNG-баров
if python3 -c "import cairo" 2>/dev/null; then
    echo "  ✓ pycairo"
else
    echo "  ⚙  Устанавливаю pycairo..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get install -y python3-cairo
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm python-cairo
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y python3-cairo
    else
        pip3 install pycairo --break-system-packages
    fi
fi

# python3-gi — для диалога настроек
if python3 -c "import gi" 2>/dev/null; then
    echo "  ✓ python3-gi (PyGObject)"
else
    echo "  ⚙  Устанавливаю python3-gi..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get install -y python3-gi gir1.2-gtk-3.0
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm python-gobject
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y python3-gobject gtk3
    fi
fi

# xfce4-genmon-plugin
if dpkg -l xfce4-genmon-plugin &>/dev/null 2>&1 || \
   pacman -Qq xfce4-genmon-plugin &>/dev/null 2>&1 || \
   rpm -q xfce4-genmon-plugin &>/dev/null 2>&1; then
    echo "  ✓ xfce4-genmon-plugin"
else
    echo "  ⚙  Устанавливаю xfce4-genmon-plugin..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get install -y xfce4-genmon-plugin
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm xfce4-genmon-plugin
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y xfce4-genmon-plugin
    else
        echo "  ⚠  Установи вручную: xfce4-genmon-plugin"
    fi
fi

# ── 2. Копирование скриптов ──────────────────────
echo ""
echo "▶ [2/4] Установка скриптов..."

sudo install -m 755 disk-io-monitor          "$BIN_MAIN"
sudo install -m 755 disk-io-monitor-settings "$BIN_CFG"
echo "  ✓ $BIN_MAIN"
echo "  ✓ $BIN_CFG"

# ── 3. Тест ──────────────────────────────────────
echo ""
echo "▶ [3/4] Тест запуска..."
OUTPUT=$(python3 "$BIN_MAIN" 2>&1)
if echo "$OUTPUT" | grep -q "<img>\|<txt>"; then
    echo "  ✓ Скрипт работает"
    echo "  ℹ  Вывод:"
    echo "$OUTPUT" | head -3 | sed 's/^/     /'
else
    echo "  ✗ Ошибка:"
    echo "$OUTPUT"
    exit 1
fi

# ── 4. Инструкция ────────────────────────────────
echo ""
echo "▶ [4/4] Готово!"
echo ""
echo "═══════════════════════════════════════════════════"
echo "  ✅  Установка завершена"
echo ""
echo "  📋  Добавление на панель XFCE4:"
echo ""
echo "  1. ПКМ на панели → «Добавить новый элемент»"
echo "  2. Выбери «Generic Monitor» → «Добавить»"
echo "  3. ПКМ на элементе → «Свойства»"
echo "  4. Команда:  disk-io-monitor"
echo "     (путь указывать не нужно, скрипт в PATH)"
echo "  5. Период:   1 (секунда)"
echo "  6. Убери галочку «Label»"
echo "  7. Шрифт:    Monospace 9 (рекомендуется)"
echo ""
echo "  ⚙  Настройки: клик на ⚙ в панели"
echo "     или команда: disk-io-monitor-settings"
echo ""
echo "  📊  Формат отображения:"
echo "      sda || sdb || sdc ||"
echo "      (имя диска + 2 бара: чтение │ запись)"
echo ""
echo "  📈  В tooltip показывается:"
echo "      • % чтения и записи"
echo "      • Скорость (MB/s, KB/s и т.д.)"
echo "      • Total % нагрузки диска"
echo ""
echo "  💡  Мониторинг запустится сразу после добавления!"
echo "      Не требуется дополнительная настройка."
echo "═══════════════════════════════════════════════════"
