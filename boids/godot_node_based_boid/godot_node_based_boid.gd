extends Sprite2D


@onready var controller: BoidController = get_parent();

func wall_force(relative_distance: float) -> float:
	#return 2.0*(controller.separation + controller.alignment + controller.cohesion + 1.0001)*pow(relative_distance, 2) + 2.0
	return 2.0*pow(relative_distance, 2) + 2.0

var wall_buffer: float = 25.0;

# single boids travel through the wall for some reason, so decreasing the sight radius makes a lot get lost
func _physics_process(_delta: float):
	var net_force: Vector2 = Vector2.ZERO;
	
	# Avoid walls (if near wall, steer away from wall, steer towards wall's normal)
	# Wall at x = 0
	if position.x < wall_buffer:
		var relative_distance = position.x - wall_buffer
		net_force += Vector2(wall_force(relative_distance), 0)
	# Wall at y = 0
	if position.y < wall_buffer:
		var relative_distance = position.y - wall_buffer
		net_force += Vector2(0, wall_force(relative_distance))
	# Wall at x = screewidth
	if position.x > controller.screen_dimensions.x - wall_buffer:
		var relative_distance = position.x - controller.screen_dimensions.x - wall_buffer
		net_force += Vector2(-wall_force(relative_distance), 0)
	# Wall at y = screeheight
	if position.y > controller.screen_dimensions.y - wall_buffer:
		var relative_distance = position.y - controller.screen_dimensions.y - wall_buffer
		net_force += Vector2(0, -wall_force(relative_distance))
	
	
	var num_nearby_boids: int = 0;
	# Separation - force points away from nearby boids
	var separation: Vector2 = Vector2.ZERO;
	# Alignment - face the same direction as nearby boids
	var alignment: Vector2 = Vector2.ZERO;
	# Cohesion - move towards center of nearby boids
	var cohesion: Vector2 = Vector2.ZERO;
	
	for boid: Node2D in controller.boids:
		if boid != self:
			var relative_position = boid.position - position
			if relative_position.length() < controller.sight_radius:
				num_nearby_boids += 1;
				#if relative_position.length() < controller.sight_radius / 10.0:
				separation += relative_position.normalized() / pow(relative_position.length(),2) # May need to weight closer ones stronger
				alignment += -boid.transform.y # Average forward vector
				cohesion += relative_position # To calculate average relative position
		
	# average direction * aligmnent coefficient
	if num_nearby_boids != 0:
		separation = -separation * controller.separation / num_nearby_boids
		alignment = alignment * controller.alignment / num_nearby_boids
		cohesion = cohesion * controller.cohesion / num_nearby_boids
		net_force += separation + alignment + cohesion
	
	
	# Rotate towards net force
	# Needs to rotate proportially with force (have anglular interia to resist small forces)
	# Force direction is the direction to turn (but i don't want to over turn)
	if net_force.length() > 0.0000001 :
		var angle_between: float = net_force.angle_to(-transform.y)
		#var torque = net_force.length()
		var to_rotate = clamp(angle_between, -controller.turn_speed, controller.turn_speed)
		rotate(-to_rotate)
	position += controller.boid_speed * -transform.y
	pass
