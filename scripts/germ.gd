extends Node2D

enum PlayerState {WAITING, ALIVE, REVIVING, ABANDONED, DEAD, FINISHED}
enum PowerUp {SPEED, DRILL, BLOCK}

export var speed = 200 # how fast the player moves
export var nitro_speed = 400 # how fast the player moves when using 'boost'
export var rotation_speed = 5 # how fast the player rotates
export var grace_msec = 100.0 # ghost period
export var nutrients_gain = 2.5 # how many nutrients are recharged per second
export var nutrients_burn = 10 # how fast you're using nutrients
export var max_nutrients = 100 # indicates the 'max' amount of nutrients
export var min_boost = 10 # you cannot use 'boost' before you have at least 5 nutrients
export var nitro_timeout = .4 # the amount of seconds before nutrients start regenerating again
export var revive_timeout = .4 # the amount of time before the player can resume their path
export var return_speed = 200 # how fast the player moves backwards
export var line_width = 10 
export var base_line = 15

export var nutrients = 25

var powerup = PowerUp.SPEED

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
var track = PoolVector2Array()
var line
const wrap_width = 2048
var last_blocked = 0
var temp = false
var lifetime = 0.5

var random_boost_sound
var boosting = false;

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
	last_blocked -= delta
	$Tip/ParDigging.emitting = state == PlayerState.ALIVE && not nitro_active
	$Tip/ParNitro.emitting = state == PlayerState.ALIVE && nitro_active
	if state == PlayerState.ALIVE:
		var inp = move_input()
		$Tip.rotation += inp * delta * rotation_speed
		var current_speed = speed
		
		if Input.is_action_pressed("power" +str(id)) and nutrients > min_boost:
			nitro_active = true
			
		if nitro_active:
			play_boost_sound(); # Plays the boost sound effect
			if powerup == PowerUp.SPEED:
				current_speed = nitro_speed
			if powerup == PowerUp.BLOCK and last_blocked <= 0:
				last_blocked = 0.3
				var new_germ
				if randf() > 0.5:
					new_germ = split(0.5)
				else:
					new_germ = split(-0.5)
				new_germ.get_node("Tip").visible = false
				new_germ.temp = true
		
			nutrients -= delta * nutrients_burn
			if nutrients <= 0:
				nitro_active = 0
			since_nitro = 0
		
		elif since_nitro > nitro_timeout:
			nutrients = min(nutrients + delta * nutrients_gain, max_nutrients)
		
		else:
			stop_boost_sound();
		
		$Tip/NitroGlow.visible = nitro_active && powerup == PowerUp.SPEED
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

		if track.size() == 0:
			line.add_point($Tip.position + Vector2(0, base_line))
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
		while target != null and d > $Tip.position.distance_to(target):
			d -= $Tip.position.distance_to(target)
			$Tip.position = target
			target_id -= 1
			target = get_target()
		if target == null:
			die()
			return
		$Tip.rotation = target.angle_to_point($Tip.position) - PI / 2
		$Tip.position = $Tip.position.move_toward(target, d)
		if $Tip.global_position.x < 0:
			$Tip.position.x += wrap_width
		elif $Tip.global_position.x > wrap_width:
			$Tip.position.x -= wrap_width
		since_dead += delta

func get_target():
	if target_id < 0:
		return null
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
	if state == PlayerState.REVIVING and (move_input() != 0 or Input.is_action_pressed("power"+str(id))) and since_dead > revive_timeout:
		var newGerm = split(move_input() * 0.3)
		$Tip.visible = false
		state = PlayerState.ABANDONED
	if Input.is_action_just_released("power" +str(id)):
		nitro_active = false
	if false and Input.is_action_just_pressed("power"+str(id)):
		var newGerm = self.duplicate()
		newGerm.mirror = -mirror
		$Tip.rotation += 0.1
		newGerm.get_node("Tip").rotation -= 0.1
		get_parent().add_child(newGerm)

func split(angle):
	var newGerm = self.duplicate()
	newGerm.id = id
	newGerm.index = index
	newGerm.nutrients = nutrients
	newGerm.get_node("Tip").rotation += angle
	track.resize(target_id)
	newGerm.track = track
	var old = []
	for i in range(3):
		var ind = newGerm.track.size() - i - 1
		if ind < 0:
			break
		old.push_front(newGerm.track[ind])
	newGerm.get_node("Segments").points = PoolVector2Array(old)
	newGerm.grace_start = Time.get_ticks_msec()
	newGerm.start_growing()
	get_parent().add_child(newGerm)
	return newGerm

func set_id_index(new_id, new_index):
	id = new_id
	index = new_index

	for icon in $Tip/Sprites.get_children():
		icon.queue_free()
	$Tip/Sprites.add_child(hats[index].instance())

func abandon():
	$Tip.visible = false
	state = PlayerState.ABANDONED

func collide(body):
	if temp:
		abandon()
	if state == PlayerState.ALIVE:
		if Time.get_ticks_msec() < grace_start + grace_msec and body.get_parent().has_method("get_id") and body.get_parent().get_id() == id:
			return
		if nitro_active and powerup == PowerUp.DRILL:
			return
		state = PlayerState.REVIVING
		target_id = track.size() - 1
		since_dead = 0
		
		if $'/root/World/SND_PlayerCollide'.is_playing():
			$'/root/World/SND_PlayerCollide'.stop();
		$'/root/World/SND_PlayerCollide'.play();
		stop_boost_sound();

func _on_Tip_body_entered(body):
	collide(body)

func _on_Hitbox_body_entered(body):
	collide(body) # Replace with function body.

func _on_Hitbox_area_entered(area):
	if area.has_method("nutrience"):
		nutrients += area.nutrience()
		area.queue_free()
		
		if $'/root/World/SND_PlayerPickup'.is_playing():
			$'/root/World/SND_PlayerPickup'.stop();
		$'/root/World/SND_PlayerPickup'.play();

func die():
	if state == PlayerState.DEAD:
		return
	
	state = PlayerState.DEAD
	
	if $'/root/World/SND_PlayerDeath'.is_playing():
		$'/root/World/SND_PlayerDeath'.stop();
	$'/root/World/SND_PlayerDeath'.play();
	
	Global.add_player_dead(index)

func finish():
	if state == PlayerState.FINISHED:
		return
	
	state = PlayerState.FINISHED
	
	Global.add_player_finished(index)
	
	var flower = Flower.instance()
	
	flower.global_position = $Tip.global_position
	flower.scale.x = 1.1 - Global.players_finished * 0.2
	flower.scale.y = flower.scale.x
	
	get_node("/root/World/Potatoes").add_child(flower)
	
	stop_boost_sound();
	flower.play()

func get_id():
	return id

func play_boost_sound():
	var rng = RandomNumberGenerator.new();
	rng.randomize();
	random_boost_sound = rng.randf_range(0, 3);
	
	if !$'/root/World/SND_PlayerBoost'.get_children()[random_boost_sound].is_playing() and boosting == false:
		$'/root/World/SND_PlayerBoost'.get_children()[random_boost_sound].play();
		boosting = true;

func stop_boost_sound():
	if boosting == true:
		for i in 4:
			print("Stop boost sound");
			$'/root/World/SND_PlayerBoost'.get_children()[i].stop();
	boosting = false;
