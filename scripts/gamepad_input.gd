extends Node

var state = {
	5: {
		'left': { 'pressed': false, 'just': 0 },
		'right': { 'pressed': false, 'just': 0 },
		'power': { 'pressed': false, 'just': 0 },
	},
	6: {
		'left': { 'pressed': false, 'just': 0 },
		'right': { 'pressed': false, 'just': 0 },
		'power': { 'pressed': false, 'just': 0 },
	},
	7: {
		'left': { 'pressed': false, 'just': 0 },
		'right': { 'pressed': false, 'just': 0 },
		'power': { 'pressed': false, 'just': 0 },
	},
	8: {
		'left': { 'pressed': false, 'just': 0 },
		'right': { 'pressed': false, 'just': 0 },
		'power': { 'pressed': false, 'just': 0 },
	},
}

func _input(event):
	if event is InputEventJoypadMotion and event.axis == JOY_AXIS_0:
		var action = state[5 + event.device]
		
		if event.axis_value <= -0.5:
			if !action.left.pressed:
				action.left.pressed = true
				action.left.just = 2
		elif action.left.pressed:
			action.left.pressed = false
			action.left.just = 2
		
		if event.axis_value >= 0.5:
			if !action.right.pressed:
				action.right.pressed = true
				action.right.just = 2
		elif action.right.pressed:
			action.right.pressed = false
			action.right.just = 2
	elif event is InputEventJoypadButton and event.button_index == JOY_XBOX_A:
		var action = state[5 + event.device]
		
		action.power.pressed = event.pressed
		action.power.just = 2

func _physics_process(_delta):
	for i in range(5, 9):
		for j in ['left', 'right', 'power']:
			if state[i][j].just > 0:
				state[i][j].just -= 1
