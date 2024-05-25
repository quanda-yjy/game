extends CanvasLayer


signal  upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var crad_container: HBoxContainer = %CradContainer
@onready var animation_player = $AnimationPlayer


func _ready():
	get_tree().paused = true

func set_ability_upgrade(upgrades: Array[AbilityUpgrade]):
	var delay = 0.0
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate()
		crad_container.add_child(card_instance)
		card_instance.play_in(delay)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.selected.connect(on_upgrade_seclected.bind(upgrade))
		delay += 0.2

func on_upgrade_seclected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	animation_player.play("out")
	await animation_player.animation_finished
	get_tree().paused = false
	queue_free()
