extends Node
class_name HealthComponent

signal died
signal helath_changed
signal health_decreased

@export var max_health: float = 10

var current_health

func _ready():
	current_health = max_health

func damage(damage_amout: float):
	current_health = max(current_health - damage_amout, 0)
	helath_changed.emit()
	if damage_amout > 0:
		health_decreased.emit()
	Callable(check_death).call_deferred()


func heal(heal_amout: int):
	damage(-heal_amout)

func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)

func check_death():
	if current_health == 0:
		print("died!!!!")
		died.emit()
		owner.queue_free()
