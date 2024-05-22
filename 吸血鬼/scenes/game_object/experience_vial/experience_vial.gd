extends Node2D

@onready var area_2d = $Area2D


func _ready():
	area_2d.area_entered.connect(on_area_entered)



func on_area_entered(other_area: Area2D):
	GameEvent.emit_experience_vial_collected(1)
	queue_free()
	
