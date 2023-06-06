extends OptionButton

var selectd_item_name: String:
	get:
		return get_item_text(get_item_index(get_selected_id()))

func update(item_name: Array[String]) -> void:
	clear()
	for i in min(item_name.size(), get_max_item_num()):
		add_item(item_name[i])


# 在子类中重写这个方法以改变最大 item 数目
func get_max_item_num() -> int:
	return 16
