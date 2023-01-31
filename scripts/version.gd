extends Label


const version_file = "res://version.tres"

func _ready():
	var file = File.new()
	file.open(version_file, File.READ)
	text = file.get_line()
	file.close()
	modulate.a = 0.5

