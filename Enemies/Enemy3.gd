extends BaseEnemy
func _ready():
	health = 6
	speed = 45
	body_damage = 10


func _on_sensory_area_2d_body_entered(body):
	direction = (body.position - position).normalized()
	look_at(body.global_position)


func _on_sensory_area_2d_body_exited(_body):
	go_to_vault.emit(id)

