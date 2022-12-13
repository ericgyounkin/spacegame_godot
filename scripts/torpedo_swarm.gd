extends Node

var vel = Vector2()
export var speed = 700
export var torpedo_count = 20
var velocity_mod = []

func _ready():
	generate_rand_velocities()
	add_to_group('torpedo_swarm')
	
func _process(delta):
	$path1/follow.offset = $path1/follow.offset + speed * delta * velocity_mod[0]
	$path2/follow.offset = $path2/follow.offset + speed * delta * velocity_mod[1]
	$path3/follow.offset = $path3/follow.offset + speed * delta * velocity_mod[2]
	$path4/follow.offset = $path4/follow.offset + speed * delta * velocity_mod[3]
	$path5/follow.offset = $path5/follow.offset + speed * delta * velocity_mod[4]
	$path6/follow.offset = $path6/follow.offset + speed * delta * velocity_mod[5]
	$path7/follow.offset = $path7/follow.offset + speed * delta * velocity_mod[6]
	$path8/follow.offset = $path8/follow.offset + speed * delta * velocity_mod[7]
	$path9/follow.offset = $path9/follow.offset + speed * delta * velocity_mod[8]
	$path10/follow.offset = $path10/follow.offset + speed * delta * velocity_mod[9]

func start_at(dir, muzzle):
	$path1.rotation = dir
	$path1.position = muzzle.global_position
	$path2.rotation = dir
	$path2.position = muzzle.global_position
	$path3.rotation = dir
	$path3.position = muzzle.global_position
	$path4.rotation = dir
	$path4.position = muzzle.global_position
	$path5.rotation = dir
	$path5.position = muzzle.global_position
	$path6.rotation = dir
	$path6.position = muzzle.global_position
	$path7.rotation = dir
	$path7.position = muzzle.global_position
	$path8.rotation = dir
	$path8.position = muzzle.global_position
	$path9.rotation = dir
	$path9.position = muzzle.global_position
	$path10.rotation = dir
	$path10.position = muzzle.global_position
	
func generate_rand_velocities():
	for i in range(10):
		velocity_mod.append(randf()+1)