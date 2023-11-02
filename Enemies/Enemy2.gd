extends BaseEnemy

func _ready():
	health = 4
	speed = 65
	body_damage = 5
	
	

	




func _on_sensory_area_2d_body_entered(body):
	direction = (body.position - position).normalized()
	look_at(body.global_position)

func _on_sensory_area_2d_body_exited(_body):
	go_to_vault.emit(id)
