extends Node

#@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightTable = WeightTable.new()

var uprade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var uprade_axe = preload("res://resources/upgrades/axe.tres")
var uprade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var uprade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")

func _ready():
	printt("preload axe", uprade_axe.name)
	printt("preload sword rate", uprade_sword_rate.name)
	printt("preload sword damge", uprade_sword_damage.name)
	upgrade_pool.add_item(uprade_axe, 10)
	upgrade_pool.add_item(uprade_sword_rate, 10)
	upgrade_pool.add_item(uprade_sword_damage, 10)
	
	experience_manager.level_up.connect(on_level_up)
	
func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	update_upgrade_pool(upgrade)
	GameEvent.emit_ability_upgrade_add(upgrade, current_upgrades)
		

func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == uprade_axe.id:
		upgrade_pool.add_item(uprade_axe_damage, 10)


func pick_upgrades() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in 2:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
		
	return chosen_upgrades
	

func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)


func on_level_up(current_levle: int):
	printt("当前能力池数量：",upgrade_pool.items.size())
	var upgrade_screen_scene_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_scene_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_scene_instance.set_ability_upgrade(chosen_upgrades)
	upgrade_screen_scene_instance.upgrade_selected.connect(on_upgrade_selected)
	
