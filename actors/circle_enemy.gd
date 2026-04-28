extends CharacterBody2D

@export var speed: float = 50.0

func _physics_process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider != null and collider.is_in_group("player"):
			MainEventBus.enemy_hit_player.emit()
