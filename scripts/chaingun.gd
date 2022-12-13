extends Area2D

var vel = Vector2()
export var speed = 2000
var continuous = false
var exclusion = 'player'

func _ready():
	add_to_group('chaingun')
	
func _physics_process(delta):
	set_position(get_position() + vel * delta)

func start_at(dir, muzzle):
	set_rotation(dir)
	set_position(muzzle.global_position)
	vel = Vector2(speed, 0).rotated(dir - PI/2)
	
func _on_lifetime_timeout():
	queue_free()
	
func take_damage(damage):
	queue_free()

#func _on_lasersoundtimeout_timeout():
#	$AudioStreamPlayer.stop()

func _on_chaingun_body_entered(body):
	if not body.get_groups().has(exclusion):
		queue_free()
		body.take_damage(global.damagelist['chaingun'])