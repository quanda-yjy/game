extends PanelContainer


signal  selected

@onready var name_lable = %NameLable
@onready var description_lable = %DescriptionLable

func _ready():
	gui_input.connect(on_gui_input)

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_lable.text = upgrade.name
	description_lable.text = upgrade.decription


func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		selected.emit()
	
