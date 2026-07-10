branches = [
    {"city": "Minsk", "revenue": 15000},
    {"city": "Warsaw", "revenue": 32000},
    {"city": "London", "revenue": 12000}
]

def audit_logger(func):
    def wrapper(*args, **kwargs):
        print('[AUDIT] Запуск анализа...')
        result = func(*args, **kwargs)
        print('[AUDIT] Анализ завершен.')
        print('Топ филиалов:')
        return result 
    return wrapper 

@audit_logger
def get_sorted_report(list_of_dicts):
    sorted_list = sorted(list_of_dicts, key=lambda x: x['city'], reverse=True)
    return sorted_list

sorted_branches = get_sorted_report(branches)
for index, j in enumerate(sorted_branches, 1):
    print(f'{index}. {j['city']}: {j['revenue']}')
    

