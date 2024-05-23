extends Area2D
class_name HurtboxComponent

@export var health_component: Node

var floating_text_scene = preload("res://scenes/floating_text.tscn")

func _ready():
	area_entered.connect(on_area_entered)
	

func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	var hitbox_componeent = other_area as HitboxComponent
	printt("hit enemy")
	health_component.damage(hitbox_componeent.damage)
	
	var float_text = floating_text_scene.instantiate() as Node2D
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	if foreground_layer == null:
		return
	foreground_layer.add_child(float_text)
	
	float_text.global_position = global_position + (Vector2.UP * 16)
	var format_string = "%0.1f"
	if round(hitbox_componeent.damage) == hitbox_componeent.damage:
		format_string = "%0.0f"
	float_text.start(format_string %hitbox_componeent.damage)
