extends Node2D

enum PlayerState {WAITING, ALIVE, REVIVING, ABANDONED, DEAD, FINISHED}

export var speed = 64.0
export var nitro_speed = 128.0
export var rotation_speed = 1.0
export var grace_msec = 100.0
export var nutrients_gain = 0.5
export var nutrients_burn = 2.0 # how fast you're using nutrients
export var max_nutrients = 10.0
export var min_boost = 2.0
export var nitro_timeout = 1.0
export var revive_timeout = 1.0
export var return_speed = 128.0
export var line_width = 10
var nutrients = max_nutrients
var since_nitro = 1000
var since_dead = 1000
var mirror = 1
var state = PlayerState.WAITING
var collision_queue = []
var grace_start = -1000000
var nitro_active = false
var id
var index
var target_id
var track = PoolVector2Array([Vector2(0, 0)])
var line
const wrap_width = 2048

var hats = [
	preload("res://scenes/hats/Hat0.tscn"),
	preload("res://scenes/hats/Hat1.tscn"),
	preload("res://scenes/hats/Hat2.tscn"),
	preload("res://scenes/hats/Hat3.tscn")
]

var SegmentCollision = preload("res://scenes/SegmentCollision.tscn")
var Flower = preload("res://scenes/Flower.tscn")

func _ready():
	line = $Segments

func start_growing():
	since_nitro = 1000
	state = PlayerState.ALIVE


func move_input():
	return mirror * int(Input.is_action_pressed("right" + str(id))) - int(Input.is_action_pressed("left" + str(id)))

func _physics_process(delta):
	if state == PlayerState.ALIVE:
		var inp = move_input()
		$Tip.rotation += inp * delta * rotation_speed
		var current_speed = speed
		
		if Input.is_action_pressed("power" +str(id)) and nutrients > min_boost:
			nitro_active = true
		if nitro_active:
			current_speed = nitro_speed
			nutrients -= delta * nutrients_burn
			if nutrients <= 0:
				nitro_active = 0
			since_nitro = 0
		elif since_nitro > nitro_timeout:
			nutrients = min(nutrients + delta * nutrients_gain, max_nutrients)
		$Tip/NitroGlow.visible = nitro_active
		get_node("/root/World/CanvasLayer/PlayerScores").update_nitrogen(index, nutrients / max_nutrients)
		since_nitro += delta
		var vel = Vector2(0, -current_speed).rotated($Tip.rotation)

		$Tip.position += vel * delta
		if $Tip.global_position.x < 0:
			$Tip.position.x += wrap_width
			new_line(0)
		elif $Tip.global_position.x > wrap_width:
			$Tip.position.x -= wrap_width
			new_line(0)

		if track.size() == 0 || $Tip.position.distance_to(track[track.size() - 1]) > line_width / 2.0:
			line.add_point($Tip.position)
			collision_queue.push_back($Tip.position)
			track.append($Tip.position)
		if line.get_point_count() > 2000:
			new_line(3)
		if collision_queue.size() != 0 and collision_queue[0].distance_to($Tip.position) > line_width + $Tip/Hitbox/Collision.shape.radius + 1:
			var obstacleShape = CollisionShape2D.new()
			obstacleShape.shape = CircleShape2D.new()
			obstacleShape.position = collision_queue.pop_front()
			obstacleShape.shape.radius = line_width
			$ObstacleSegments.add_child(obstacleShape)
	elif state == PlayerState.REVIVING:
		#var vel = Vector2(0, -speed).rotated($Tip.rotation + PI * 2)
		var d = return_speed * delta
		var target = get_target()
		while target_id > 0 && d > $Tip.position.distance_to(target):
			d -= $Tip.position.distance_to(target)
			$Tip.position = target
			target_id -= 1
			target = get_target()
		$Tip.rotation = target.angle_to_point($Tip.position) - PI / 2
		$Tip.position = $Tip.position.move_toward(target, d)
		if $Tip.global_position.x < 0:
			$Tip.position.x += wrap_width
		elif $Tip.global_position.x > wrap_width:
			$Tip.position.x -= wrap_width
		since_dead += delta

func get_target():
	var target = track[target_id]
	if target.x > $Tip.position.x + wrap_width / 2:
		target.x -=  wrap_width
	if target.x < $Tip.position.x - wrap_width / 2:
		target.x +=  wrap_width
	return target

func new_line(nold):
	line = line.duplicate()
	var old = [$Tip.position]
	for i in range(nold):
		var ind = track.size() - i - 1
		if ind < 0:
			break
		old.push_front(track[ind])
	line.points = PoolVector2Array(old)
	add_child_below_node($Segments, line)

func _input(event):
	if state == PlayerState.REVIVING and move_input() != 0 and since_dead > revive_timeout:
		var newGerm = self.duplicate()
		newGerm.id = id
		newGerm.index = index
		newGerm.nutrients = nutrients
		newGerm.get_node("Tip").rotation += move_input() * 0.3
		track.resize(target_id)
		var old = []
		for i in range(3):
			var ind = track.size() - i - 1
			if ind < 0:
				break
			old.push_front(track[ind])
		newGerm.get_node("Segments").points = PoolVector2Array(old)
		newGerm.track = track
		newGerm.grace_start = Time.get_ticks_msec()
		newGerm.start_growing()
		state = PlayerState.ABANDONED
		$Tip.visible = false
		get_parent().add_child(newGerm)
	if Input.is_action_just_released("power" +str(id)):
		nitro_active = false
	if false and Input.is_action_just_pressed("power"+str(id)):
		var newGerm = self.duplicate()
		newGerm.mirror = -mirror
		$Tip.rotation += 0.1
		newGerm.get_node("Tip").rotation -= 0.1
		get_parent().add_child(newGerm)

func set_id_index(new_id, new_index):
	id = new_id
	index = new_index

	for icon in $Tip/Sprites.get_children():
		icon.queue_free()
	$Tip/Sprites.add_child(hats[index].instance())

func collide(body):
	if state == PlayerState.ALIVE && Time.get_ticks_msec() > grace_start + grace_msec:
		state = PlayerState.REVIVING
		target_id = track.size() - 1
		since_dead = 0

func _on_Tip_body_entered(body):
	collide(body)


func _on_Hitbox_body_entered(body):
	collide(body) # Replace with function body.


func _on_Hitbox_area_entered(area):
	if area.has_method("nutrience"):
		nutrients += area.nutrience()
		area.queue_free()


func die():
	if state == PlayerState.DEAD:
		return
	
	state = PlayerState.DEAD
	
	Global.add_player_dead(index)

func finish():
	if state == PlayerState.FINISHED:
		return
	
	state = PlayerState.FINISHED
	
	Global.add_player_finished(index)
	
	var flower = Flower.instance()
	
	flower.global_position = $Tip.global_position
	flower.scale.x = 1.2 - Global.players_finished * 0.2
	flower.scale.y = flower.scale.x
	
	get_node("/root/World/Potatoes").add_child(flower)
	
	flower.play()
