extends Area2D

var id = 0

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	$small_enemy_path1/PathFollow2D.offset = $small_enemy_path1/PathFollow2D.offset + 30 * delta
	$small_enemy_path2/PathFollow2D.offset = $small_enemy_path2/PathFollow2D.offset + 30 * delta
	$small_enemy_path3/PathFollow2D.offset = $small_enemy_path3/PathFollow2D.offset + 30 * delta
	$small_enemy_path4/PathFollow2D.offset = $small_enemy_path4/PathFollow2D.offset + 30 * delta

func get_id():
	return id
	
func assign_id(new_id):
	id = new_id