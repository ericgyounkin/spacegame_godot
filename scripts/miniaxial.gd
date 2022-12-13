extends "res://scripts/enemy.gd"


func _ready():
	add_to_group('axial')
	add_to_group('enemy')

func _process(delta):
	$'../'.offset = $'../'.offset + 400 * delta

func assign_id(id):
	monster_id = id
