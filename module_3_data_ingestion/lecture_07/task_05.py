import json 

api_response_json = """ 
{ 
	"store": "StoreHub", 
	"orders": [ 
		{"id": 1, "total": 50}, 
		{"id": 2, "total": 200}, 
		{"id": 3, "total": 150} 
		]
 } 
""" 

response_dict = json.loads(api_response_json)
orders = response_dict['orders']

high_value_orders = [x for x in orders if x['total'] > 100]

response_dict['high_value_orders'] = high_value_orders

api_response_json = json.dumps(response_dict)

print(api_response_json)