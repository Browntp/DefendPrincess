extends StaticBody2D

signal turret_shoot(id, dir)
var max_health = 10.0
var health = 10.0
var current_target = null
var id 
#make the turret shoot at the body that is in index 0 of the bodies, once the bodies arent in its area anymore get them out of the list
var damage_taken_per_second = 0
func _physics_process(delta):
	if current_target:
		look_at(current_target.global_position)

func _on_area_2d_body_exited(body):
	if body.is_in_group("enemy"):
		current_target = null




func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		current_target = body
		


func _on_turret_bullet_timer_timeout():
	if current_target:
		var dir = (current_target.position - global_position).normalized()
		turret_shoot.emit(id, dir)
		


func _on_body_area_body_entered(body):
	if body is BaseEnemy:
		damage_taken_per_second += body.body_damage
		


func _on_body_area_body_exited(body):
	if body is BaseEnemy:
		damage_taken_per_second -= body.body_damage


func _on_damage_taken_timer_timeout():
	health -= damage_taken_per_second

	$HealthBar.value = health/max_health
	if health <= 0:
		queue_free()
