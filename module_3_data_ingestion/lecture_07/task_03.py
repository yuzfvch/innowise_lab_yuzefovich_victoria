suppliers_log = [ 
	"FreshFarm Inc", 
	"GreenFields Ltd", 
	"AgroWorld Co", 
	"FreshFarm Inc", 
	"GreenFields Ltd" 
]

unique_suppliers = set(suppliers_log)
unique_suppliers.add('GreenFields Ltd')

if "FreshFarm Inc" in unique_suppliers:
    print(True, unique_suppliers, len(unique_suppliers), sep='\n')

