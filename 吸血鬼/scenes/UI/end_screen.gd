extends CanvasLayer

@onready var restar_button = %RestarButton
@onready var quit_button = %QuitButton
@onready var title_label = %TitleLabel
@onready var description_label = %DescriptionLabel



func _ready():
	get_tree().paused = true
	restar_button.pressed.connect(on_restart_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	
	
func set_defeat():
	title_label.text ="Defeat"
	description_label.text = "You lost!"
	pass

func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	
	

func on_quit_button_pressed():
	get_tree().quit()
