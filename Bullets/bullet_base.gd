extends RigidBody2D

var strength

signal bullet_hit(enemy_body, damage)
# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		bullet_hit.emit(body, strength)
		queue_free()
		
