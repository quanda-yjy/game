extends Node


const SPAWN_RADIUS = 375

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_weight_table = WeightTable.new()

func _ready():
	enemy_weight_table.add_item(basic_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)



func get_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
		
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU)) 
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)	
		
		var query_paramaters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters)
		if result.is_empty():
			break
		else:
			if i == 3:
				spawn_position = Vector2.ZERO
			random_direction = random_direction.rotated(deg_to_rad(90))

	
	return spawn_position
	
		

func on_timer_timeout():
	timer.start()
	
	var enemy_position = get_spawn_position()
	if enemy_position.is_equal_approx(Vector2.ZERO):
		return
	
	var enemy_scene = enemy_weight_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if entities_layer == null:
		get_parent().add_child(enemy)
	else:
		entities_layer.add_child(enemy)
	enemy.global_position = enemy_position
	


func on_arena_difficulty_increased(arena_difficuty: int):
	var time_off = (0.1 / 12) * arena_difficuty
	time_off = min(time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off
	printt("当前等级:", arena_difficuty)
	if arena_difficuty == 6:
		enemy_weight_table.add_item(wizard_enemy_scene, 20)
