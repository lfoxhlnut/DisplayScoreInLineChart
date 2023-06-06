extends VBoxContainer

var test_mask: Array[int]:
	get:
		test_mask.clear()
		for check_box in get_children():
			check_box = check_box as CheckBox
			test_mask.append(check_box.button_pressed as int)
		return test_mask


func update(test_name: Array[String]):
	Constant.remove_and_free(self)
	for i in test_name:
		var check_box := CheckBox.new()
		check_box.text = i
		add_child(check_box)
