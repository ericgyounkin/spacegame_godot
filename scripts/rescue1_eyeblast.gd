extends Area2D

var vel = Vector2()
var speed = 2000
var continuous = false

func _ready():
	add_to_group('rescue1_eyeblast')
	add_to_group('enemyprojectile')
	
func _physics_process(delta):
	set_position(get_position() + vel * delta)

func start_at(dir, muzzle, parent=null):
	set_rotation(dir + PI/2)
	set_position(muzzle.global_position)
	vel = Vector2(speed, 0).rotated(dir - PI/2)
	
func _on_lifetime_timeout():
	queue_free()
	
func take_damage(damage):
	pass

func _on_rescue1_eyeblast_body_entered(body):
	if body.get_groups().has('player'):
		queue_free()
		body.take_damage(global.damagelist['rescue1_eyeblast'])
