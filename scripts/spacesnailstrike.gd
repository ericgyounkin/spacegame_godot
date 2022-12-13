extends Area2D

var vel = Vector2()
var weapon_name = 'spacesnailstrike'
var continuous = false
var exclusion = 'enemy'

func _ready():
	$CollisionShape2D.disabled = true
	add_to_group(weapon_name)
	
func _physics_process(delta):
	set_position(get_position() + vel * delta)
	#$CollisionShape2D.position = $Sprite.position
	#$CollisionShape2D.rotation = $Sprite.rotation
	
func _on_lifetime_timeout():
	queue_free()

func _on_spacesnailstrike_body_entered(body):
	if not body.get_groups().has(exclusion):
		body.take_damage(global.damagelist[weapon_name])
		

