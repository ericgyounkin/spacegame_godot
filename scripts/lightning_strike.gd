extends RayCast2D

var shoot_to = Vector2()
var ship_position = Vector2()
var ship_rotation = Vector2()
var wpn_muzzle = null
var beam_direction = 0
var beam_pos = Vector2()
var beam_dist = 0
var beam_hit = Vector2()
var fire = true
var fire_animation = false
var continuous = true
var hitting = false
var space_state = null
var parent = null

func _ready():
	add_to_group('lightning_strike')
	add_to_group('enemyprojectile')

func _physics_process(delta):
	if get_tree().get_nodes_in_group('player'):
		space_state = get_world_2d().direct_space_state
		ship_position = get_tree().get_nodes_in_group('player')[0].global_position
		global_position = wpn_muzzle.global_position
		beam_direction = ship_position.angle_to_point(global_position)
		if fire:
			handle_raycast()
			show_beam()
	
func start_at(dir, muzzle, par):
	parent = par
	wpn_muzzle = muzzle

func handle_raycast():
	var result = space_state.intersect_ray(global_position, ship_position, [parent])
	if result:
		fire = false
		result.collider.take_damage(global.damagelist['lightning_strike'])
		beam_dist = global_position.distance_to(result.position)
		return

func show_beam():
	if beam_dist:
		$lightning.region_rect.size = Vector2(beam_dist, 20)
		$lightning.rotation = beam_direction
		$lightning.global_position = global_position + Vector2(beam_dist/2,0).rotated(beam_direction)
		if not $lightning.visible:
			$lightning.show()

func _on_lifetime_timeout():
	queue_free()

func take_damage(damage):
	pass