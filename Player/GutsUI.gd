extends Control

const underfullSprite = preload("res://Assets/full guts.png")
const overfullSprite = preload("res://Assets/fullover guts.png")

var guts = 4 setget set_guts
var max_guts = 4 setget set_max_guts

onready var gutsUIEmpty = $GutsUIEmpty
onready var gutsUIFUll = $GutsUIFull

const guts_size = 1

func _ready():
	self.max_guts = PlayerStats.max_guts
	self.guts = PlayerStats.guts
	PlayerStats.connect("guts_changed", self, "set_guts")
	PlayerStats.connect("max_guts_changed", self, "set_max_guts")

func set_guts(value):
#	guts = value
	guts = clamp(value, 0, max_guts * 4)
	if gutsUIFUll != null:
		gutsUIFUll.rect_size.x = guts * guts_size
		if guts <= max_guts:
			gutsUIFUll.set_texture(underfullSprite)
		else:
			gutsUIFUll.set_texture(overfullSprite)

func set_max_guts(value):
	max_guts = max(value, 1)
	self.guts = min(guts, max_guts)
	if gutsUIEmpty != null:
		gutsUIEmpty.rect_size.x = max_guts * guts_size


