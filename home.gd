extends Node2D
var bullet_base_scene = preload("res://Bullets/bullet_base.tscn")
var enemy1_scene = preload("res://Enemies/enemy_1.tscn")
var enemy2_scene = preload("res://Enemies/enemy_2.tscn")
var enemy3_scene = preload("res://Enemies/enemy_3.tscn")
var turret_scene = preload("res://Objects/turret.tscn")
var turret_bullet_scene = preload("res://Bullets/turret_bullet.tscn")


var round_number = 1
var player_health = 100.0
var vault_health = 500
var turret_mode = false
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
	instance.look_at($Ground/Vault.position)

func _on_player_base_shoot_base_bullet(dir, pos):
	if turret_mode == false:
		var bullet = bullet_base_scene.instantiate()
		bullet.position = pos
		bullet.linear_velocity = dir * bullet.speed
		bullet.connect("bullet_hit", self.enemy_damage_taken)
		$Projectiles.add_child(bullet)
	elif turret_mode == true:
		create_turret()
	
	
func create_turret():
	var turret_position = get_global_mouse_position()
	var turret = turret_scene.instantiate()
	turret.position = turret_position
	turret.id = turret.get_instance_id()
	turret.connect("turret_shoot", self.turret_shoot)
	$Turrets.add_child(turret)
	turret_mode = false
	
func turret_shoot(id, dir):
	var turret_instance = instance_from_id(id)
	var bullet_instance = turret_bullet_scene.instantiate()
	bullet_instance.position = turret_instance.get_node("TurretBulletMarker").global_position
	bullet_instance.linear_velocity = dir * bullet_instance.speed
	bullet_instance.connect("bullet_hit", self.enemy_damage_taken)
	$Projectiles.add_child(bullet_instance)
	
func enemy_damage_taken(enemy_body, damage):
	enemy_body.health -= damage
	var transparency = enemy_body.health * 0.8
	enemy_body.get_child(0).modulate.a = transparency
	if enemy_body.health <= 0:
		enemy_body.queue_free()
	





func _on_testing_ui_quiz():
	$UIs/PurchasingUI.visible = false
	$UIs/TestingUI.visible = true
	Global.shootable = false
	


func _on_testing_ui_correct(question_type):
	if question_type == "multiplication":
		Global.balance += 2
	elif question_type == "algebra":
		Global.balance += 5
	$UIs/MainUI/Control/ScoreLabel.text = "Balance: " + str(Global.balance)
	$UIs/TestingUI.visible = false


func _on_purchasing_ui_buy():
	if $UIs/TestingUI.visible == false:
		$UIs/PurchasingUI.visible = !$UIs/PurchasingUI.visible
		if $UIs/PurchasingUI.visible == true:
			Global.shootable = false
		else:
			Global.shootable = true
	


func _on_purchasing_ui_buy_bullet_speed(cost):
	Global.bullet_speed += 10
	Global.balance -= cost
	$UIs/MainUI/Control/PlayerStatsControl/BulletSpeed.text = "Bullet Speed: " + str(Global.bullet_speed)

func _on_purchasing_ui_buy_speed(cost):
	var player_base = $Players/PlayerBase
	player_base.SPEED += 10
	Global.balance -= cost
	$UIs/MainUI/Control/PlayerStatsControl/PlayerSpeed.text = "Player Speed: " + str(player_base.SPEED)


func _on_purchasing_ui_buy_reload(cost):
	var bullet_timer = $Players/PlayerBase/BulletTimer
	bullet_timer.wait_time *= 0.95
	Global.balance -= cost
	$UIs/MainUI/Control/PlayerStatsControl/PlayerReload.text = "Player Reload: " + str(round(bullet_timer.wait_time * 100)/100)
func _on_purchasing_ui_buy_strength(cost):
	Global.bullet_strength += 1
	Global.balance -= cost
	$UIs/MainUI/Control/PlayerStatsControl/BulletStrength.text = "Bullet Strength: " + str(Global.bullet_strength)


func _on_enemy_1_timer_timeout():
	creating_enemies(enemy1_scene)
	
	
func _on_enemy_2_timer_timeout():
	creating_enemies(enemy2_scene)

func _on_enemy_3_timer_timeout():
	creating_enemies(enemy3_scene)



func _on_main_ui_next_round():
	round_number += 1
	$UIs/MainUI/Control/RoundLabel.text = "ROUND " + str(round_number)
	$UIs/MainUI/Control/RoundLabel.visible = true
	if round_number >= 8:
		$UIs/MainUI/RoundTimer.wait_time =  40
		$Enemy1Timer.one_shot = false
		$Enemy1Timer.start()
		$Enemy3Timer.start()
	elif round_number >= 6:
		$Enemy1Timer.one_shot = true
		$Enemy3Timer.start()
	elif round_number >= 3:
		$Enemy2Timer.start()	


func creating_enemies(enemy_scene):
	#Used for creating enemies to reduce repitition
	var enemy_two = enemy_scene.instantiate()
	var rand_pos = randi() % 6
	enemy_two.position = $EnemySpawnLocations.get_children()[rand_pos].position
	var dir = ($Ground/Vault.position - enemy_two.position).normalized()
	enemy_two.direction = dir
	enemy_two.id = enemy_two.get_instance_id()
	enemy_two.look_at($Ground/Vault.position)
	enemy_two.connect("go_to_vault", self.enemy_vault_recalibration)
	$Enemies.add_child(enemy_two)


func _on_player_base_hit_player(body):
	player_health -= body.body_damage
	update_player_health()
	
func update_player_health():
	var health_bar = $UIs/MainUI/Control/HealthBar
	var bar_value = player_health/Global.player_max_health 
	health_bar.value = bar_value

func _on_vault_vault_entered(body_damage):
	vault_health -= body_damage
	$UIs/MainUI/Control/VaultHealthBar.value = vault_health




func _on_purchasing_ui_buy_turret(_cost):
	$UIs/PurchasingUI.visible = false
	turret_mode = true
	
