extends RigidBody2D

var speed
var strength

signal bullet_hit
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_death_timer_timeout():
	queue_free()
