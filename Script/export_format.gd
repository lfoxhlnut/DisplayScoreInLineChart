extends VBoxContainer

@onready var export_to_pdf = $ExportToPdf
@onready var export_to_xlsx = $ExportToXlsx


var export_format: String:
	get:
		export_format = ''
		if export_to_pdf.button_pressed:
			export_format += 'pdf'
		if export_to_xlsx.button_pressed:
			export_format += 'xlsx'
		return export_format
