extends Node

func get_control(id):
	return PlayerInput.new(id)

class PlayerInput:

	var id

	func _init(id):
		self.id = id

	func _is_action_pressed(action):
		if id < 5:
			return Input.is_action_pressed(action + str(id))
		else:
			return GamepadInput.state[id][action].pressed

	func _is_action_just_pressed(action):
		if id < 5:
			return Input.is_action_just_pressed(action + str(id))
		else:
			return GamepadInput.state[id][action].pressed and GamepadInput.state[id][action].just > 0

	func _is_action_just_released(action):
		if id < 5:
			return Input.is_action_just_released(action + str(id))
		else:
			return !GamepadInput.state[id][action].pressed and GamepadInput.state[id][action].just > 0

	func move_direction():
		return int(_is_action_pressed("right")) - int(_is_action_pressed("left"))

	func any_key_just_pressed():
		return _is_action_just_pressed("right") or _is_action_just_pressed("left") or _is_action_just_pressed("power")

	func is_power_just_released():
		return _is_action_just_released("power")

	func is_power_just_pressed():
		return _is_action_just_pressed("power")
