extends CharacterBody2D

var input_vector: Vector2 = Vector2.ZERO
var ang_velocity: float = 0.0
@export var speed: float = 1.0
@export var drag: float = 1.0 # 
@export var mass: float = 1.0 #
@export var wing: float = 1.0 # how much velocity is kept doing the turn

func _process(delta: float) -> void:
	%Exhaust.visible = input_vector.y < 0
	%CPUParticles2D.emitting = input_vector.y < 0

func _input(event: InputEvent) -> void:
	input_vector = Input.get_vector("left", "right", "forward", "back")

func apply_thrust(delta: float) -> void:
	velocity += (Vector2.DOWN * input_vector.y * speed * 100 * delta).rotated(rotation) / mass
	ang_velocity += input_vector.x * delta * 0.2
	

func apply_drag(delta: float) -> void:
	ang_velocity -= ang_velocity * 2 * delta

	var forward: Vector2 = Vector2.UP.rotated(rotation)
	var resistance: float = velocity.normalized().dot(forward) # -1 = back / 0 = 90deg / 1 = forward
	var drag_force: Vector2 = velocity * -drag
	if (resistance < 0): #moving backwards
		drag_force *= abs(resistance) + 1
	else:
		drag_force *= (1 - resistance)
	
	velocity += drag_force / mass * delta

func apply_wing(delta: float) -> void:
	var forward: Vector2 = Vector2.UP.rotated(rotation)
	var new_vel: Vector2 = velocity.rotated((velocity.angle_to(forward)))
	var efficiency: float = wing / mass
	var resistance: float = velocity.normalized().dot(forward) # -1 = back / 0 = 90deg / 1 = forward
	if (resistance > 0):
		efficiency += resistance

	velocity = lerp(velocity, new_vel, efficiency * delta)

	pass

func _physics_process(delta: float) -> void:
	apply_thrust(delta)
	apply_drag(delta)
	apply_wing(delta)

	rotation += ang_velocity
	move_and_slide()
