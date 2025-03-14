class_name BoidController
extends Node

const BOID_SCENE: PackedScene = preload("res://boids/godot_node_based_boid/godot_node_based_boid.tscn")

@export_range(0, 200) var num_boids: int = 100;
@export_range(0, 20.0) var boid_speed: float = 10.0;
@export_range(0, 3.8) var separation: float = 1.9;
@export_range(0, 0.326) var alignment: float = 0.163;
@export_range(0, 0.000624, 0.0000001) var cohesion: float = 0.000312;
@export_range(0, 100) var sight_radius: float = 20;
@export_range(0, PI) var sight_fov: float = PI;
@export var turn_speed: float = 0.1;  # rads per tick
var screen_dimensions: Vector2i;

var boids = [];
func _ready():
	screen_dimensions = DisplayServer.window_get_size(0)
	print(screen_dimensions)
	#Spawn boids
	for i in range(num_boids):
		var boid: Sprite2D = BOID_SCENE.instantiate()
		boid.position = Vector2(randf_range(0, screen_dimensions.x), randf_range(0, screen_dimensions.y))
		boid.apply_scale(Vector2(0.2, 0.2))
		boid.rotate(randf_range(0.0, 2.0*PI))
		boids.append(boid)
		add_child(boid)

func _process(_delta: float) -> void:
	screen_dimensions = DisplayServer.window_get_size(0);

#func _physics_process(delta):
	#pass
