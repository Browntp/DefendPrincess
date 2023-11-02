extends StaticBody2D
signal vault_entered(damage_taken) 
var damage_taken_per_second = 0
# Called when the node enters the scene tree for the first time.






func _on_area_2d_body_entered(body):
	if body is BaseEnemy:
		damage_taken_per_second += body.body_damage


func _on_damage_taken_timer_timeout():
	vault_entered.emit(damage_taken_per_second)


func _on_area_2d_body_exited(body):
	if body is BaseEnemy:
		damage_taken_per_second -= body.body_damage
