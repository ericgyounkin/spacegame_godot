extends Area2D

var vel = Vector2()
var continuous = false
var rand_rot = 0
var rand_speed = 0
var rand_dir = 0


func _ready():
	add_to_group('spawner_fly')
	
func _physics_process(delta):
	set_position(get_position() + vel * delta)
	rotation += rand_rot

func start_at(dir, muzzle):
	rand_rot = rand_range(0.0015, 0.015)
	rand_speed = rand_range(500,800)
	rand_dir = rand_range(-PI/6, PI/6)
	set_rotation(dir + rand_dir)
	set_position(muzzle.global_position)
	vel = Vector2(rand_speed, 0).rotated(dir + rand_dir - PI/2)
	
func _on_lifetime_timeout():
	queue_free()
	
func take_damage(damage):
	pass


func _on_spawner_fly_body_entered(body):
	if body.get_groups().has('player'):
		queue_free()
		body.take_damage(global.damagelist['spawner_fly'])
