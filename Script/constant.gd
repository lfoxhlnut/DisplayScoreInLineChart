extends Node

signal warn_closed

const WIN_SIZE := Vector2(1920, 1080)
var SAVE_DIR_PATH := OS.get_user_data_dir() + '/save/'

enum Subject {
	CN,
	MATH,
	EN,
	PHYSICS,
	CHEMISTRY,
	BIOLOGY,
	POLITICS,
	HISTORY,
	GEOGRAPHY,
}
const SUBJECT_NAME: Array[String] = [
	"语文",
	"数学",
	"英语",
	"物理",
	"化学",
	"生物",
	"道法",
	"历史",
	"地理",
]
var SUBJECT_NUM := Subject.values().size()	# 用 const 会报错
enum PointScale {
	point_scale_of_50 = 50,		# 此处枚举值的设立似乎只在这种成倍数的关系中方便
	point_scale_of_100 = 100,	# 不过管他呢, 有需求了再改
}

# 图形设计有点问题, 再说吧.



func remove_and_free(n: Node) -> void:
	if n.get_child_count():
		for i in n.get_children():
			i.queue_free()
			n.remove_child(i)


func remove_and_free_all_children(n: Node) -> void:
	remove_and_free(n)


# 然而, 这个函数好像有些问题, 我还没搞明白 is_inside_tree() 的原理, 最好先别用
func remove_and_free_children_added_in_runtime(n: Node) -> void:
	if n.get_child_count():
		for i in n.get_children():
			if i.is_inside_tree():
				i.queue_free()
				n.remove_child(i)


func warn(node: Node, info: String):
	var warn_page := AcceptDialog.new()
	warn_page.dialog_text = info
	node.add_child(warn_page)
	warn_page.popup(Rect2i(WIN_SIZE * 0.15, WIN_SIZE * 0.6))
	await warn_page.close_requested
	node.remove_child(warn_page)
	warn_page.call_deferred("free")
	warn_closed.emit()
	
