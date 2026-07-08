products = ["Яблоки", "Хлеб", "Молоко", "Печенье", "Сок", "Кефир"]

for i in range(0, len(products), 2):
    if products[i] != 'Бананы':
        print(f'Индекс {i}: Проверен товар {products[i]} (Длина названия: {len(products[i])} символов)') 
    else:
        break 
else:
    print('--- Выборочная проверка успешно завершена ---')