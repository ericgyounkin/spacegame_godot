extends Node
var fly = 0
var spawnfly = preload("res://scenes/enemies/spawner_fly.tscn")

func _ready():
	pass

func start_at(dir, muzzle, parent):
	for i in range(21):
		fly = spawnfly.instance()
		fly.start_at(dir, muzzle)
		$fly_container.add_child(fly)