extends StaticBody2D
signal vault_entered(body_damage) 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	print("in area entered")
	if body is BaseEnemy:
		vault_entered.emit(body.body_damage)
