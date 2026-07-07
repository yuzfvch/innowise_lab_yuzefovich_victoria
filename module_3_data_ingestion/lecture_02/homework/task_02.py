"""
Скрипт для расчёта длины ограждения квадратной зоны хранения.

Автор: Виктория Юзефович
Версия: 1.0
"""

import math


zone_id = input('Введите идентификатор зоны: ')
area_total = 225
side_length = math.sqrt(area_total)

print(f'Расчет для объекта: {zone_id}')
print(f'Длина стены зоны: {side_length} метров')