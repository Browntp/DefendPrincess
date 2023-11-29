extends CharacterBody2D
signal shootBaseBullet(dir, StartingPos)
signal hit_player(body)
signal go_to_vault(id)


var bullet_reloaded = true
var SPEED = 100


func _physics_process(delta):
	
	look_at(get_global_mouse_position())
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("left", "right", "up", "down")
	var bullet_direction = (get_global_mouse_position() - position).normalized()
	if Input.is_action_just_pressed("shoot") and bullet_reloaded and Global.shootable:
		shootBaseBullet.emit(bullet_direction, $BulletFireLocation.global_position)
		bullet_reloaded = false
		$BulletTimer.start()
	if Input.is_action_just_released("exit"):
		get_tree().quit()
	velocity = direction * SPEED * delta
	
	var collision = move_and_collide(velocity)
	if collision:
		var body = collision.get_collider()
		on_body_collision(body)



func _on_bullet_timer_timeout():
	bullet_reloaded = true


func on_body_collision(body):
	if body is BaseEnemy:
		hit_player.emit(body.body_damage)





func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy") and not body.is_in_group("enemy4") :
		body.direction = (position - body.position).normalized()
		body.look_at(global_position)
		
func _on_area_2d_body_exited(body) :
	if body.is_in_group("enemy") and not body.is_in_group("enemy4"):
		go_to_vault.emit(body.id)
