class_name Hud
extends CanvasLayer

signal start_game

@onready var _message: Label = $Message
@onready var _message_timer: Timer = $MessageTimer
@onready var _start_button: Button = $StartButton
@onready var _score_label: Label = $ScoreLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_configure_signals()


func _configure_signals() -> void:
	_start_button.pressed.connect(_on_start_button_pressed)
	_message_timer.timeout.connect(_on_message_timer_timeout)


func _on_start_button_pressed() -> void:
	_start_button.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	_message.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func show_message(text: String) -> void:
	_message.text = text
	_message.show()
	_message_timer.start()


func show_game_over() -> void:
	show_message("Game Over")

	await _message_timer.timeout
	_message.text = "Dodge the Creeps!"
	_message.show()

	await get_tree().create_timer(1.0).timeout
	_start_button.show()


func update_score(score: int) -> void:
	_score_label.text = str(score)
