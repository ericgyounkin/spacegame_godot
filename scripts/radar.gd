extends Area2D

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func update_settings(pts, rad):
	$Polygon2D.polygon = pts
	$CollisionShape2D.get_shape().radius = rad

func _on_radar_area_entered(area):
	if area.get_groups().has('zoomed_enemy'):
		area.entered_radar()
		
func _on_radar_area_exited(area):
	if area.get_groups().has('zoomed_enemy'):
		area.left_radar()
