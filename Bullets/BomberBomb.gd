extends RigidBody2D

signal bullet_hit(body, strength)
var strength
var speed
var dir
var enemies_in_range = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_warning_timer_timeout():
	$Area2D/Sprite2D.visible = true
	$DeathTimer.start()

func _on_death_timer_timeout():
	if enemies_in_range:
		for enemy in enemies_in_range:
			bullet_hit.emit(enemy, strength)
	queue_free()
	


func _on_area_2d_body_entered(body):
	
	if body.is_in_group("enemy"):
		enemies_in_range.append(body)
		
		


func _on_area_2d_body_exited(body):
	if body.is_in_group("enemy"):
		enemies_in_range.erase(body)
