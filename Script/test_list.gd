extends "res://Script/item_list.gd"

var class_info: ClassInfo


func update(data: ClassInfo) -> void:
	class_info = data
	_update(class_info.test_num)


func get_item_description(id: int) -> String:
	return class_info.get_test(id)
