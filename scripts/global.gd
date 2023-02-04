extends Node

var selecting = true
var players = []
var scores = []

onready var player_scores = $'../World/CanvasLayer/PlayerScores'

func _input(event):
	if !(event is InputEventKey) or !event.pressed or event.echo:
		return
	
	if selecting:
		for i in 4:
			if event.is_action('power%d' % i):
				var index = players.find(i)
				
				if index == -1:
					player_scores.add_player(i, players.size())
					
					players.push_back(i)
					scores.push_back(i)
					
					# TODO: spawn player & potato and assign i as id
				else:
					player_scores.remove_player(index)
					
					players.remove(index)
					scores.remove(index)
					
					# TODO: free player & potato i
				
				# TODO: update player & potato positions
				
				return
		
		if event.is_action('start'):
			selecting = false
			
			# change UI visibility, start players and start music (disable low-pass filter?)
		elif event.is_action('quit'):
			get_tree().quit()
	elif event.is_action('quit'):
		selecting = true
		
		# TODO: reload World scene

func change_score(index, by):
	scores[index] += by
	
	player_scores.update_score(index, scores[index])
