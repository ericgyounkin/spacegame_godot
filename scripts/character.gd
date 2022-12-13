extends KinematicBody2D

var vel = Vector2()
var transitioning = false
var skip_extra_wheel = true
var state = 0

func _ready():
	add_to_group('character')
	$customcamera.target_zoom = 0.3
	$customcamera.smooth_zoom = 0.3
	if global.last_player_pos:
		position = global.last_player_pos
	if state == 0 and global.gamestate == 0:
		$cutscenetimer.wait_time = 1
		$cutscenetimer.start()

func _process(delta):
	get_input(delta)
	move_and_slide(vel)
	handle_scene_change()
	if state in [1, 3]:
		$move_sprite.animation = 'up'
		vel = Vector2(0, -40)
	elif state == 7:
		$move_sprite.animation = 'up'
		vel = Vector2(0, -120)
	elif state in [2, 4, 5, 6]:
		$move_sprite.animation = 'stand'
		vel = Vector2()
	
func _input(event):
	if global.gamestate != 0:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_WHEEL_UP:
				if skip_extra_wheel and $customcamera.target_zoom >= 0.2:
					$customcamera.target_zoom -= 0.025
				else:
					skip_extra_wheel = true
			if event.button_index == BUTTON_WHEEL_DOWN and skip_extra_wheel:
				if skip_extra_wheel and $customcamera.target_zoom <= 0.7:
					$customcamera.target_zoom += 0.025
				else:
					skip_extra_wheel = true

func handle_scene_change():
	if position.x >= 665 and position.x <= 840 and position.y <= 20:
		spaceport_change()
	#if position.x >= 605 and position.x <= 635 and position.y >= 105 and position.y <= 135:
		#shopscene_change()
		#$'../'.shopintro()
	if position.x >= 1359:
		position.x = 1359
	elif position.x <= 5:
		position.x = 5
	if position.y >= 752:
		position.y = 752
	elif position.y <= 16:
		position.y = 16
		
func get_input(delta):
	if global.gamestate != 0:  # intro, you dont want the character moving around
		vel = Vector2()
		if Input.is_action_pressed('player_thrust'):
			vel += Vector2(0, -80)
			$move_sprite.animation = 'up'
		if Input.is_action_pressed('player_down'):
			vel += Vector2(0, 80)
			$move_sprite.animation = 'down'
		if Input.is_action_pressed('player_left'):
			vel += Vector2(-80, 0)
			if !(Input.is_action_pressed('player_down') or Input.is_action_pressed('player_thrust')):
				$move_sprite.animation = 'left'
		if Input.is_action_pressed('player_right'):
			vel += Vector2(80, 0)
			if !(Input.is_action_pressed('player_down') or Input.is_action_pressed('player_thrust')):
				$move_sprite.animation = 'right'
		
		if Input.is_action_just_pressed('ui_cancel'):
			$'../CanvasLayer/ingamemenu'.show()
			get_tree().paused = true
		
	if vel == Vector2():
		$move_sprite.animation = 'stand'

func transition_zoomed():
	if not transitioning:
		transitioning = true
		$transition_timer.start()
		transition.fade_to("res://scenes/zoomed_out_battle.tscn")
		music_manager.playtrack('zoomedbattle')
		get_tree().paused = true

func shopscene_change():
	global.last_player_pos = global_position + Vector2(0,30)
	global.goto_scene("res://scenes/station/shopkeep1.tscn")
	
func spaceport_change():
	if global.gamestate == 0:
		global.gamestate = 1
	global.last_player_pos = global_position + Vector2(0,30)
	global.goto_scene("res://scenes/station/spaceport.tscn")

func _on_transition_timer_timeout():
	get_tree().paused = false

func _on_cutscenetimer_timeout():
	state += 1
	if state == 1:
		$cutscenetimer.wait_time = 1
		$cutscenetimer.start()
	elif state == 2:
		$cutscenetimer.wait_time = 31.8
		$cutscenetimer.start()
		$'../'.captaincutscene1()
	elif state == 3:
		$'../'.closecaptaintext()
		$cutscenetimer.wait_time = 2
		$cutscenetimer.start()
	elif state == 4:
		$'../stationexplosion1'.play()
		$'../'.captaincutscene2()
		$cutscenetimer.wait_time = 3
		$cutscenetimer.start()
	elif state == 5:
		$'../'.closecaptaintext()
		$'../stationexplosion1'.stop()
		$'../stationexplosion2'.play()
		$'../'.explosion()
		$cutscenetimer.wait_time = 3.3
		$cutscenetimer.start()
	elif state == 6:
		$'../stationexplosion2'.stop()
		$'../stationalarm'.play()
		$'../'.captaincutscene3()
		$cutscenetimer.wait_time = 18.5
		$cutscenetimer.start()
	elif state == 7:
		$'../'.closecaptaintext()
		$cutscenetimer.wait_time = 6
		$cutscenetimer.start()