extends KinematicBody2D

signal explode

var size
var vel = Vector2()
var rot_speed = 1
var screen_size
var extents
var textures = {'big': 'res://art/objects/asteroid250.png',
				'med': 'res://art/objects/asteroid150.png',
				'small': 'res://art/objects/asteroid50.png',
				'tiny': 'res://art/objects/asteroid20.png'}

# colliding with asteroids triggers explode signal multiple times.  Only want to explode once
var explode_once = 1
var locs 
var health = 0

func _ready():
	add_to_group('asteroid')
	randomize()
	screen_size = get_viewport_rect().size

func init(init_size, init_pos, init_vel):
	size = init_size
	health = global.ast_health[size]
	if init_vel.length() > 0:
		vel = init_vel
	else:
		vel = Vector2(rand_range(30,100), 0).rotated(rand_range(0,2*PI))
	rot_speed = rand_range(-1.5, 1.5)
	var tex = load(textures[size])
	$Sprite.texture = tex
	extents = tex.get_size() / 2
	var shape = CircleShape2D.new()
	shape.radius = min(tex.get_width() / 2, tex.get_height() / 2)
	$CollisionShape2D.shape = shape
	if init_pos:
		position = init_pos
	else:
		position = Vector2(rand_range(0, screen_size.x), rand_range(0, screen_size.y))
	
func _physics_process(delta):
	set_rotation(get_rotation() + rot_speed * delta)
	var collision = move_and_collide(vel * delta)
	if collision:
		vel = vel.bounce(collision.normal)
		puff_of_dust(collision.position)
		
	# wrap around screen edges
	if position.x >= global.right_screen_limit:
		position.x = global.left_screen_limit
	elif position.x < global.left_screen_limit:
		position.x = global.right_screen_limit
	if position.y >= global.bottom_screen_limit:
		position.y = global.top_screen_limit
	elif position.y < global.top_screen_limit:
		position.y = global.bottom_screen_limit
		
func puff_of_dust(pos):
	$puff.global_position = pos
	$puff.emitting = true
	
func take_damage(damage):
	health -= damage
	puff_of_dust(position)
	if health <= 0 and explode_once:
		explode_once -= 1
		emit_signal('explode', size, position, vel, Vector2(rand_range(-5,6),rand_range(-5,6)))
		queue_free()