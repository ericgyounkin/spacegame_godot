extends "res://scripts/enemy.gd"
var firing = false

func _ready():
	add_to_group('spawner')
	rotation = rotation - PI/2

func _process(delta):
	if (health < 0.25 * max_health) and been_hit:
		flee(delta)
	else:
		move_and_strafe(delta)
		if $weapon1/weapon1_timer.time_left == 0 and (distance <= stop_dist or been_hit) and not firing:
			firing = true
			$AnimatedSprite.play('firing')
			$regularanim.start()
			$shootanim.start()
		
func initialize(hlth):
	max_health = global.monsterlist['spawner'][0]
	move_speed = global.monsterlist['spawner'][1]
	rot_speed = global.monsterlist['spawner'][2]
	stop_dist = global.monsterlist['spawner'][3]
	if not hlth:
		health = global.monsterlist['spawner'][0]
	else:
		health = hlth
	
func _on_shootanim_timeout():
	shoot('weapon1', self)


func _on_regularanim_timeout():
	$AnimatedSprite.play('default')
	firing = false
