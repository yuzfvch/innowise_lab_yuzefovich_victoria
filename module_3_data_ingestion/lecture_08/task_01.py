SMALL_BATCH_LIMIT = 500

def calculate_batch(weigth, price, discount=0.0):
    """
    Рассчитывает стоимость товара с учётом веса и скидки.

    weight: Вес товара.
    price: Цена за единицу веса.
    discount: Скидка в процентах (от 0 до 100). По умолчанию 0.0.

    """
    final_sum = weigth * price * (1 - discount)
    if final_sum > SMALL_BATCH_LIMIT:
        is_limit_exceeded = True 
    else:
        is_limit_exceeded = False
        
    return (final_sum, is_limit_exceeded)


carrot = calculate_batch(100, 4)
apple = calculate_batch(50, 20, 0.1)

print(f'Партия 1 (Морковь): Сумма {carrot[0]}. Превышение лимита: {carrot[1]}')
print(f'Партия 2 (Яблоки): Сумма {apple[0]}. Превышение лимита: {apple[1]}')

