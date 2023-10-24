extends CanvasLayer
signal NextRound
var round = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("ChangeBalance", change_balance)
	

func change_balance():
	$Control/ScoreLabel.text = "Balance: " + str(Global.balance)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_round_timer_timeout():
	NextRound.emit()
	$RoundLabelVisibilityTimer.start()
	


func _on_round_label_visibility_timer_timeout():
	$Control/RoundLabel.visible = false
