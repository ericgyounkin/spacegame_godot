extends Area2D

var vel = Vector2()
var start_dir = 0
export var speed = 400
var accel = Vector2(0,0)
var continuous = false
var homing = false
var exclusion = 'player'

func _ready():
	add_to_group('torpedo1')
	
func _physics_process(delta):
	accel += Vector2(30,0)
	if start_dir:
		if homing:
			movement_behavior(delta)
		else:
			movement_behavior_std(delta)

func movement_behavior_std(delta):
	position += ((accel + vel) * delta).rotated(rotation - PI/2)

func start_at(dir, muzzle):
	start_dir = dir
	set_rotation(dir)
	set_position(muzzle.global_position)
	vel = Vector2(speed, 0)
	
func take_damage(damage):
	queue_free()
	
func _on_lifetime_timeout():
	queue_free()
	
func _on_torpedo1_body_entered(body):
	if not body.get_groups().has(exclusion):
		queue_free()
		body.take_damage(global.damagelist['torpedo1'])