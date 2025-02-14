extends Node

@export var sword_ability: PackedScene

@onready var timer = $Timer

const MAX_RANGE = 150

var damage = 5
var base_wait_time


# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvent.ability_upgrade_add.connect(on_ability_upgrade_add)

func on_timer_timeout():
			
	var player_node  = get_tree().get_first_node_in_group("player") as Node2D
	if player_node == null:
		return
		
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func (enemy: Node2D):
		return enemy.global_position.distance_squared_to(player_node.global_position) < pow(MAX_RANGE, 2)
	)
	if enemies.size() == 0:
		return
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player_node.global_position)
		var b_distance = b.global_position.distance_squared_to(player_node.global_position)
		return  a_distance < b_distance
	)
	
	var sword_instance = sword_ability.instantiate() as Node2D
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	if foreground_layer == null:
		player_node.get_parent().add_child(sword_instance)
	else:
		foreground_layer.add_child(sword_instance)

	
	sword_instance.hitbox_component.damage = damage
	
	sword_instance.global_position = enemies[0].global_position
	# 将位置随机偏移4为半径的园内的任意位置
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_add(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id != "sword_rate":
		return
		
	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.1
	timer.wait_time = base_wait_time * (1 - percent_reduction)
	timer.start()
	
	
