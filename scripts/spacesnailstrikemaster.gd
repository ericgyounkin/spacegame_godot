extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_left_right(dir):
	if dir == 'left':
		$spacesnailstrike.scale = Vector2(1,1)
		$AnimationPlayer.current_animation = 'swing_left'
	elif dir == 'right':
		$spacesnailstrike.scale = Vector2(-1,1)
		$AnimationPlayer.current_animation = 'swing_right'
				
func start_at(dir, muzzle):
	$spacesnailstrike/CollisionShape2D.disabled = false
	$spacesnailstrike.rotation = dir
	$spacesnailstrike.global_position = muzzle.global_position
	$AnimationPlayer.play()
	
func adjustposition(pos):
	$positionTween.interpolate_property($spacesnailstrike, 'global_position', $spacesnailstrike.global_position, $spacesnailstrike.global_position + pos, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$positionTween.start()
	
func adjustrotation(rot):
	$rotationTween.interpolate_property($spacesnailstrike, 'rotation', $spacesnailstrike.rotation, $spacesnailstrike.rotation + rot, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$rotationTween.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

func _on_rotationTween_tween_completed(object, key):
	pass

func _on_positionTween_tween_completed(object, key):
	pass
