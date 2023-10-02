extends CharacterBody2D

var wheel_base := 14 # Distance from front to rear wheel
var steering_angle := 19.0  # Amount that front wheel turns, in degrees
var acceleration_speed := 80.0
var acceleration := Vector2.ZERO
var friction := -30.0
var drag := -0.05
var break_speed := -20.0
var max_reverse_speed := 50.0

var slip_speed := 45
var traction_fast := 6.0
var traction_slow := 15.0

var steer_direction : float

@onready var motor_loop = preload("res://assets/Vehicle_Van_Idle_Exterior_Rear_Loop_01.wav").duplicate()
@onready var car_driving_sound = preload("res://assets/audio/Vehicle_Van_Drive_Exterior_Loop_01.wav").duplicate()

# Credits for the steering goes to KidsCanCode https://kidscancode.org/godot_recipes/4.x/2d/car_steering/

func _ready():
	GameManager.arrow = $CanvasLayer/Node2D/Arrow

func _physics_process(delta):
	GameManager.player_pos = position
	acceleration = Vector2.ZERO
	get_input()
	apply_friction(delta)
	calculate_steering(delta)
	velocity += acceleration * delta
	
	if velocity == Vector2.ZERO:
		$Particles/Smoke_Particles.emitting = false
	else:
		$Particles/Smoke_Particles.emitting = true
	
	
	$CanvasLayer/Node2D.rotation = GameManager.player_pos.angle_to_point(GameManager.arrow_target)
	
	move_and_slide()

func get_input():
	var turn = Input.get_axis("steer_left", "steer_right")
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * acceleration_speed
	if Input.is_action_pressed("reverse"):
		acceleration = transform.x * -acceleration_speed
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * break_speed

func calculate_steering(delta):  
	# 1. Find the wheel positions
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	# 2. Move the wheels forward
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	# 3. Find the new direction vector
	var new_heading = rear_wheel.direction_to(front_wheel)
	var traction = traction_fast if velocity.length() > slip_speed else traction_slow
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_reverse_speed)
	rotation = new_heading.angle()

func apply_friction(delta): 
	if acceleration == Vector2.ZERO and velocity.length() < 15:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force



func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.play()
