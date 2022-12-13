extends Node2D

var max_health = 0
var move_speed = 1000
var rot_speed = 0
var stop_dist = 0
var health = 0
var monster_id = null

func _ready():
	add_to_group('rescue2')
	# Initialization here
	pass

func init(id):
	add_to_group('enemy')
	monster_id = id
	$path/follow/rescue2_tail.assign_id(id)
	$path/follow9/rescue2_head.assign_id(id)
	$path/follow2/rescue2_segment.assign_id(id)
	$path/follow3/rescue2_segment.assign_id(id)
	$path/follow4/rescue2_segment.assign_id(id)
	$path/follow5/rescue2_segment.assign_id(id)
	$path/follow6/rescue2_segment.assign_id(id)
	$path/follow7/rescue2_segment.assign_id(id)
	$path/follow8/rescue2_segment.assign_id(id)
	
func initialize(hlth):
	max_health = global.monsterlist['rescue2'][0]
	move_speed = global.monsterlist['rescue2'][1]
	rot_speed = global.monsterlist['rescue2'][2]
	stop_dist = global.monsterlist['rescue2'][3]
	if not hlth:
		health = global.monsterlist['rescue2'][0]
	else:
		health = hlth

func _process(delta):
	$path/follow.offset = $path/follow.offset + move_speed * delta
	$path/follow2.offset = $path/follow2.offset + move_speed * delta
	$path/follow3.offset = $path/follow3.offset + move_speed * delta
	$path/follow4.offset = $path/follow4.offset + move_speed * delta
	$path/follow5.offset = $path/follow5.offset + move_speed * delta
	$path/follow6.offset = $path/follow6.offset + move_speed * delta
	$path/follow7.offset = $path/follow7.offset + move_speed * delta
	$path/follow8.offset = $path/follow8.offset + move_speed * delta
	$path/follow9.offset = $path/follow9.offset + move_speed * delta
