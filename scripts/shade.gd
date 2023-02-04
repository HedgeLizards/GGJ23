extends Area2D

export var fade_time = 0.5

var is_fading = false


func _process(delta):
	if is_fading:
		modulate.a -= delta / fade_time
		if modulate.a <= 0:
			queue_free()


func _on_Shade_area_entered(area):
	if area.has_method("has_sight"):
		is_fading = true
