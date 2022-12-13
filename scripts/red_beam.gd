extends RayCast2D

var parentgrp = ''
var shoot_to = Vector2()
var ship_position = Vector2()
var ship_rotation = Vector2()
var wpn_muzzle = null
var beam_direction = 0
var beam_pos = Vector2()
var beam_dist = 0
var beam_hit = Vector2()
var fire = false
var fire_animation = false
var continuous = true
var hitting = false

func _ready():
	add_to_group('red_beam')
	#start_at(PI/2, Vector2(300,300))

func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	ship_position = get_tree().get_nodes_in_group(parentgrp)[0].global_position
	ship_rotation = get_tree().get_nodes_in_group(parentgrp)[0].rotation
	global_position = wpn_muzzle.global_position
	beam_direction = ship_rotation - PI/2
	play_firing_animation()
	if fire:
		handle_raycast()
		show_beam()
		#play_hitting_animation()
	
func start_at(dir, muzzle, parent=null):
	$AudioStreamPlayer.play()
	wpn_muzzle = muzzle
	fire_animation = true
	$charging.start()
	if parent == 'gorgon':
		parentgrp = 'gorgon'
	else:
		parentgrp = 'player'
		

func handle_raycast():
	self.cast_to = Vector2(3000, 0).rotated(beam_direction)
	self.enabled = true
	if self.is_colliding():
		var collider = self.get_collider()
		if collider != null:
			hitting = true
			collider.take_damage(global.damagelist['red_beam'])
			beam_hit = self.get_collision_point()
			beam_dist = global_position.distance_to(beam_hit)
	else:
		hitting = false
		beam_hit = 0
		beam_dist = 3000

func play_firing_animation():
	$beam_firing.rotation = beam_direction
	$beam_firing.global_position = global_position
	if fire_animation:
		fire_animation = false
		$beam_firing.show()
		$beam_firing.play()
	if $beam.visible:
		$beam_firing.hide()

func show_beam():
	$beam.region_rect.size = Vector2(beam_dist, 8)
	$beam.rotation = beam_direction
	$beam.global_position = global_position + Vector2(beam_dist/2,0).rotated(beam_direction)
	if not $beam.visible:
		$beam.show()

func play_hitting_animation():
	if hitting:
		$beam_hitting.rotation = beam_direction
		$beam_hitting.global_position = beam_hit
		if not $beam_hitting.visible:
			$beam_hitting.show()
		if not $beam_hitting.is_playing():
			$beam_hitting.play()
	else:
		$beam_hitting.hide()
		$beam_hitting.stop()

func _on_lifetime_timeout():
	queue_free()

func _on_charging_timeout():
	fire = true