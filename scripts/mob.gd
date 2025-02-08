extends RigidBody2D

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	_play_random_animation()


func _play_random_animation() -> void:
	var animation_name := _choose_random_animation()
	_animated_sprite.play(animation_name)


func _choose_random_animation() -> String:
	var animation_names := _get_animation_names()
	var random_index := randi() % animation_names.size()
	return animation_names[random_index]


func _get_animation_names() -> PackedStringArray:
	return _animated_sprite.sprite_frames.get_animation_names()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
