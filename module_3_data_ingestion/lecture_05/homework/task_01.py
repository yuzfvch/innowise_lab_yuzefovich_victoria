raw_log = "ORDER-2025-01-15|FRT-APPLE-PL|+111 (23) 456-78-90| мИНсК "

order_id, product_code, raw_phone, raw_city = raw_log.split('|')

category = product_code[:3]
region = product_code[-2:]
position_first = product_code.find('-')


print(f'Позиция первого дефиса в коде товара: {position_first}')

if product_code.startswith('FRT'):
    print("Код товара начинается с 'FRT'")
else:
    print("Код товара не начинается с 'FRT'")

clean_phone = ''

for ch in raw_phone:
    if ch.isdigit():
        clean_phone += ch
        
print(f'Длина номера телефона: {len(clean_phone)}')

city = raw_city.strip().lower().title()

report = f'Заказ: {order_id}\nКатегория: {category} | Регион: {region}\nТелефон: {clean_phone}\nГород: {city}'

print(report)