extends Node

const BASE_ROTATION_OFFSET = PI / 2
const RANDOM_ROTATION_RANGE = PI / 4
const MOB_SPEED_MIN = 150
const MOB_SPEED_MAX = 250

@export var mob_scene: PackedScene

var _score := 0

@onready var _player: Player = $Player
@onready var _score_timer: Timer = $ScoreTimer
@onready var _mob_timer: Timer = $MobTimer
@onready var _start_timer: Timer = $StartTimer
@onready var _start_position: Marker2D = $StartPosition
@onready var _mob_spawn_location: PathFollow2D = $MobPath/MobSpawnLocation


func _ready() -> void:
	_configure_timers()
	_start_new_game()


func _configure_timers() -> void:
	_mob_timer.timeout.connect(_on_mob_timer_timeout)
	_score_timer.timeout.connect(_on_score_timer_timeout)
	_start_timer.timeout.connect(_on_start_timer_timeout)


func _start_new_game() -> void:
	_score = 0
	_player.start(_start_position.position)
	_start_timer.start()


func _process(_delta: float) -> void:
	pass


func _on_player_hit() -> void:
	_end_game()


func _end_game() -> void:
	_score_timer.stop()
	_mob_timer.stop()


func _on_score_timer_timeout() -> void:
	_score += 1


func _on_start_timer_timeout() -> void:
	_mob_timer.start()
	_score_timer.start()


func _on_mob_timer_timeout() -> void:
	_spawn_mob()


func _spawn_mob() -> void:
	if mob_scene == null:
		print("mob_scene is null")
		return

	var mob: RigidBody2D = mob_scene.instantiate()
	_configure_mob(mob)
	add_child(mob)


func _configure_mob(mob: RigidBody2D) -> void:
	mob.position = _get_random_spawn_position()
	mob.rotation = _get_random_spawn_rotation()
	mob.linear_velocity = _get_random_mob_velocity(mob.rotation)


func _get_random_spawn_position() -> Vector2:
	_mob_spawn_location.progress_ratio = randf()
	return _mob_spawn_location.position


func _get_random_spawn_rotation() -> float:
	var base_direction := _mob_spawn_location.rotation + BASE_ROTATION_OFFSET
	var random_offset := randf_range(-RANDOM_ROTATION_RANGE, RANDOM_ROTATION_RANGE)
	return base_direction + random_offset


func _get_random_mob_velocity(mob_rotation: float) -> Vector2:
	var speed := randf_range(MOB_SPEED_MIN, MOB_SPEED_MAX)
	var velocity := Vector2(speed, 0.0)
	return velocity.rotated(mob_rotation)
