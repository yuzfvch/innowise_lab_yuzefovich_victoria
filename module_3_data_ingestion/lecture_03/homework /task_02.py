product_name = "Морковь мытая"
price = 2.5
stock_quantity = 150
is_local_farm = True
supplier = None

has_coupon = True
has_card = False
total = 10

is_hit = bool(price < 3 and is_local_farm)
print(f'Является ли товар хитом? {is_hit}')

has_supplier = bool(supplier is not None)
can_show_in_app = bool(supplier is not None and stock_quantity) 
needs_restock = bool(stock_quantity <= 20 or is_hit) 
is_blocked = bool(not(is_local_farm)) 

print(f'Поставщик указан? {has_supplier}')
print(f'Показывать в приложении? {can_show_in_app}')
print(f'Нужно пополнение? {needs_restock}')
print(f'Товар заблокирован для акции? {is_blocked}')


discount_without_brackets = bool(has_coupon or has_card and total > 50)
discount_with_brackets = bool((has_coupon or has_card) and total > 50)

print(f'Скидка без скобок: {discount_without_brackets}')
print(f'Скидка со скобками: {discount_with_brackets}')

price += 1.0
stock_quantity *= 2
boxes = stock_quantity
boxes //= 10

print(f'Цена после изменения: {price}')
print(f'Остаток после изменения: {stock_quantity}')
print(f'Полных коробок по 10 кг: {boxes}')

is_hit = bool(price < 3 and is_local_farm)
print(f'Является ли товар хитом (после изменений)? {is_hit}')
needs_restock = bool(stock_quantity <= 20 or is_hit) 
print(f'Нужно пополнение (после изменений)? {needs_restock}')