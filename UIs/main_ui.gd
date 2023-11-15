extends CanvasLayer
signal NextRound
signal HealthButtonPressed
signal BulletSpeedButtonPressed
signal StrengthButtonPressed
signal ReloadButtonPressed

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("ChangeBalance", change_balance)
	

func change_balance():
	$Control/RightControl/GeneralLabels/ScoreLabel.text = "Balance: " + str(Global.balance)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_round_timer_timeout():
	NextRound.emit()
	$RoundLabelVisibilityTimer.start()
	


func _on_round_label_visibility_timer_timeout():
	$Control/RoundLabel.visible = false


#FOR TURRET:

func _on_bullethealth_btn_button_up():
	HealthButtonPressed.emit()


func _on_bullet_strength_btn_button_up():
	StrengthButtonPressed.emit()


func _on_bullet_reload_btn_button_up():
	ReloadButtonPressed.emit()


func _on_bullet_speed_btn_button_up():
	BulletSpeedButtonPressed.emit()
