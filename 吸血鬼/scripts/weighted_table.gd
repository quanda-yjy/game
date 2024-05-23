class_name WeightTable

var items: Array[Dictionary]
var weight_sum = 0

func add_item(item, weight: int):
	items.append({"item":item, "weight":weight})
	weight_sum += weight

func remove_item(item_to_remove): 
	printt("移除升级能力：", item_to_remove.name)
	items = items.filter(func (item): return item["item"] != item_to_remove)
	weight_sum = 0
	for item in items:
		if item["item"].has_meta("name"):
			printt("当前能力:", item["item"].name)
		weight_sum += item["weight"]


func pick_item(exclude: Array = []):
	
	var adjusted_item: Array[Dictionary] = items
	var adjusted_weight_sum = weight_sum
	if exclude.size() > 0:
		adjusted_item = []
		adjusted_weight_sum = 0
		for item in items:
			if item["item"] in exclude:
				continue
			adjusted_item.append(item)
			adjusted_weight_sum += item["weight"]
				
	var chosen_weight = randi_range(1, adjusted_weight_sum)
	var iteration_sum = 0
	for item in adjusted_item:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum:
			return item["item"]
