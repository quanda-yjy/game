extends PanelContainer


signal  selected

@onready var name_lable = %NameLable
@onready var description_lable = %DescriptionLable
@onready var animation_player = $AnimationPlayer
@onready var hover_animation_player = $HoverAnimationPlayer

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)


func play_in(delay: float):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")

func set_ability_upgrade(upgrade: AbilityUpgrade):
	printt("随机升级的能力:", upgrade == null)
	name_lable.text = upgrade.name
	description_lable.text = upgrade.decription


func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		selected.emit()
	

func on_mouse_entered():
	hover_animation_player.play("hover")
	
