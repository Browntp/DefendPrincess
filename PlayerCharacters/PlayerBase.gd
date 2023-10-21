extends CharacterBody2D
signal shootBaseBullet(dir, StartingPos)
signal hit_player(body)
var bullet_reloaded = true
var SPEED = 100


func _physics_process(delta):
	
	look_at(get_global_mouse_position())
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("left", "right", "up", "down")
	var bullet_direction = (get_global_mouse_position() - position).normalized()
	if Input.is_action_just_pressed("shoot") and bullet_reloaded:
		shootBaseBullet.emit(bullet_direction, $BulletFireLocation.global_position)
		bullet_reloaded = false
		$BulletTimer.start()
	velocity = direction * SPEED * delta
	
	var collision = move_and_collide(velocity)
	if collision:
		var body = collision.get_collider()
		_on_area_2d_body_entered(body)



func _on_bullet_timer_timeout():
	bullet_reloaded = true


func _on_area_2d_body_entered(body):
	if body is BaseEnemy:
		hit_player.emit(body)
