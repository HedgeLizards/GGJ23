extends CanvasLayer

var reload = false

func reload_scene():
	reload = true
	
	$AnimationPlayer.connect('animation_finished', self, '_on_AnimationPlayer_animation_finished', [], CONNECT_ONESHOT)
	$AnimationPlayer.play('DISSOLVE');

func _on_AnimationPlayer_animation_finished(_anim_name):
	$AnimationPlayer.play_backwards('DISSOLVE');
	
	if reload:
		reload = false
		
		get_tree().reload_current_scene()
