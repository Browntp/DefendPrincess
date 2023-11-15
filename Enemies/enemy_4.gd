extends BaseEnemy

var list_of_targets = []
var bullet_strength = 4
var bullet_speed = 200


var bullet_instance = preload("res://Bullets/enemy_4_bullet.tscn")
func _ready():
	health = 3
	speed = 70
	body_damage = 2
	

		
func _on_area_2d_body_entered(body):
	if !body.is_in_group("enemy"):
		list_of_targets.append(body)



func _on_area_2d_body_exited(body):
	if !body.is_in_group("enemy"):
		list_of_targets.erase(body)

func _on_reload_timer_timeout():
	if list_of_targets:
		look_at(list_of_targets[0].global_position)
		speed = 0
		var bullet = bullet_instance.instantiate()
		bullet.speed = bullet_speed
		bullet.strength = bullet_strength 
		bullet.position = $Marker2D.position
		var dir = (list_of_targets[0].global_position - global_position).normalized()
		bullet.linear_velocity = dir * bullet.speed
		#bullet_instance.connect("bullet_hit", self.enemy_damage_taken)
		$Projectiles.add_child(bullet)
	else:
		speed = 70
		go_to_vault.emit(id)