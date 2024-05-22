extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var visuals = $Visuals

const MAX_SPEED = 40

func _process(delta):
	var dierction = get_direction_to_play()
	velocity = dierction * MAX_SPEED
	move_and_slide()
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign, 1)


func get_direction_to_play() -> Vector2:
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO
