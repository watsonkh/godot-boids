class_name BoidSettings

@export_range(0, 200) var num_boids: int = 100;
@export_range(0, 20.0) var boid_speed: float = 10.0;
@export_range(0, 3.8) var separation: float = 1.9;
@export_range(0, 0.326) var alignment: float = 0.163;
@export_range(0, 0.000624, 0.0000001) var cohesion: float = 0.000312;
@export_range(0, 100) var sight_radius: float = 20;
@export_range(0, PI) var sight_fov: float = PI;
@export var turn_speed: float = 0.1;  # rads per tick
var screen_dimensions: Vector2i;
