extends Node2D
var bullet_base_scene = preload("res://Bullets/bullet_base.tscn")
var enemy1_scene = preload("res://Enemies/enemy_1.tscn")
var enemy2_scene = preload("res://Enemies/enemy_2.tscn")
var round = 1
var player_health = 100.0
var vault_health = 50.0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Players/PlayerBase.position = $StartingPosition.position
	$UIs/TestingUI.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	


func enemy_vault_recalibration(id):
	var instance = instance_from_id(id)
	instance.direction = ($Ground/Vault.position - instance.position).normalized()

func _on_player_base_shoot_base_bullet(dir, pos):
	if $UIs/TestingUI.visible == false and $UIs/PurchasingUI.visible == false:
		var bullet = bullet_base_scene.instantiate()
		bullet.position = pos
		bullet.linear_velocity = dir * bullet.speed
		bullet.connect("bullet_hit", self.enemy_damage_taken)
		$Projectiles.add_child(bullet)
	else:
		return
	
	
func enemy_damage_taken(enemy_body, damage):
	enemy_body.health -= damage
	if enemy_body.health <= 0:
		enemy_body.queue_free()
	





func _on_testing_ui_quiz():
	$UIs/PurchasingUI.visible = false
	$UIs/TestingUI.visible = true
	


func _on_testing_ui_correct():
	Global.balance += 2
	$UIs/MainUI/Control/ScoreLabel.text = "Balance: " + str(Global.balance)
	$UIs/TestingUI.visible = false


func _on_purchasing_ui_buy():
	if $UIs/TestingUI.visible == false:
		$UIs/PurchasingUI.visible = !$UIs/PurchasingUI.visible
	


func _on_purchasing_ui_buy_bullet_speed(cost):
	Global.bullet_speed += 10
	Global.balance -= cost


func _on_purchasing_ui_buy_speed(cost):
	$Players/PlayerBase.SPEED += 10
	Global.balance -= cost


func _on_purchasing_ui_buy_reload(cost):
	$Players/PlayerBase/BulletTimer.wait_time *= 0.95
	Global.balance -= cost

func _on_purchasing_ui_buy_strength(cost):
	Global.bullet_strength += 1
	Global.balance -= cost


func _on_enemy_1_timer_timeout():
	creating_enemies(enemy1_scene)
func _on_enemy_2_timer_timeout():
	creating_enemies(enemy2_scene)





func _on_main_ui_next_round():
	round += 1
	$UIs/MainUI/Control/RoundLabel.text = "ROUND " + str(round)
	$UIs/MainUI/Control/RoundLabel.visible = true
	if round >= 6:
		pass
	elif round >= 3:
		$Enemy2Timer.start()	


func creating_enemies(enemy_scene):
	#Used for creating enemies to reduce repitition
	var enemy_two = enemy_scene.instantiate()
	var rand_pos = randi() % 6
	enemy_two.position = $EnemySpawnLocations.get_children()[rand_pos].position
	var dir = ($Ground/Vault.position - enemy_two.position).normalized()
	enemy_two.direction = dir
	enemy_two.id = enemy_two.get_instance_id()
	enemy_two.connect("go_to_vault", self.enemy_vault_recalibration)
	$Enemies.add_child(enemy_two)


func _on_player_base_hit_player(body):
	player_health -= body.body_damage
	update_player_health()
	
func update_player_health():
	var health_bar = $UIs/MainUI/Control/HealthBar
	var bar_value = player_health/Global.player_max_health * 100
	health_bar.value = bar_value

func _on_vault_vault_entered(body_damage):
	vault_health -= body_damage
	print(vault_health)
