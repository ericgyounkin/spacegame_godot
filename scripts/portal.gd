extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	$small_enemy_path1/PathFollow2D.offset = $small_enemy_path1/PathFollow2D.offset + 10 * delta
	$small_enemy_path2/PathFollow2D.offset = $small_enemy_path2/PathFollow2D.offset + 10 * delta
	$small_enemy_path3/PathFollow2D.offset = $small_enemy_path3/PathFollow2D.offset + 10 * delta
	$small_enemy_path4/PathFollow2D.offset = $small_enemy_path4/PathFollow2D.offset + 10 * delta
	$small_enemy_path5/PathFollow2D.offset = $small_enemy_path5/PathFollow2D.offset + 10 * delta
	$small_enemy_path6/PathFollow2D.offset = $small_enemy_path6/PathFollow2D.offset + 10 * delta
	$small_enemy_path7/PathFollow2D.offset = $small_enemy_path7/PathFollow2D.offset + 10 * delta
	$small_enemy_path8/PathFollow2D.offset = $small_enemy_path8/PathFollow2D.offset + 10 * delta