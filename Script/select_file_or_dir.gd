extends LineEdit

@export var file_dialog: FileDialog


# 我要求用户自己配置 file dialog, 所以我假定他们知道用户选择的是什么东西
# 虽然这也许会导致一些问题, 不过要完善的话有些麻烦且看起来目前没必要
# 也许我不应该提供访问 selected paths, 这会导致一些混乱
var selected_path: String:
	set(val):
		text = val
	get:
		return text

var selected_paths: PackedStringArray
@onready var select_path = $SelectPath


func _ready():
	assert(file_dialog != null)
	file_dialog.dir_selected.connect(_on_file_dialog_dir_selected)
	file_dialog.file_selected.connect(_on_file_dialog_file_selected)
	file_dialog.files_selected.connect(_on_file_dialog_files_selected)
	if file_dialog.file_mode == FileDialog.FILE_MODE_OPEN_FILE:
		select_path.text = "选择一个文件"
	if file_dialog.file_mode == FileDialog.FILE_MODE_OPEN_DIR:
		select_path.text = "选择一个文件夹"
	


func _on_select_path_pressed() -> void:
	file_dialog.show()


func _on_file_dialog_dir_selected(dir: String) -> void:
	text = dir


func _on_file_dialog_file_selected(file: String) -> void:
	text = file


func _on_file_dialog_files_selected(paths: PackedStringArray) -> void:
	selected_paths = paths
	text = paths[0]
	if paths.size() > 1:
		text += ", ..."
