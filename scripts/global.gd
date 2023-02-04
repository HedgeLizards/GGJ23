extends Node

const Player = preload('res://scenes/Player.tscn')

var selecting = true
var starting_in = -1
var players = []
var scores = []
var vacant_indices = [0, 1, 2, 3]
var player_scores
var instructions
var instructions_tween

func initialize_UI():
	player_scores = $'../World/CanvasLayer/PlayerScores'
	instructions = $'../World/CanvasLayer/Instructions'
	
	instructions_tween = instructions.create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT).set_loops()
	
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
			
			start_players()
		0:
			instructions.visible = false
		-1:
			return
	
	starting_in -= 1

func start_players():
	var all_players = get_node("/root/World/Players").get_children()
	for player in all_players:
		player.start_growing()

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
					index = vacant_indices.min()
					
					vacant_indices.erase(index)
					
					player_scores.add_player(i, index)
					
					players.insert(index, i)
					scores.push_back(0)
					
					var potato = Sprite.new()
					var player = Player.instance()
					
					potato.texture = load('res://assets/player/PotP%d.png' % index)
					potato.position.y = 512
					potato.scale.x = 0.5
					potato.scale.y = 0.5
					
					player.position.y = potato.position.y
					player.set_id_index(i, index)
					
					$'../World/Potatoes'.add_child(potato)
					$'../World/Players'.add_child(player)
				else:
					player_scores.remove_player(index)
					
					players.remove(index)
					scores.remove(index)
					
					$'../World/Potatoes'.get_child(index).free()
					$'../World/Players'.get_child(index).free()
					
					while vacant_indices.has(index):
						index += 1
					
					vacant_indices.push_back(index)
				
				for j in players.size():
					var potato = $'../World/Potatoes'.get_child(j)
					var player = $'../World/Players'.get_child(j)
					
					potato.position.x = 2048 / players.size() * (j + 0.5)
					player.position.x = potato.position.x
				
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
		starting_in = -1
		
		for i in scores.size():
			scores[i] = 0
		
		player_scores.stop()
		
		get_tree().reload_current_scene()

func change_score(index, by):
	scores[index] += by
	
	player_scores.update_score(index, scores[index])
