extends PanelContainer


signal  selected

@onready var name_lable = %NameLable
@onready var description_lable = %DescriptionLable
@onready var animation_player = $AnimationPlayer
@onready var hover_animation_player = $HoverAnimationPlayer

var discard = false

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)


func play_in(delay: float):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")

func play_discard():
	animation_player.play("discard")

func set_ability_upgrade(upgrade: AbilityUpgrade):
	printt("随机升级的能力:", upgrade == null)
	name_lable.text = upgrade.name
	description_lable.text = upgrade.decription


func select_card():
	discard = true
	animation_player.play("selected")
	
	for other_card in get_tree().get_nodes_in_group("upgrade_card"):
		if other_card == self:
			continue
		other_card.play_discard()
	await animation_player.animation_finished
	selected.emit()


func on_gui_input(event: InputEvent):
	if discard:
		return
	if event.is_action_pressed("left_click"):
		select_card()
	

func on_mouse_entered():
	if discard:
		return
	hover_animation_player.play("hover")
	
