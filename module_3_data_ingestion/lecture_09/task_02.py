from typing import Union, Optional

def calculate_total_delivery_cost(product_name: str,
                                  weights: Union[list, tuple],
                                  prices: Union[list, tuple],
                                  discount: Optional[float] = None,
                                  currency_rate: Union[int, float] = 1,
                                  *extra_costs: float) -> dict[str, float]:
    """
        product_name (str): Название товара (используется для отчёта).
        weights (list или tuple): Коллекция весов партий (в кг).
        prices (list или tuple): Коллекция цен за 1 кг (в той же валюте).
        discount (Optional[float], по умолчанию None): Скидка в долях от 0 до 1
            (например, 0.1 = 10%). Если None или не передана, скидка не применяется.
        currency_rate (Union[int, float], по умолчанию 1): Коэффициент пересчёта валюты.
        *extra_costs: Произвольное количество дополнительных расходов
    """
    if len(weights) == len(prices):
        total_sum: int = 0
        for i in range(len(weights)):
            total_sum += weights[i] * prices[i]
        if discount:
            total_sum = total_sum * (1 - discount)
        if extra_costs:
            total_sum += sum(extra_costs)
        final_sum: float = total_sum * currency_rate
        
        return {product_name: final_sum}

first = calculate_total_delivery_cost('Овощная партия', [100, 50], [4, 6], 0.1, 1, 20, 15)
second = calculate_total_delivery_cost('Фруктовая партия', (30, 20, 10), (15, 12, 18), None, 1.2, 25)

for key, value in first.items():
    print(f'Товар: {key}, итоговая стоимость: {value}')

for key, value in second.items():
    print(f'Товар: {key}, итоговая стоимость: {value}')

