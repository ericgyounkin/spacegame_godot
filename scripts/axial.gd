extends "res://scripts/enemy.gd"

func _ready():
	add_to_group('axial')
	player_wr = weakref(get_tree().get_nodes_in_group('player')[0])
	# Initialization here
	pass

func _process(delta):
	if (health < 0.25 * max_health) and been_hit:
		flee(delta)
	else:
		#seek_and_rotate(delta)
		pass
	
	#$Path2D1/PathFollow2D.offset = $Path2D1/PathFollow2D.offset + mini_move_speed * delta
	#$Path2D2/PathFollow2D.offset = $Path2D2/PathFollow2D.offset + mini_move_speed * delta
	#$Path2D3/PathFollow2D.offset = $Path2D3/PathFollow2D.offset + mini_move_speed * delta
	#$Path2D4/PathFollow2D.offset = $Path2D4/PathFollow2D.offset + mini_move_speed * delta
	#$Path2D5/PathFollow2D.offset = $Path2D5/PathFollow2D.offset + mini_move_speed * delta
	#$Path2D6/PathFollow2D.offset = $Path2D6/PathFollow2D.offset + mini_move_speed * delta

func init(pos, id):
	add_to_group('enemy')
	monster_id = id
	position = pos
	screen_size = get_viewport_rect().size
	$Path2D1/PathFollow2D/miniaxial.assign_id(id)
	$Path2D2/PathFollow2D/miniaxial.assign_id(id)
	$Path2D3/PathFollow2D/miniaxial.assign_id(id)
	$Path2D4/PathFollow2D/miniaxial.assign_id(id)
	$Path2D5/PathFollow2D/miniaxial.assign_id(id)
	$Path2D6/PathFollow2D/miniaxial.assign_id(id)
	
func initialize(hlth):
	max_health = global.monsterlist['axial'][0]
	move_speed = global.monsterlist['axial'][1]
	rot_speed = global.monsterlist['axial'][2]
	stop_dist = global.monsterlist['axial'][3]
	if not hlth:
		health = global.monsterlist['axial'][0]
	else:
		health = hlth