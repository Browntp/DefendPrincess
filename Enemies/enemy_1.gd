extends BaseEnemy


func _on_sensory_area_2d_body_entered(body):
	direction = (body.position - position).normalized()
	look_at(body.global_position)

func _on_sensory_area_2d_body_exited(body):
	go_to_vault.emit(id)
