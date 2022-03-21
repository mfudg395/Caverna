# Virtual base class that all states will inherit.
class_name State
extends Node

# Reference to the state machine that states will use. That is, every state
# you create will require a state machine to be passed in.
var state_machine = null

func enter() -> void:
	pass

func exit() -> void:
	pass

func handle_input() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
