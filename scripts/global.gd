extends Node

var selecting = true
var starting_in = -1
var players = []
var scores = []
var vacated_spots = []
var instructions_tween

onready var player_scores = $'../World/CanvasLayer/PlayerScores'
onready var instructions = $'../World/CanvasLayer/Instructions'

func _ready():
	instructions_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT).set_loops()
	
	instructions_tween.tween_property(instructions, 'modulate', Color(1, 1, 1, 1), 1)
	instructions_tween.tween_property(instructions, 'modulate', Color(1, 1, 1, 0), 1)
	
	instructions_tween.connect('loop_finished', self, '_on_instructions_tween_loop_finished')
	
	update_instructions()

func _on_instructions_tween_loop_finished(_loop_count):
	match starting_in:
		2:
			instructions.bbcode_text = '[center]Ready?[/center]'
		1:
			instructions.bbcode_text = '[center]Go![/center]'
			
			# start players
		0:
			instructions.visible = false
		-1:
			return
	
	starting_in -= 1

func update_instructions():
	var instruction_lines = PoolStringArray()
	var available_join_buttons = PoolStringArray()
	
	if players.size() < 4:
		for i in 4:
			if !players.has(i):
				available_join_buttons.push_back(['W', 'G', '9', 'UP'][i])
		
		instruction_lines.push_back('Press %s or [color=#0e7a0d]A[/color] to join' % available_join_buttons.join(', '))
	
	if players.size() > 1:
		instruction_lines.push_back('Press Enter to start')
	
	instructions.bbcode_text = '[center]%s[/center]' % instruction_lines.join('\n')

func _input(event):
	if !(event is InputEventKey) or !event.pressed or event.echo:
		return
	
	if selecting:
		for i in 4:
			if event.is_action('power%d' % i):
				var index = players.find(i)
				
				if index == -1:
					if vacated_spots.empty():
						index = players.size()
					else:
						index = vacated_spots.pop_front()
						
						for j in vacated_spots.size():
							vacated_spots[j] += 1
					
					player_scores.add_player(i, index)
					
					players.insert(index, i)
					scores.push_back(0)
					
					# TODO: spawn player & potato and assign i as id
				else:
					player_scores.remove_player(index)
					
					players.remove(index)
					scores.remove(index)
					
					vacated_spots.push_back(index)
					
					# TODO: free player & potato i
				
				# TODO: update player & potato positions
				
				update_instructions()
				
				return
		
		if event.is_action('start'):
			if players.size() < 2:
				return
			
			selecting = false
			starting_in = 2
			
			player_scores.start()
		elif event.is_action('quit'):
			get_tree().quit()
	elif event.is_action('quit'):
		selecting = true
		
		# TODO: reset variables
		# TODO: reload World scene

func change_score(index, by):
	scores[index] += by
	
	player_scores.update_score(index, scores[index])
