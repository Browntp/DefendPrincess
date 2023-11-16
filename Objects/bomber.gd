extends StaticBody2D

signal bomber_stats(id)
signal bomb_hit(body, strength)

var bullet_instance = preload("res://Bullets/BomberBomb.tscn")

var max_health = 10.0
var health = 10.0
var bullet_strength = 2
var bullet_speed = 250
var bullet_radius_scale = Vector2(1,1)

var enemies_in_range = []
var id 

#make the turret shoot at the body that is in index 0 of the bodies, once the bodies arent in its area anymore get them out of the list
var damage_taken_per_second = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if enemies_in_range:
		look_at(enemies_in_range[0].global_position)


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		enemies_in_range.append(body)


func _on_area_2d_body_exited(body):
	if body.is_in_group("enemy"):
		enemies_in_range.erase(body)


func _on_bomber_bullet_timer_timeout():
	if enemies_in_range:
		var dir = (enemies_in_range[0].position - global_position).normalized()
		bomber_shoot(dir)
		


func _on_damage_taken_timer_timeout():
	health -= damage_taken_per_second
	print(health)
	$HealthBar.value = health/max_health
	if health <= 0:
		queue_free()


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		bomber_stats.emit(id)
		

func bomber_shoot(dir): 
	var bomb = bullet_instance.instantiate()
	bomb.speed = bullet_speed
	bomb.strength = bullet_strength 
	bomb.position = $Marker2D.global_position
	bomb.linear_velocity = dir * bullet_speed
	bomb.get_node("Area2D").scale = bullet_radius_scale
	bomb.connect("bullet_hit", self.enemy_damage_taken)
	get_parent().get_parent().get_node("Projectiles").add_child(bomb)
	
	
func enemy_damage_taken(body, strength):
	bomb_hit.emit(body, strength)
	



func _on_area_2d_2_body_entered(body):
	
	if body is BaseEnemy:
		damage_taken_per_second += body.body_damage


func _on_area_2d_2_body_exited(body):
	if body is BaseEnemy:
		damage_taken_per_second -= body.body_damage
