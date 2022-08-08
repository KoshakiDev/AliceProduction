extends Node2D

#onready var info_text = $UILayer/InfoPos/Info
onready var timer = $WaveTimer


onready var entity_world = $World/EntityWorld

onready var enemies = $World/EntityWorld/Enemies
onready var projectiles = $World/EntityWorld/Projectiles
onready var players = $World/EntityWorld/Players
onready var items = $World/EntityWorld/Items
onready var spawners = $World/EntityWorld/Spawners.get_children()
onready var misc = $World/EntityWorld/Misc
onready var misc_2 = $World/Misc2
onready var navigation = $World/Navigation2D

onready var objects = $World/EntityWorld/Objects
#var wave_num = 0
#var points = 0
var is_wave_updating = false

#var enemy_count = 0

signal all_dead

export var is_big_room = true

func _ready():
	Global.enemy_count = 0
	Global.wave_num = 0
	Global.points = 0
	Ngio.request("Event.logEvent", {"event_name": "NewRoundLoaded","host": "https://newgrounds.com/"})
	#Ngio.request("App.logView", {"host": "https://newgrounds.com/"})
	#AudioServer.set_bus_volume_db(0, 0)
	$InfoAnimationPlayer.play("Idle")
	Global.set("main", self)
	Global.set("entity_world", entity_world)
	Global.set("items", items)
	Global.set("players", players)
	Global.set("projectiles", projectiles)
	Global.set("enemies", enemies)
	Global.set("misc", misc)
	Global.set("navigation", navigation)
	Global.set("misc_2", misc_2)
	Global.set("objects", objects)
	
	#yield(get_tree().root, "ready")
	
	#Global.UI_layer.update_board(points, wave_num, enemy_count)
	
	#update_wave()
	Global.connect("all_dead", self, "all_players_dead")
	if Global.is_big_room == 1:
		if Global.is_table_spawned:
			spawn_table()
		if Global.is_door_spawned:
			spawn_small_door()
		if Global.is_box_deleted:
			delete_box()
	
#func update_board():
#	print(points)
##	info_text.bbcode_text = "[center]WAVE: " + str(wave_num) + "[/center]\n[center]POINTS: " + str(points) + "[/center]\n[center]LEFT: " + str(enemy_count) + "[/center]"
#	info_text.bbcode_text = "[wave amp=10 freq=2][color=black]WAVE: %s \nPOINTS: %s \nLEFT: %s " % [str(wave_num), str(points), str(enemy_count)]

func update_points(point_amount):
	Global.points += point_amount
	if Global.UI_layer != null:
		Global.UI_layer.update_board()

func update_wave():
	is_wave_updating = true
	Global.UI_layer.update_board()
	timer.start()
	yield(timer, "timeout")
	
	Global.wave_num += 1
	
	for spawner in spawners:
		Global.enemy_count += Global.wave_num
		spawner.add_enemies(Global.wave_num)

	Shake.shake(8.0, 1)
	Global.UI_layer.update_board()
	is_wave_updating = false
	

func all_players_dead():
	$Dead.play()
	timer.start()
	yield(timer, "timeout")
	
	#show_death_screen()
	Global.final_score = Global.points
	Global.wave_survived = Global.wave_num
	Ngio.request("ScoreBoard.postScore", {"id": 11467, "value": Global.points})
	Ngio.request("ScoreBoard.postScore", {"id": 11468, "value": Global.wave_num})
	back_to_menu()

func show_death_screen():
	SceneChanger.change_scene("res://src/menu/DeathScreen.tscn", "fade")

func back_to_menu():
	SceneChanger.change_scene("res://src/menu/Menu.tscn", "fade")

func _input(event):
	if event.is_action_pressed("switch_rooms"):
		if Global.is_big_room == 1: 
			change_to_small_room()
		else:
			change_to_big_room()
		Global.is_big_room *= -1
	if event.is_action_pressed("spawn_table"):
		spawn_table()
	if event.is_action_pressed("spawn_bottle"):
		spawn_bottle()
	if event.is_action_pressed("spawn_door"):
		spawn_small_door()
	if event.is_action_pressed("spawn_cake"):
		spawn_cake()


var TABLE_SCENE = load("res://Alice Production Test/src/props/Table.tscn")
var BOTTLE_SCENE = load("res://Alice Production Test/src/props/Bottle.tscn")
var SMALL_DOOR_SCENE = load("res://Alice Production Test/src/props/DoorSmall.tscn")
var CAKE_SCENE = load("res://Alice Production Test/src/props/Cake.tscn")


func spawn_table():
	var table_instance = TABLE_SCENE.instance()
	table_instance.global_position = Vector2(516, 350)
	Global.objects.add_child(table_instance)
	Global.set("table", table_instance)
	Global.is_table_spawned = true

func spawn_bottle():
	var bottle_instance = BOTTLE_SCENE.instance()
	bottle_instance.global_position = Vector2(675, 360)
	Global.items.add_child(bottle_instance)
		

func spawn_small_door():
	var door_instance = SMALL_DOOR_SCENE.instance()
	door_instance.global_position = Vector2(516, 256)
	Global.objects.add_child(door_instance)
	Global.is_door_spawned = true

func spawn_cake():
	var cake_instance = CAKE_SCENE.instance()
	cake_instance.global_position = Vector2(512, 340)
	Global.items.add_child(cake_instance)
	
func delete_box():
	$World/EntityWorld/Objects/Box.queue_free()

func change_to_big_room():
	SceneChanger.change_scene("res://Alice Production Test/BigRoom.tscn", "fade")

func change_to_small_room():
	SceneChanger.change_scene("res://Alice Production Test/SmallRoom.tscn", "fade")
