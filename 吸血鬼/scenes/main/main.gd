extends Node

@export var end_screen_scene: PackedScene

@onready var player = %Player

var pause_scene = preload("res://scenes/UI/pause_menu.tscn")

func _ready():
	player.health_component.died.connect(on_player_died)

# 所有未处理的事件会在场景树上冒泡，该方法获取未处理事件
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_scene.instantiate())
		# 设置事件已经被处理
		get_tree().root.set_input_as_handled()


func on_player_died():
	var  end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
