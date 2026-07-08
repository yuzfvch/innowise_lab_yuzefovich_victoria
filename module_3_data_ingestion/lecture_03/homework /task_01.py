raw_sku = "CARROT-001"
raw_regions = ("Minsk", "Warsaw", "Berlin", "Warsaw")
raw_weight_str = "2.5"
raw_stock_str = "150"

weight_kg = float(raw_weight_str)
stock_quantity = int(raw_stock_str)

print(weight_kg, type(weight_kg))
print(stock_quantity, type(stock_quantity))

sku_as_list = list(raw_sku)
regions_list = list(raw_regions)
unique_regions = set(raw_regions) 
regions_tuple = tuple(unique_regions)

print(sku_as_list, type(sku_as_list))
print(regions_list, type(regions_list))
print(unique_regions, type(unique_regions), regions_tuple, type(regions_tuple))

empty_list_1 = list() 
empty_list_2 = []
empty_dict_1 = dict() 
empty_dict_2 = {}
empty_tuple_1 = tuple() 
empty_tuple_2 = ()
empty_set = {}

print(bool(empty_list_1), bool(empty_dict_1), bool(empty_tuple_1), bool(empty_set))

not_empty_list = ['apple', 'pear']
not_empty_dict = {1: 'apple', 2: 'pear'}
not_empty_tuple = ('apple', 'tuple')
not_empty_set = {'apple', 'pear'}

print(bool(not_empty_list), bool(not_empty_dict), bool(not_empty_tuple), bool(not_empty_set))