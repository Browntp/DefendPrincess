extends RigidBody2D

var speed
var body_damage

signal bullet_hit(body)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_death_timer_timeout():
	queue_free()


func _on_body_entered(body):
	bullet_hit.emit(body)
	queue_free()
