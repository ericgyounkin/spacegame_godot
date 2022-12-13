extends Area2D

export var speed = 1100
var vel = Vector2(speed,0)
var weapon_name = 'web'
var continuous = false
var exclusion = 'enemy'

func _ready():
	add_to_group(weapon_name)
	
func _physics_process(delta):
	position += (vel * delta).rotated(rotation - PI/2)

func start_at(dir, muzzle, parent):
	set_rotation(dir)
	set_position(muzzle.global_position)
	
func _on_lifetime_timeout():
	queue_free()

func take_damage():
	queue_free()

func _on_openweb_timeout():
	$globsprite.visible = false
	$globcollision.disabled = true
	$websprite.visible = true
	$webcollision.disabled = false


func _on_web_body_entered(body):
	if not body.get_groups().has(exclusion):
		body.take_damage(global.damagelist[weapon_name])
		queue_free()
