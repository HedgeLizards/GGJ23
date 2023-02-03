extends Node2D

enum PlayerState {ALIVE, REVIVING, ABANDONED}

export var speed = 64
export var rotation_speed = 1
var mirror = 1
var state = PlayerState.ALIVE

var target_id


var id
func _ready():
	id = get_parent().id

func move_input():
	return mirror * int(Input.is_action_pressed("right" + str(id))) - int(Input.is_action_pressed("left" + str(id)))

func _physics_process(delta):
	if state == PlayerState.ALIVE:
		var inp = move_input()
		$Tip.rotation += inp * delta * rotation_speed

		var vel = Vector2(0, -speed).rotated($Tip.rotation)

		$Tip.position += vel * delta

		if $Segments.get_point_count() == 0 || $Tip.position.distance_to($Segments.get_point_position($Segments.get_point_count() - 1)) > 5:
			$Segments.add_point($Tip.position)
	elif state == PlayerState.REVIVING:
		#var vel = Vector2(0, -speed).rotated($Tip.rotation + PI * 2)
		var d = speed * delta
		var target = $Segments.get_point_position(target_id)
		while target_id > 0 && d > $Tip.position.distance_to(target):
			d -= $Tip.position.distance_to(target)
			$Tip.position = target
			target_id -= 1
			target = $Segments.get_point_position(target_id)
		$Tip.rotation = target.angle_to_point($Tip.position) - PI / 2
		$Tip.position = $Tip.position.move_toward(target, d)
		
		


func _input(event):
	if state == PlayerState.REVIVING and move_input() != 0:
		var newGerm = self.duplicate()
		newGerm.get_node("Tip").rotation += move_input() * 0.3
		var new_points = $Segments.points
		new_points.resize(target_id + 1)
		newGerm.get_node("Segments").points = new_points
		newGerm.state = PlayerState.ALIVE
		state = PlayerState.ABANDONED
		$Tip.visible = false
		get_parent().add_child(newGerm)
	if false and Input.is_action_just_pressed("power"+str(id)):
		var newGerm = self.duplicate()
		newGerm.mirror = -mirror
		$Tip.rotation += 0.1
		newGerm.get_node("Tip").rotation -= 0.1
		get_parent().add_child(newGerm)
	
	

func collide():
	state = PlayerState.REVIVING
	target_id = $Segments.get_point_count() - 1

func _on_Tip_body_entered(body):
	collide()