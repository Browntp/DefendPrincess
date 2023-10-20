extends BaseEnemy


func _on_sensory_area_2d_body_entered(body):
	direction = (body.position - position).normalized()


func _on_sensory_area_2d_body_exited(body):
	go_to_vault.emit(id)
