extends HBoxContainer

const COLORS = [Color('#7cb8e6'), Color('#8dcb4d'), Color('#f0028c'), Color('#df952c')]

var scores = [0, 0, 0, 0]
var nitrogens = [0, 0, 0, 0]
var PlayerScore = preload('res://scenes/PlayerScore.tscn')

func _ready():
	for i in range(4):
		var player_score = PlayerScore.instance()
		var score = player_score.get_node('Score')
		
		score.add_color_override('font_color', COLORS[i])
		score.add_font_override('font', score.get_font('font').duplicate())
		
		var nitrogen = player_score.get_node('Nitrogen')
		var foreground = nitrogen.get('custom_styles/fg').duplicate()
		
		foreground.texture = foreground.texture.duplicate()
		foreground.texture.gradient = foreground.texture.gradient.duplicate()
		
		var foreground_colors = foreground.texture.gradient.colors
		
		foreground_colors[0] = COLORS[i]
		foreground.texture.gradient.colors = foreground_colors
		
		var background = nitrogen.get('custom_styles/bg').duplicate()
		
		background.shadow_color = COLORS[i]
		background.shadow_color.a = 0.5
		
		nitrogen.set('custom_styles/fg', foreground)
		nitrogen.set('custom_styles/bg', background)
		
		nitrogen.get_node('Label').add_color_override('font_color', COLORS[i])
		nitrogen.get_node('Label').text += str(i + 1)
		
		add_child(player_score)
	
	change_score(2, 3) # TEMPORARY
	change_nitrogen(1, 0.25) # TEMPOARY

func change_score(player, by):
	scores[player] += by
	
	var score = get_child(player).get_node('Score')
	
	score.text = str(scores[player])
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(score.get_font('font'), 'size', 96, 0.5)
	tween.tween_property(score.get_font('font'), 'size', 64, 0.5)

func change_nitrogen(player, by):
	nitrogens[player] += by
	
	var nitrogen = get_child(player).get_node('Nitrogen')
	
	nitrogen.value = nitrogens[player]
	
	var foreground = nitrogen.get('custom_styles/fg')
	var foreground_colors = foreground.texture.gradient.colors
	
	foreground_colors[1] = COLORS[player] + (Color.white - COLORS[player]) * nitrogens[player]
	foreground.texture.gradient.colors = foreground_colors