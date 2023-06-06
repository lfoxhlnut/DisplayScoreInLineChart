extends Button

@onready var confirmation_dialog = $ConfirmationDialog


# 是的, 这里连接了两个信号, 因为没必要为了相同的代码再写一遍
func _on_pressed() -> void:
	confirmation_dialog.popup_centered()


func _on_confirmation_dialog_confirmed():
	Interface.del_all_class()
