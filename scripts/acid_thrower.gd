extends Node

var acidball = preload("res://scenes/weapons/acid_ball.tscn")
var continuous = false
var exclusion = 'player'

var acidball1 = null
var acidball2 = null
var acidball3 = null

func start_at(dir, muzzle):
	acidball1 = acidball.instance()
	acidball1.exclusion = exclusion
	acidball1.position = muzzle.global_position
	acidball1.rotation = dir
	acidball1.vel = Vector2(acidball1.speed, 0).rotated(dir - PI/2)
	get_tree().get_root().add_child(acidball1)
	
	acidball2 = acidball.instance()
	acidball2.exclusion = exclusion
	acidball2.position = muzzle.global_position
	acidball2.rotation = dir + PI/16
	acidball2.vel = Vector2(acidball2.speed, 0).rotated(dir - PI/2 + PI/16)
	get_tree().get_root().add_child(acidball2)
	
	acidball3 = acidball.instance()
	acidball3.exclusion = exclusion
	acidball3.position = muzzle.global_position
	acidball3.rotation = dir - PI/16
	acidball3.vel = Vector2(acidball3.speed, 0).rotated(dir - PI/2 - PI/16)
	get_tree().get_root().add_child(acidball3)
