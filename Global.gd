extends Node
signal ChangeBalance 
var balance = 0:
	get:
		return balance
	set(value):
		balance = value
		ChangeBalance.emit()
var player_type = "base"
var bullet_speed = 300
var bullet_strength = 1
var player_max_health = 100.0
