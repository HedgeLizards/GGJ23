extends HBoxContainer

const COLORS = [
	Color(0.8, 0.2, 0.2),
	Color(0.2, 0.2, 0.8),
	Color(0.2, 0.8, 0.2),
	Color(0.8, 0.8, 0.2),
]

var scores = [0, 0, 0, 0]
var PlayerScore = preload('res://scenes/PlayerScore.tscn')

func _ready():
	for i in range(4):
		var player_score = PlayerScore.instance()
		var score = player_score.get_node('Score')
		var player = player_score.get_node('Player')
		
		score.add_font_override('font', score.get_font('font').duplicate())
		score.add_color_override('font_color', COLORS[i])
		
		player.add_color_override('font_color', COLORS[i])
		player.text += str(i + 1)
		
		add_child(player_score)
	
	increase_score(2, 3)

func increase_score(player, by):
	scores[player] += by
	
	var score = get_child(player).get_node('Score')
	
	score.text = str(scores[player])
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(score.get_font('font'), 'size', 96, 0.5)
	tween.tween_property(score.get_font('font'), 'size', 64, 0.5)
