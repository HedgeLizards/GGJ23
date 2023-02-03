extends Node2D


export var speed = 64
export var rotation_speed = 1
var mirror = 1

var id
func _ready():
	id = get_parent().id

func _physics_process(delta):
	var inp = mirror * int(Input.is_action_pressed("right" + str(id))) - int(Input.is_action_pressed("left" + str(id)))
	$Tip.rotation += inp * delta * rotation_speed

	var vel = Vector2(0, -speed).rotated($Tip.rotation)

	$Tip.move_and_slide(vel)

	if $Segments.get_point_count() == 0 || $Tip.position.distance_to($Segments.get_point_position($Segments.get_point_count() - 1)) > 5:
		$Segments.add_point($Tip.position)
		
func _input(event):
	if Input.is_action_just_pressed("power"+str(id)):
		var newGerm = self.duplicate()
		newGerm.mirror = -mirror
		$Tip.rotation += 0.1
		newGerm.get_node("Tip").rotation -= 0.1
		get_parent().add_child(newGerm)
	
	
