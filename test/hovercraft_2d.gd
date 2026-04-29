extends RigidBody2D

var input_vector: Vector2 = Vector2.ZERO
var ang_velocity: float = 0.0

@export var drag: float = 1.0 # const?
@export var forward_resistance: float = 0
@export var backwards_resistance: float = 0.5
@export var side_resistance: float = 1

@export var speed: float = 1.0
# @export var mass: float = 1.0 #
@export var wing: float = 1.0 # how much linear_velocity is kept doing the turn
@export var _airbrake_effectiveness: float = 0

func _process(delta: float) -> void:
	%Exhaust.visible = input_vector.y < 0
	%CPUParticles2D.emitting = input_vector.y < 0

func _input(event: InputEvent) -> void:
	input_vector = Input.get_vector("left", "right", "forward", "back")

func apply_thrust(delta: float) -> void:
	var thrust: float = min(input_vector.y, 0.0)
	linear_velocity += (Vector2.DOWN * thrust * speed * 100 * delta).rotated(rotation) / mass
	ang_velocity += input_vector.x * delta * 0.2
	

func apply_drag(delta: float) -> void:
	ang_velocity -= ang_velocity * 2 * delta

	var drag_force: Vector2 = linear_velocity * -drag
	var forward: Vector2 = Vector2.UP.rotated(rotation)
	var dir: float = linear_velocity.normalized().dot(forward) # -1 = back / 0 = 90deg / 1 = forward

	if (dir > 0): # moving forward
		drag_force *= lerp(side_resistance, forward_resistance, dir)
	else: #moving backwards
		drag_force *= lerp(side_resistance, backwards_resistance, abs(dir))
	
	linear_velocity += drag_force / mass * delta

func apply_wing(delta: float) -> void:
	var travel_speed: float = linear_velocity.length()
	var travel_dir: Vector2 = linear_velocity.normalized()
	var forward_dir: Vector2 = Vector2.UP.rotated(rotation)

	var efficiency: float = wing / mass
	var dir: float = travel_dir.dot(forward_dir) # -1 = back / 0 = 90deg / 1 = forward
	if (dir > 0):
		efficiency *= dir
	else:
		efficiency *= dir * 0.3

	linear_velocity = (Vector2.RIGHT * travel_speed).rotated(lerp_angle(travel_dir.angle(), forward_dir.angle(), efficiency * delta))


func _physics_process(delta: float) -> void:
	apply_thrust(delta)
	apply_drag(delta)
	apply_wing(delta)

	rotation += ang_velocity