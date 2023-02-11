extends AnimatedSprite


export var soundahead = 0

func _on_Flower_frame_changed():
	if frame == 28 - soundahead:
		$Firstleaf.play()
	elif frame == 40 - soundahead:
		$Secondleaf.play()
