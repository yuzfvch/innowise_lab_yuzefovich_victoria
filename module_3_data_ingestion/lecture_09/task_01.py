def calculate_purchase(product_name: str, weight: int, price: float):
    """
        product_name (str): Название товара 
        weight (int): Вес партии в килограммах. Должен быть неотрицательным.
        price (float): Цена за один килограмм. Должна быть неотрицательной.
    """
    try:
        numeric_weight = float(weight)
        total_cost = numeric_weight * price
        technical_index = 100 / numeric_weight
        print(f'Товар: {product_name}. Итоговая стоимость: {total_cost}$')
    except TypeError as e:
        print(f'Тип ошибки: {type(e)}\nСообщение: {e}')
    except ValueError as e:
        print(f'Тип ошибки: {type(e)}\nСообщение: {e}')
    except ZeroDivisionError as e:
        print(f'Тип ошибки: {type(e)}\nСообщение: {e}')
    finally:
        print('--- Проверка партии завершена ---')

calculate_purchase('Томаты', 100, 2.5)
calculate_purchase('Огурцы', 'пятьдесят', 1.8)
calculate_purchase('Перец', 0, 4)
calculate_purchase('Зелень', [10], 5)

