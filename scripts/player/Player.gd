extends CharacterBody2D

var wheel_base := 14 # Distance from front to rear wheel
var steering_angle := 19.0  # Amount that front wheel turns, in degrees
var acceleration_speed := 80.0
var acceleration := Vector2.ZERO
var friction := -30.0
var drag := -0.05
var break_speed := -20.0
var max_reverse_speed := 50.0

var movement_speed := 100.0
var accel := 8.0 
var decel := 10.0 

var slip_speed := 45
var traction_fast := 6.0
var traction_slow := 15.0

var steer_direction : float

# Credits for the steering goes to KidsCanCode https://kidscancode.org/godot_recipes/4.x/2d/car_steering/

@onready var arrow = $CanvasLayer/ArrowAnchor/Arrow
@onready var arrow_anchor = $CanvasLayer/ArrowAnchor

@onready var objective_label = $CanvasLayer/ObjectiveLabel
@onready var obj_rem_label = $CanvasLayer/Objectives_Remaining_Label
@onready var road_name_label = $CanvasLayer/Road_Name_Label
@onready var smoke_particles = $Particles/Smoke_Particles

@onready var anim = $AnimationPlayer
@onready var crash_sound = $Audio/CrashSound


var crash_sounds := {
	1: preload("res://assets/audio/crash_01.wav"),
	2: preload("res://assets/audio/crash_02.wav"),
	3: preload("res://assets/audio/crash_03.wav"),
	4: preload("res://assets/audio/crash_04.wav"),
	5: preload("res://assets/audio/crash_05.wav")
}

func _ready() -> void:
	GameManager.arrow = arrow
	GameManager.objective_label = objective_label
	GameManager.objectves_remaining_label = obj_rem_label
	GameManager.set_ui_road_name.connect(_on_set_ui_road_name)
	GameManager.player = self

func _physics_process(delta) -> void:
	GameManager.player_pos = global_position
	acceleration = Vector2.ZERO
	movement(delta)
	rotate_player()
	velocity += acceleration * delta
	
	if velocity == Vector2.ZERO:
		smoke_particles.emitting = false
	else:
		smoke_particles.emitting = true
	
	
	arrow_anchor.rotation = GameManager.player_pos.angle_to_point(GameManager.arrow_target)
	
	move_and_slide()


func movement(delta) -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity.x = lerp(velocity.x, input_direction.x*movement_speed, accel*delta) if input_direction.x != 0 else lerp(velocity.x, 0.0, decel*delta)
	velocity.y = lerp(velocity.y, input_direction.y*movement_speed, accel*delta) if input_direction.y != 0 else lerp(velocity.y, 0.0, decel*delta)
	
	if input_direction == Vector2.ZERO:
		anim.play("idle")
	else:
		anim.play("driving")

func get_input() -> void:
	var turn = Input.get_axis("steer_left", "steer_right")
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * acceleration_speed
	if Input.is_action_pressed("reverse"):
		acceleration = transform.x * -acceleration_speed
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * break_speed

func rotate_player() -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Choose which direction the player should face
	
	if input_direction.x < 0 and input_direction.y == 0: 
		rotation = lerp_angle(rotation, deg_to_rad(180), 0.3)
	elif input_direction.x > 0 and input_direction.y == 0: 
		rotation = lerp_angle(rotation, deg_to_rad(0), 0.3)
	elif input_direction.y > 0:
		rotation = lerp_angle(rotation, deg_to_rad(90), 0.3)
	elif input_direction.y < 0:
		rotation = lerp_angle(rotation, deg_to_rad(270), 0.3)

func _on_crash_area_body_entered(body) -> void:
	if !body.is_in_group("player"):
		crash_sound.stream = crash_sounds[randi_range(1,5)]
		crash_sound.play()

func _on_set_ui_road_name(road_name : String) -> void:
	road_name_label.text = road_name
