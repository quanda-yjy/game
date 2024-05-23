extends Node


@export var health_compnent: Node
@export var sprite: Sprite2D

@export var hit_flash_meterial: ShaderMaterial

var hit_falsh_tween: Tween


func _ready():
	health_compnent.health_changed.connect(on_health_changed)
	sprite.material =hit_flash_meterial


func on_health_changed():
	if hit_falsh_tween != null && hit_falsh_tween.is_valid():
		hit_falsh_tween.kill()
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_falsh_tween = create_tween()
	hit_falsh_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, 0.25)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
