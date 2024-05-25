extends CanvasLayer

signal back_pressed

@onready var sfxh_slider = %SFXHSlider
@onready var music_h_slider = %MusicHSlider
@onready var window_mode_button = %WindowModeButton
@onready var back_button = %BackButton



func _ready():
	window_mode_button.pressed.connect(on_window_mode_button_pressed)
	sfxh_slider.value_changed.connect(on_audio_slider_changed.bind("sfx"))
	music_h_slider.value_changed.connect(on_audio_slider_changed.bind("music"))
	
	back_button.pressed.connect(on_back_button_pressed)
	update_display()

func update_display():
	window_mode_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_mode_button.text = "FullScreen"
	
	sfxh_slider.value = get_bus_volume_percent("sfx")
	music_h_slider.value = get_bus_volume_percent("music")

func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume)


func set_bus_volume_percent(bus_name: String, percent: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	

func on_window_mode_button_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	update_display()


func on_audio_slider_changed(volume: float ,slider_name: String):
	set_bus_volume_percent(slider_name, volume)


func on_back_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	back_pressed.emit()
