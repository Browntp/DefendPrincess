extends RigidBody2D
var speed = 250
var strength = 10
signal bullet_hit(body, strength)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_death_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		bullet_hit.emit(body, strength)
		queue_free()
