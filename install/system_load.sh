#!/bin/bash

# Глобальные переменные для хранения PID процессов
declare -a CPU_PIDS=()
declare -a DISK_PIDS=()

# Процент загрузки CPU (от 1 до 100)
CPU_LOAD_PERCENT=50

# Функция очистки при завершении
cleanup() {
    echo "Завершение работы..."
    # Завершаем все дочерние процессы
    for pid in "${CPU_PIDS[@]}" "${DISK_PIDS[@]}"; do
        kill -TERM $pid 2>/dev/null
    done
    # Удаляем временные файлы
    rm -f /tmp/testfile*
    exit 0
}

# Установка обработчиков сигналов
trap cleanup SIGINT SIGTERM

# Функция для нагрузки на CPU
cpu_load() {
    while true; do
        : # Пустая команда для создания нагрузки
    done
}

# Функция для нагрузки на диск
disk_load() {
    local file_num=$1
    while true; do
        dd if=/dev/zero of="/tmp/testfile_${file_num}" bs=1M count=100 oflag=direct &>/dev/null
        sync
        rm -f "/tmp/testfile_${file_num}"
    done
}

# Запуск CPU нагрузки
cpu_cores=$(nproc)
cpu_processes=$(( (cpu_cores * CPU_LOAD_PERCENT) / 100 ))
echo "Запуск $cpu_processes процессов CPU нагрузки (${CPU_LOAD_PERCENT}% от $cpu_cores ядер)"

for i in $(seq 1 $cpu_processes); do
    cpu_load &
    CPU_PIDS+=($!)
done

# Запуск дисковой нагрузки (2 процесса)
echo "Запуск процессов дисковой нагрузки"
for i in {1..2}; do
    disk_load $i &
    DISK_PIDS+=($!)
done

echo "Нагрузка запущена. Для остановки нажмите Ctrl+C"
echo "CPU PIDs: ${CPU_PIDS[*]}"
echo "Disk PIDs: ${DISK_PIDS[*]}"

# Ожидание сигнала завершения
wait
