extends Node2D
var bullet_base_scene = preload("res://Bullets/bullet_base.tscn")
var enemy1_scene = preload("res://Enemies/enemy_1.tscn")
var enemy2_scene = preload("res://Enemies/enemy_2.tscn")
var enemy3_scene = preload("res://Enemies/enemy_3.tscn")
var enemy4_scene = preload("res://Enemies/enemy_4.tscn")
var turret_scene = preload("res://Objects/turret.tscn")
var turret_bullet_scene = preload("res://Bullets/turret_bullet.tscn")

var current_turret 
var round_number = 1
var player_health = 100.0
var vault_health = 500
var turret_mode = false

var speed_cost = 5
var strength_cost = 5
var bullet_speed_cost = 5
var reload_cost = 5
var turret_cost = 15

var turret_bullet_speed_cost = 20
var turret_bullet_reload_cost = 30
var turret_bullet_strength_cost = 27
var turret_bullet_health_cost = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	$Players/PlayerBase.position = $StartingPosition.position
	set_turret_labels()
	

	



func _on_player_base_shoot_base_bullet(dir, pos):
	if turret_mode == false:
		var bullet = bullet_base_scene.instantiate()
		bullet.position = pos
		bullet.linear_velocity = dir * bullet.speed
		bullet.connect("bullet_hit", self.enemy_damage_taken)
		$Projectiles.add_child(bullet)
	elif turret_mode == true:
		create_turret()
	
	

	


func _on_testing_ui_quiz():
	$UIs/PurchasingUI.visible = false
	$UIs/TestingUI.visible = true
	Global.shootable = false
	


func _on_testing_ui_correct(question_type):
	if question_type == "multiplication":
		Global.balance += 5
	elif question_type == "addition":
		Global.balance += 2
	elif question_type == "algebra":
		Global.balance += 10
	$UIs/MainUI/Control/RightControl/GeneralLabels/ScoreLabel.text = "Balance: " + str(Global.balance)
	$UIs/TestingUI.visible = false


func _on_purchasing_ui_buy():
	if $UIs/TestingUI.visible == false:
		$UIs/PurchasingUI.visible = !$UIs/PurchasingUI.visible
		if $UIs/PurchasingUI.visible == true:
			Global.shootable = false
		else:
			Global.shootable = true
	


func _on_purchasing_ui_buy_bullet_speed():
	if Global.balance >= bullet_speed_cost:
		Global.bullet_speed += 10
		Global.balance -= bullet_speed_cost
		$UIs/MainUI/Control/RightControl/PlayerStatsControl/BulletSpeed.text = "Bullet Speed: " + str(Global.bullet_speed)

func _on_purchasing_ui_buy_speed():
	if Global.balance >= speed_cost:
		var player_base = $Players/PlayerBase
		player_base.SPEED += 10
		Global.balance -= speed_cost
		$UIs/MainUI/Control/RightControl/PlayerStatsControl/PlayerSpeed.text = "Player Speed: " + str(player_base.SPEED)


func _on_purchasing_ui_buy_reload():
	if Global.balance >= reload_cost:
		var bullet_timer = $Players/PlayerBase/BulletTimer
		bullet_timer.wait_time *= 0.95
		Global.balance -= reload_cost
		$UIs/MainUI/Control/RightControl/PlayerStatsControl/PlayerReload.text = "Player Reload: " + str(round(bullet_timer.wait_time * 100)/100)
func _on_purchasing_ui_buy_strength():
	if Global.balance >= strength_cost:
		Global.bullet_strength += 1
		Global.balance -= strength_cost
		$UIs/MainUI/Control/RightControl/PlayerStatsControl/BulletStrength.text = "Bullet Strength: " + str(Global.bullet_strength)


		





func _on_main_ui_next_round():
	round_number += 1
	$UIs/MainUI/Control/RoundLabel.text = "ROUND " + str(round_number)
	$UIs/MainUI/Control/RoundLabel.visible = true
	if round_number >= 12:
		$Enemy1Timer.one_shot = false
		$Enemy3Timer.one_shot = false
		$Enemy1Timer.start()
		$Enemy3Timer.start()
	elif round_number >= 10:
		$Enemy1Timer.one_shot = true
		$Enemy3Timer.one_shot = true
		$Enemy4Timer.start()
	elif round_number >= 8:
		$UIs/MainUI/RoundTimer.wait_time =  40
		$Enemy1Timer.one_shot = false
		$Enemy1Timer.start()
		$Enemy3Timer.start()
	elif round_number >= 6:
		$Enemy1Timer.one_shot = true
		$Enemy3Timer.start()
	elif round_number >= 3:
		$Enemy2Timer.start()	
		




func _on_player_base_hit_player(body):
	player_health -= body.body_damage
	update_player_health()
	
func update_player_health():
	var health_bar = $UIs/MainUI/Control/HealthBar
	var bar_value = player_health/Global.player_max_health 
	health_bar.value = bar_value




func _on_purchasing_ui_set_labels():
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
	$UIs/PurchasingUI/Control/GeneralPurchase/GeneralStats/BulletSpeed.text += "\n$" + str(bullet_speed_cost)
	$UIs/PurchasingUI/Control/GeneralPurchase/GeneralStats/Speed.text += "\n$" + str(speed_cost)
	$UIs/PurchasingUI/Control/GeneralPurchase/GeneralStats/Strength.text += "\n$" + str(strength_cost)
	$UIs/PurchasingUI/Control/GeneralPurchase/GeneralStats/ReloadTime.text += "\n$" + str(reload_cost)
"""
For Enemies only:
__________________________________
"""


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
	
	
func _on_vault_vault_entered(body_damage):
	vault_health -= body_damage
	$UIs/MainUI/Control/VaultHealthBar.value = vault_health


func _on_enemy_1_timer_timeout():
	creating_enemies(enemy1_scene)
	
	
func _on_enemy_2_timer_timeout():
	creating_enemies(enemy2_scene)

func _on_enemy_3_timer_timeout():
	creating_enemies(enemy3_scene)
	
func _on_enemy_4_timer_timeout():
	creating_enemies(enemy4_scene)
	
func enemy_vault_recalibration(id):
	var instance = instance_from_id(id)
	instance.direction = ($Ground/Vault.position - instance.position).normalized()
	instance.look_at($Ground/Vault.position)


func enemy_damage_taken(enemy_body, damage):
	enemy_body.health -= damage
	var transparency = enemy_body.health * 0.8
	enemy_body.get_child(0).modulate.a = transparency
	
	if enemy_body.health <= 0:
		
		enemy_body.queue_free()


"""
For turret only:
_______________________________________________
"""
func set_turret_labels():
	if Global.player_type == "speed":
		turret_bullet_reload_cost = 22
		turret_bullet_speed_cost = 15
		turret_bullet_strength_cost = 35
	if Global.player_type == "strength":
		turret_bullet_health_cost = 15
		turret_bullet_strength_cost = 20
		turret_bullet_speed_cost = 30
		turret_bullet_reload_cost = 36
	$UIs/MainUI/Control/RightControl/ClassBased/TurretClass/ButtonsContainer/BulletHealthContainer/BullethealthBtn.text = "$" + str(turret_bullet_health_cost)
	$UIs/MainUI/Control/RightControl/ClassBased/TurretClass/ButtonsContainer/BulletSpeedContainer/BulletSpeedBtn.text = "$" + str(turret_bullet_speed_cost)
	$UIs/MainUI/Control/RightControl/ClassBased/TurretClass/ButtonsContainer/BulletStrengthContainer/BulletStrengthBtn.text = "$" + str(turret_bullet_strength_cost)
	$UIs/MainUI/Control/RightControl/ClassBased/TurretClass/ButtonsContainer/BulletReloadContainer/BulletReloadBtn.text = "$" + str(turret_bullet_reload_cost)


func create_turret():
	var turret_position = get_global_mouse_position()
	if turret_position:
		var turret = turret_scene.instantiate()
		turret.position = turret_position
		turret.id = turret.get_instance_id()
		turret.connect("turret_shoot", self.turret_shoot)
		turret.connect("turret_stats", self.turret_stats_page)
		$Turrets.add_child(turret)
		turret_mode = false
	
	
func turret_stats_page(id):
	var turret_instance = instance_from_id(id)
	var reloadLabel = $UIs/MainUI/Control/RightControl/ClassBased/TurretClass/StatsContainer/BulletReloadLabel
	reloadLabel.text = "Reload Time: " + str(turret_instance.get_node("TurretBulletTimer").wait_time) + "s"
	var strengthlabel = $UIs/MainUI/Control/RightControl/ClassBased/TurretClass/StatsContainer/BulletStrengthLabel
	strengthlabel.text = "Bullet Strength " + str(turret_instance.bullet_strength)
	var speedLabel = $UIs/MainUI/Control/RightControl/ClassBased/TurretClass/StatsContainer/BulletSpeedLabel
	speedLabel.text = "Bullet Speed: " + str(turret_instance.bullet_speed) 
	var healthLabel = $UIs/MainUI/Control/RightControl/ClassBased/TurretClass/StatsContainer/TurretHealthLabel
	healthLabel.text = "Turret Health: " + str(turret_instance.health) + "/" + str(turret_instance.max_health)  
	$UIs/MainUI/Control/RightControl/ClassBased/TurretClass.visible = true
	current_turret = turret_instance
	
	
func turret_shoot(id, dir):
	var turret_instance = instance_from_id(id)
	var bullet_instance = turret_bullet_scene.instantiate()
	bullet_instance.speed = turret_instance.bullet_speed
	bullet_instance.strength = turret_instance.bullet_strength 
	bullet_instance.position = turret_instance.get_node("TurretBulletMarker").global_position
	bullet_instance.linear_velocity = dir * bullet_instance.speed
	bullet_instance.connect("bullet_hit", self.enemy_damage_taken)
	$Projectiles.add_child(bullet_instance)
	
	
func _on_purchasing_ui_buy_turret():
	if Global.balance >= turret_cost:
		turret_mode = true
		$UIs/PurchasingUI.visible = false
		Global.balance -= turret_cost


func _on_main_ui_bullet_speed_button_pressed(): #  FOR TURRET
	if Global.balance >= turret_bullet_speed_cost:
		current_turret.bullet_speed += 50
		current_turret.get_node("TurretBulletTimer").wait_time *= 0.9
		current_turret.health = current_turret.max_health
		
		Global.balance -= turret_bullet_speed_cost
		turret_stats_page(current_turret.get_instance_id())
		
		
func _on_main_ui_health_button_pressed(): #  FOR TURRET
	if Global.balance >= turret_bullet_health_cost:
		current_turret.max_health *= 2
		current_turret.health = current_turret.max_health
		current_turret.bullet_strength += 1
		
		Global.balance -= turret_bullet_health_cost
		turret_stats_page(current_turret.get_instance_id())


func _on_main_ui_reload_button_pressed(): #  FOR TURRET
	if Global.balance >= turret_bullet_reload_cost:
		current_turret.get_node("TurretBulletTimer").wait_time *= 0.5
		current_turret.bullet_speed += 10
		current_turret.health = current_turret.max_health
		
		Global.balance -= turret_bullet_reload_cost
		turret_stats_page(current_turret.get_instance_id())


func _on_main_ui_strength_button_pressed(): #  FOR TURRET
	if Global.balance >= turret_bullet_strength_cost:
		current_turret.bullet_strength += 4
		current_turret.max_health += 4
		current_turret.health = current_turret.max_health
		
		Global.balance -= turret_bullet_strength_cost
		turret_stats_page(current_turret.get_instance_id())



