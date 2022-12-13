extends Area2D

var vel = Vector2()
var start_dir = 0
export var speed = 200
var accel = Vector2(0,0)
var continuous = false
var exclusion = 'player'

func _ready():
	add_to_group('acidball')
	add_to_group('enemyprojectile')
	
func _physics_process(delta):
	rotation += 0.01
	if start_dir:
		vel = vel.rotated(start_dir - PI/2)
	set_position(get_position() + vel * delta)

func start_at(dir, muzzle):
	start_dir = dir
	set_rotation(dir)
	set_position(muzzle.global_position)
	vel = Vector2(speed, 0)
	
func take_damage(damage):
	queue_free()
	
func _on_lifetime_timeout():
	queue_free()

func _on_acid_ball_body_entered(body):
	if not body.get_groups().has(exclusion):
		queue_free()
		print(body)
		body.take_damage(global.damagelist['acidball'])
