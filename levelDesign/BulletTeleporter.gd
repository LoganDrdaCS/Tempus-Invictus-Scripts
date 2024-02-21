extends Area2D

func _ready() -> void:
	pass

# PUT WALL ON THE LEFT SIDE AS FIRST IN THE TREE; WALL ON RIGHT AS SECOND

func _on_BulletTeleporter_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.get_collision_layer() == 32:
#		print('hello')
		match local_shape_index:
			0:
				area.position.x += 3590
			1:
				area.position.x -= 3590
