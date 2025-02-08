class_name Player
extends Area2D

signal hit

const ANIMATION_STATE := {
	WALK = "walk",
	UP = "up",
}

@export var speed := 400

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _collision: CollisionShape2D = $CollisionShape2D
@onready var _screen_size := get_viewport_rect().size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input := _get_input()
	var velocity := _calculate_velocity(input)
	_update_movement(velocity, delta)
	_update_animation(velocity)


func _get_input() -> Vector2:
	return Vector2(
		Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")
	)


func _calculate_velocity(input: Vector2) -> Vector2:
	return input.normalized() * speed if input.length() > 0 else Vector2.ZERO


func _update_movement(velocity: Vector2, delta: float) -> void:
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, _screen_size)


func _update_animation(velocity: Vector2) -> void:
	if velocity.is_zero_approx():
		_animated_sprite.stop()
		return

	_animated_sprite.play()

	var animation_state: String
	var flip_v := false
	var flip_h := false

	if velocity.x != 0:
		animation_state = ANIMATION_STATE.WALK
		flip_h = velocity.x < 0
	elif velocity.y != 0:
		animation_state = ANIMATION_STATE.UP
		flip_v = velocity.y > 0

	_set_animation(animation_state, flip_v, flip_h)


func _set_animation(animation: String, flip_v: bool, flip_h: bool) -> void:
	_animated_sprite.animation = animation
	_animated_sprite.flip_v = flip_v
	_animated_sprite.flip_h = flip_h


func _on_body_entered(_body: Node2D) -> void:
	hide()
	hit.emit()
	_collision.set_deferred("disabled", true)


func start(pos: Vector2) -> void:
	position = pos
	show()
	_collision.disabled = false


func _on_hit() -> void:
	pass  # Replace with function body.
