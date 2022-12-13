extends Area2D

signal player_damage

var vel = Vector2()
export var speed = 1000
var weapon_name = 'acid_breath'
var continuous = false
var exclusion = 'enemy'

func _ready():
	add_to_group('enemyprojectile')
	add_to_group(weapon_name)
	#if has_node("../../../../../Player"):
		#connect("player_damage", get_node("../../../../../Player"), 'take_damage')
	
func _physics_process(delta):
	set_position(get_position() + vel * delta)

func start_at(dir, muzzle, parent):
	set_rotation(dir)
	set_position(muzzle.global_position)
	
func _on_lifetime_timeout():
	queue_free()

func _on_acid_breath_body_entered(body):
	if not body.get_groups().has(exclusion):
		body.take_damage(global.damagelist[weapon_name])
		queue_free()