extends Node

const levels = [
	preload('res://scenes/levels/Level_01.tscn'),
	preload('res://scenes/levels/Level_02.tscn'),
	preload('res://scenes/levels/Level_03.tscn'),
	preload('res://scenes/levels/Level_04.tscn'),
	preload('res://scenes/levels/Level_05.tscn'),
	preload('res://scenes/levels/Level_06.tscn'),
	preload('res://scenes/levels/Level_Bonus.tscn'),
]
const Level_End = preload('res://scenes/levels/Level_End.tscn')
const Player = preload('res://scenes/Player.tscn')

var selecting = true
var starting_in = -1
var players = []
var scores = []
var vacant_indices = [0, 1, 2, 3]
var players_dead = 0
var players_finished = 0
var player_scores
var instructions
var instructions_tween

func _ready():
	randomize()

func initialize_world():
	players_dead = 0
	players_finished = 0
	
	player_scores = $'../World/CanvasLayer/PlayerScores'
	instructions = $'../World/CanvasLayer/Instructions'
	
	instructions_tween = instructions.create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT).set_loops()
	
	instructions_tween.tween_property(instructions, 'modulate', Color(1, 1, 1, 1), 0.7166)
	instructions_tween.tween_property(instructions, 'modulate', Color(1, 1, 1, 0), 0.7166)
	
	instructions_tween.connect('loop_finished', self, '_on_instructions_tween_loop_finished')
	
	if starting_in == -1:
		update_instructions()
	else:
		_on_instructions_tween_loop_finished(-1)
		
		player_scores.start()
	
	for i in 5:
		var level = (levels[randi() % levels.size()] if i < 4 else Level_End).instance()
		
		level.position.y = -256 - 1024 * (i + 1)
		
		$'../World/Levels'.add_child(level)
	
	for i in players.size():
		add_potato_and_player(i, players[i])
		align_potato_and_player(i)

func _on_instructions_tween_loop_finished(_loop_count):
	match starting_in:
		2:
			instructions.bbcode_text = '[center]Ready?[/center]'
			
			$'../World/MUS_Intro_Rise'.play();
			$'../World/SND_Ready'.play();
		1:
			instructions.bbcode_text = '[center]Go![/center]'
			
			for player in $'../World/Players'.get_children():
				player.start_growing()
			
			if $'../World/MUS_Intro'.is_playing():
				$'../World/MUS_Intro'.stop();
				
			if $'../World/MUS_Intro_Rise'.is_playing():
				$'../World/MUS_Intro_Rise'.stop();
				
			$'../World/MUS_Main'.play();
			$'../World/SND_Begin'.play();
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

func add_potato_and_player(index, id):
	var potato = Sprite.new()
	var player = Player.instance()
	
	potato.texture = load('res://assets/player/PotP%d.png' % index)
	potato.position.y = 250
	
	player.position.y = potato.position.y
	player.set_id_index(id, index)
	
	$'../World/Potatoes'.add_child(potato)
	$'../World/Potatoes'.move_child(potato, index)
	
	$'../World/Players'.add_child(player)
	$'../World/Players'.move_child(player, index)

func align_potato_and_player(index):
	var potato = $'../World/Potatoes'.get_child(index)
	var player = $'../World/Players'.get_child(index)
	
	potato.position.x = 2048 / players.size() * (index + 0.5)
	player.position.x = potato.position.x

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
					
					players.insert(index, i)
					scores.push_back(0)
					
					player_scores.add_player(i, index)
					$'../World/SND_PlayerJoin'.get_children()[index].play();
					
					add_potato_and_player(index, i)
				else:
					players.remove(index)
					scores.remove(index)
					
					player_scores.remove_player(index)
					
					$'../World/Potatoes'.get_child(index).free()
					$'../World/Players'.get_child(index).free()
					
					while vacant_indices.has(index):
						index += 1
					
					vacant_indices.push_back(index)
				
				for j in players.size():
					align_potato_and_player(j)
				
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
		
		get_tree().reload_current_scene()

func add_player_dead(index):
	player_scores.update_status(index, 'Dead')
	
	players_dead += 1
	
	restart_if_all_done(2)

func add_player_finished(index):
	change_score(index, players.size() - players_finished)
	
	player_scores.update_status(index, 'Finished')
	
	players_finished += 1
	
	change_music();
	
	restart_if_all_done(4)

func change_score(index, by):
	scores[index] += by
	
	player_scores.update_score(index, scores[index])

func restart_if_all_done(time_sec):
	if players_dead + players_finished < players.size():
		return
		
	yield(get_tree().create_timer(time_sec), 'timeout')
	
	starting_in = 2
	
	get_tree().reload_current_scene()

func change_music():
	$'../World/MUS_Main'.stop();
	$'../World/MUS_Outro'.play();
