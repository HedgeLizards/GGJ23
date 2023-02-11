extends Node

func get_control(id):
	return PlayerInput.new(id)

class PlayerInput:

	var id

	func _init(id):
		self.id = id

	func is_action_pressed(action):
		if id < 5:
			return Input.is_action_pressed(action + str(id))
		else:
			return GamepadInput.state[id][action].pressed

	func is_action_just_pressed(action):
		if id < 5:
			return Input.is_action_just_pressed(action + str(id))
		else:
			return GamepadInput.state[id][action].pressed and GamepadInput.state[id][action].just > 0

	func is_action_just_released(action):
		if id < 5:
			return Input.is_action_just_released(action + str(id))
		else:
			return !GamepadInput.state[id][action].pressed and GamepadInput.state[id][action].just > 0

	func move_direction():
		return int(is_action_pressed("right")) - int(is_action_pressed("left"))
