extends StaticBody2D



signal turret_shoot(id, dir)
signal turret_stats(id)

var max_health = 10.0
var health = 10.0
var bullet_strength = 2
var bullet_speed = 250

var enemies_in_range = []
var id 

#make the turret shoot at the body that is in index 0 of the bodies, once the bodies arent in its area anymore get them out of the list
var damage_taken_per_second = 0
func _physics_process(delta):
	if enemies_in_range:
		look_at(enemies_in_range[0].global_position)

func _on_area_2d_body_exited(body):
	if body.is_in_group("enemy"):
		enemies_in_range.erase(body)




func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		enemies_in_range.append(body)
		


func _on_turret_bullet_timer_timeout():
	if enemies_in_range:
		var dir = (enemies_in_range[0].position - global_position).normalized()
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


func _on_body_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		turret_stats.emit(id)
		




