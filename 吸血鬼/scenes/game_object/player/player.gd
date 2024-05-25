extends CharacterBody2D


@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var random_stream_player_2d_component = $RandomStreamPlayer2DComponent




var number_colliding_bodies = 0
var base_speed = 0

func _ready():
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvent.ability_upgrade_add.connect(on_ability_upgrade_add)
	update_health_display()


func _process(delta):
	base_speed = velocity_component.max_speed
	var move_ment_vector = get_movement_vevtor()
	# 返回单位长度的向量， 给斜向移动适配
	var direction = move_ment_vector.normalized()
	
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if move_ment_vector.x != 0 || move_ment_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	var move_sign = sign(move_ment_vector.x)
	if move_sign == 0:
		return
	else:
		visuals.scale = Vector2(move_sign, 1)

func get_movement_vevtor() -> Vector2:
	var movement_vector = Vector2.ZERO
	var x_movement = Input.get_axis("move_left","move_right")
	var y_movement = Input.get_axis("move_up", "move_down")
	
	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()


func update_health_display():
	health_bar.value = health_component.get_health_percent()



func on_body_entered(enter_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(exit_body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_health_changed():
	GameEvent.emit_player_damaged()
	update_health_display()
	random_stream_player_2d_component.play_random()


func on_ability_upgrade_add(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		printt("角色升级能力", ability_upgrade.name)
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * 0.1)

	

