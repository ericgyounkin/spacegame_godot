extends KinematicBody2D

var explosion = preload("res://scenes/animations/explosion.tscn")

var transitioning = false

var screen_size
var rot_speed = 0
var pos = Vector2()
var vel = Vector2(0.1,0.1)
var max_vel = 0
var thrust = 0
var accel = Vector2()
var mouse_angle = 0
var skip_extra_wheel = true

func ready_player():
	$'../CanvasLayer/GUI'.hide_gui_coordinates()
	$customcamera.target_zoom = 3
	$customcamera.smooth_zoom = 3
	add_to_group('player')
	screen_size = get_viewport_rect().size
	#position = Vector2(screen_size.x / 10, screen_size.y / 2)
	position = Vector2(-2500, 0)
	pos = position
	
func handle_movement(delta, max_vel):
	vel += accel * delta
	vel = vel.clamped(max_vel)
	if vel:
		var collision = move_and_collide(vel * delta)
		if collision:
			vel = vel.bounce(collision.normal)
			for obj in collision.collider.get_groups():
				if obj in global.damagelist:
					take_damage(global.damagelist[obj])
			#puff_of_dust(collision.position)
			
	handle_transition()

func rotate_const_speed(a, b, d): #In radians
	if abs(a-b) >= PI: #only need to adjust for the long way round
		if a > b:
			b += 2 * PI
		else:
			a += 2 * PI
	if a > b:
		d = -d
	return move_towards_float(a, b, d)
	
func move_towards_float (x, target, step): #Moves towards t without passing it
	if abs(target - x) < abs(step):
		return target
	else: return x + step
	
func handle_transition():
	var rescuecls = $"../".return_class()
	if position.x >= global.right_screen_limit:
		if rescuecls == 'rescue':
			global.transition_dir = 'RIGHTRESC'
		else:
			global.transition_dir = 'RIGHT'
		transition_zoomed()
	elif position.x < global.left_screen_limit:
		if rescuecls == 'rescue':
			global.transition_dir = 'LEFTRESC'
		else:
			global.transition_dir = 'LEFT'
		transition_zoomed()
	elif position.y >= global.bottom_screen_limit:
		if rescuecls == 'rescue':
			global.transition_dir = 'DOWNRESC'
		else:
			global.transition_dir = 'DOWN'
		transition_zoomed()
	elif position.y < global.top_screen_limit:
		if rescuecls == 'rescue':
			global.transition_dir = 'TOPRESC'
		else:
			global.transition_dir = 'TOP'
		transition_zoomed()
		
func transition_zoomed():
	if not transitioning:
		transitioning = true
		deactivate_enemy()
		$transition_timer.start()
		transition.fade_to("res://scenes/zoomed_out_battle.tscn")
		music_manager.playtrack('zoomedbattle')
		get_tree().paused = true
		
func deactivate_enemy():
	for id in global.monsters.keys():
		if global.monsters[id]['in_battle']:
			global.monsters[id]['in_battle'] = false

func take_damage(damage):
	if global.shield > 0:
		global.shield -= damage
		if global.shield < 0:
			global.hull += global.shield
			global.shield = 0
		get_node('../CanvasLayer/GUI/modules/top_panel/status/Bars/Shield_Bar/Gauge').value = global.shield
		get_node('../CanvasLayer/GUI/modules/top_panel/status/Bars/Shield_Bar/Count/Background/Number').text = str(global.shield)
	else:
		global.hull -= damage
		get_node('../CanvasLayer/GUI/modules/top_panel/status/Bars/Hull_Bar/Gauge').value = global.hull
		get_node('../CanvasLayer/GUI/modules/top_panel/status/Bars/Hull_Bar/Count/Background/Number').text = str(global.hull)
		if global.hull <= 0:
			handle_death()

func webbed(status):
	if status:
		max_vel = global.max_vel / 4
	elif max_vel < global.max_vel:
		max_vel = global.max_vel

func handle_death():
	var enem = get_tree().get_nodes_in_group('enemy')[0]
	enem.turn_on_camera()
	queue_free()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			if skip_extra_wheel and $customcamera.target_zoom >= 0.5:
				$customcamera.target_zoom -= 0.05
			else:
				skip_extra_wheel = true
		if event.button_index == BUTTON_WHEEL_DOWN and skip_extra_wheel:
			if skip_extra_wheel and $customcamera.target_zoom <= 3:
				$customcamera.target_zoom += 0.05
			else:
				skip_extra_wheel = true