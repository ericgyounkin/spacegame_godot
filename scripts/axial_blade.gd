extends Area2D

var vel = Vector2()
var continuous = false
var exclusion = 'player'
var speed = 800

func _ready():
	add_to_group('axial_blade')
	add_to_group('enemyprojectile')
	
func _physics_process(delta):
	position += vel * delta
	rotation += 0.3

func start_at(dir, muzzle):
	set_rotation(dir)
	set_position(muzzle.global_position)
	vel = Vector2(speed, 0).rotated(dir - PI/2)
	
func _on_lifetime_timeout():
	queue_free()
	
func take_damage(damage):
	pass

func _on_axial_blade_body_entered(body):
	if not body.get_groups().has('axial'):
		queue_free()
		body.take_damage(global.damagelist['axial_blade'])
