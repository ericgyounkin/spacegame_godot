extends Area2D

var speed = 50

func _ready():
	$moonpath/PathFollow2D/planet1_moon.show_behind_parent = true

func _process(delta):
	$moonpath/PathFollow2D.offset = $moonpath/PathFollow2D.offset + speed * delta
	if $moonpath/PathFollow2D/planet1_moon.global_position.y < global_position.y - 125:
		$moonpath/PathFollow2D/planet1_moon.z_index = -1
	elif $moonpath/PathFollow2D/planet1_moon.global_position.y > global_position.y + 65:
		$moonpath/PathFollow2D/planet1_moon.z_index = 1