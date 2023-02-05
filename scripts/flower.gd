extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
export var soundahead = 0

func _on_Flower_frame_changed():
	if frame == 28 - soundahead:
		$Firstleaf.play()
	elif frame == 40 - soundahead:
		$Secondleaf.play()
