extends Area2D

var vel = Vector2()
var continuous = false
var muz = null
var player_wr


func _ready():
	player_wr = weakref(get_tree().get_nodes_in_group('player')[0])
	add_to_group('fwd_deflector')
	
func _physics_process(delta):
	if muz != null and player_wr.get_ref():
		set_rotation(player_wr.get_ref().rotation)
		set_position(muz.global_position + Vector2(0,-100).rotated(rotation))

func start_at(dir, muzzle):
	muz = muzzle
	set_rotation(player_wr.get_ref().rotation)
	set_position(muz.global_position + Vector2(0,-100).rotated(rotation))
	visible = true
	
func _on_lifetime_timeout():
	queue_free()

func _on_fwd_deflector_area_entered(body):
	pass
		
func take_damage(damage):
	pass