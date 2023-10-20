extends CanvasLayer

var speed_cost = 5
var strength_cost = 5
var bullet_speed_cost = 5
var reload_cost = 5

signal buy
signal BuyStrength(cost)
signal BuySpeed(cost)
signal BuyBulletSpeed(cost)
signal BuyReload(cost)
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	set_labels()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("buy"):
		buy.emit()

func set_labels():
	if Global.player_type == "speed":
		speed_cost = 3
		bullet_speed_cost = 4
		strength_cost = 7
		reload_cost = 4
	elif Global.player_type == "strength":
		speed_cost = 8
		bullet_speed_cost = 6
		strength_cost = 2
		reload_cost = 6
	$Control/GeneralPurchase/GeneralStats/BulletSpeed.text += str(bullet_speed_cost)
	$Control/GeneralPurchase/GeneralStats/Speed.text += str(speed_cost)
	$Control/GeneralPurchase/GeneralStats/Strength.text += str(strength_cost)
	$Control/GeneralPurchase/GeneralStats/ReloadTime.text += str(reload_cost)

func _on_strength_button_down():
	if(Global.balance >= strength_cost):
		BuyStrength.emit(strength_cost)


func _on_speed_button_down():
	if(Global.balance >= speed_cost):
		BuySpeed.emit(speed_cost)


func _on_bullet_speed_button_down():
	if(Global.balance >= bullet_speed_cost):
		BuyBulletSpeed.emit(bullet_speed_cost)


func _on_reload_time_button_down():
	if(Global.balance >= reload_cost):
		BuyReload.emit(reload_cost)
