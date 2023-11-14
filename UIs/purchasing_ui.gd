extends CanvasLayer


signal set_labels()
signal buy
signal BuyStrength()
signal BuySpeed()
signal BuyBulletSpeed()
signal BuyReload()
signal BuyTurret()

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	set_labels.emit()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("buy"):
		buy.emit()



func _on_strength_button_down():
	BuyStrength.emit()


func _on_speed_button_down():
	BuySpeed.emit()


func _on_bullet_speed_button_down():
	BuyBulletSpeed.emit()


func _on_reload_time_button_down():
	BuyReload.emit()



func _on_turret_btn_button_up():
	BuyTurret.emit()
	Global.shootable = true
