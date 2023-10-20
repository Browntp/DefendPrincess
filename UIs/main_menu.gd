extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_speed_btn_button_down():
	Global.player_type = "speed"


func _on_strength_btn_button_down():
	Global.player_type = "strength"


func _on_balanced_btn_button_down():
	Global.player_type = "base"


func _on_start_btn_button_down():
	get_tree().change_scene_to_file("res://home.tscn")
