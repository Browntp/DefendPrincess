extends BaseEnemy
var base_direction 

var sway_amplitude = 1  # Adjust this value to control the amount of sway
var sway_frequency = 2  # Adjust this value to control the speed of sway
var sway_offset = 0



func _ready():
	
	base_direction = direction
	health = 6
	speed = 100
	body_damage = 10




func _on_timer_timeout():
	sway_offset += 1
	var sway = Vector2(-direction.y, direction.x)  # This is a vector perpendicular to the direction vector
	sway *= sway_amplitude * sin(sway_frequency*sway_offset)
	direction = (direction + sway).normalized()
	



