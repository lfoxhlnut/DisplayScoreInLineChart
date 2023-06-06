extends Control

signal updated

const MAX_CLASS_NUM := 10
const MAX_SUTDENT_NUM := 64
const MAX_STUDENT_ROW := 8
const MAX_STUDENT_COLUMN := 8

const CLASS_NAME_CONTINER_SIZE := Vector2(300, 80)
const TEST_NAME_CONTINER_SIZE := CLASS_NAME_CONTINER_SIZE


var class_info := []:	# 似乎没必要写 setget
	set(val):
		if val.size() < MAX_CLASS_NUM:
			class_info = val
		else:
			class_info = []
			for i in range(MAX_CLASS_NUM):
				class_info.append(val[i])
		
		for i in class_info:
			assert(i is ClassInfo)

var current_class_id: int:
	set(id):
		Constant.remove_and_free(test_list)
		for i in class_info[id].test_name.size():
			var label := Label.new()
			label.text = class_info[id].test_name[i]
			label.custom_minimum_size = TEST_NAME_CONTINER_SIZE
			test_list.add_child(label)


var class_info_tmp: Array[ClassInfo] = [
	ClassInfo.new("class 725", ["test 1", "test2"]),
	ClassInfo.new("class bbb", ["test 1", "'test2;.[]'"]),
	ClassInfo.new("class 中文", ["中文 1", "鳄鱼"])
]

@onready var class_list := $ClassList
@onready var test_list = $TestList
@onready var new_class = $NewClass
@onready var new_test = $NewTest
@onready var del_class = $DelClass
@onready var del_test = $DelTest

func _ready():
	$FileDialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	new_class.new_class_created.connect(func(): updated.emit())
	new_test.new_test_created.connect(func(): updated.emit())


func update(new_class_info: Array[ClassInfo]) -> void:
	assert(new_class_info.size() > 0)
	class_info = new_class_info
	class_list.update(class_info)
	new_class.update(class_info)
	new_test.update(class_info)


func get_selected_test() -> Array:
	var selected := []
	
	var id := 0
	for child in test_list.get_children():
		if child.button_pressed:
			selected.append(id)
		id += 1
	return selected


func _on_class_list_class_selected(id: int):
	test_list.update(class_info[id])
