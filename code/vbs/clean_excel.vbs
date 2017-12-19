' ------------------------------------------
' Inicializacao de variaveis de sistema
Dim fso, wshShell

Set fso = CreateObject("Scripting.FileSystemObject")
Set wshShell = CreateObject("WScript.Shell")
' ------------------------------------------
' Inicializacao de variaveis de usuario
data_raw = fso.BuildPath(wshShell.CurrentDirectory, "\data-raw\")
old_file = Wscript.Arguments.Item(0)
old_path = fso.BuildPath(data_raw, old_file)

new_file = Wscript.Arguments.Item(1)
' ------------------------------------------
' Inicializacao das variaveis do excel e operaes
Dim excel, workbook 

WScript.Echo "Limpeza data-raw\" & old_file & "..."

Set excel = CreateObject("Excel.Application")
excel.Application.DisplayAlerts = False

Set workbook = excel.Workbooks.Open(fso.GetFile(old_path))

On Error Resume Next
workbook.Worksheets("base").ShowAllData
On Error GoTo 0

workbook.Worksheets("base").Cells.ClearFormats
workbook.SaveAs data_raw & new_file, 51
workbook.Close

excel.Application.DisplayAlerts = True
excel.Application.Quit 
' ------------------------------------------
' Finalizao
Set fso = Nothing
Set workbook = Nothing    
Set excel = Nothing
Set wshShell = Nothing

wScript.Quit
