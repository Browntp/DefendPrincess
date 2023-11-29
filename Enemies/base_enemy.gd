extends CharacterBody2D
class_name BaseEnemy
var speed = 50
var direction = Vector2()
var id
var health = 2
var body_damage = 3

signal go_to_vault(id)



func _physics_process(delta):
	velocity = direction * speed * delta
	move_and_collide(velocity)
	
