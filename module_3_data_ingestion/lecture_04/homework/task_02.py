# Список списков
daily_logs = [
    [500, 0, 1200],       # Касса 1 (Нормальная)
    [300, -999, 800],     # Касса 2 (Сломалась посередине, 800 не должно посчитаться)
    [1500, 200]           # Касса 3 (Нормальная)
]

total_revenue = 0 

for ind, j in enumerate(daily_logs, start=1):
    print(f'--- Обработка Кассы №{ind} ---')
    for i in j:
        if i != 0 and i != -999:
            total_revenue += i
            print(f'Добавлено: {i}')
        elif i == 0:
            print('Сбой (0).')
            continue
        else:
            print('Аварийная остановка кассы!')
            break
else:
    print('=== ИТОГ ДНЯ ===')
    print(f'Общая выручка магазина: {total_revenue}')