extends StaticBody2D

var id 

signal go_to_vault(id)
signal healer_stats(id)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		healer_stats.emit(id)


func _on_enemy_sensor_body_entered(body):
	if body.is_in_group("enemy") and not body.is_in_group("enemy4") :
		body.direction = (position - body.position).normalized()
		body.look_at(global_position)


func _on_enemy_sensor_body_exited(body):
	if body.is_in_group("enemy") and not body.is_in_group("enemy4"):
		go_to_vault.emit(body.id)


func _on_timer_timeout():
	pass # Replace with function body.
