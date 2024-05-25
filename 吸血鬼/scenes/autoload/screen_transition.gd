extends CanvasLayer


signal transition_halfway

@onready var animation_player = $AnimationPlayer

var skip_emit = false

func transition():
	animation_player.play("default")
	await animation_player.animation_finished
	skip_emit = true
	animation_player.play_backwards("default")
	


func emit_transition_halfway():
	if skip_emit:
		skip_emit = false
		return
	transition_halfway.emit()
	
