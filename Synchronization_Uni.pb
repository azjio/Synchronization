

; AZJIO

EnableExplicit


; Определение языка интерфейса и применение

; Определяет язык ОС
CompilerSelect #PB_Compiler_OS
	CompilerCase #PB_OS_Windows
		Global UserIntLang, *Lang
		If OpenLibrary(0, "kernel32.dll")
			*Lang = GetFunction(0, "GetUserDefaultUILanguage")
			If *Lang
				UserIntLang = CallFunctionFast(*Lang)
			EndIf
			CloseLibrary(0)
		EndIf
	CompilerCase #PB_OS_Linux
		Global UserIntLang$
		If ExamineEnvironmentVariables()
		    While NextEnvironmentVariable()
		    	If Left(EnvironmentVariableName(), 4) = "LANG"
; 		    		LANG=ru_RU.UTF-8
; 		    		LANGUAGE=ru
					UserIntLang$ = Left(EnvironmentVariableValue(), 2)
					Break
				EndIf
		    Wend
		EndIf
CompilerEndSelect


#CountStrLang = 44 ; число строк перевода и соответсвенно массива
Global Dim Lng.s(#CountStrLang)
Lng(1) = "Sync directories"
Lng(2) = "Select Folder "
Lng(3) = "Path 1"
Lng(4) = "Copy selected to opposite directory"
Lng(5) = "Delete selected"
Lng(6) = "Select all"
Lng(7) = "Path 2"
Lng(8) = "different paths"
Lng(9) = "different path size"
Lng(10) = "different path date"
Lng(11) = "different path size date"
Lng(12) = "same paths"
Lng(13) = "same path size"
Lng(14) = "same path date"
Lng(15) = "same path size date"
Lng(16) = "Find files and compare"
Lng(17) = "Find empty directories"
Lng(18) = "Open file folder"
Lng(19) = "Open file"
Lng(20) = "Select folder"
Lng(21) = " List errors of the operation "
Lng(22) = " Done, "
Lng(23) = ", items: "
Lng(24) = " h "
Lng(25) = " m "
Lng(26) = " s "
Lng(27) = " ms "
Lng(28) = "Item name"
Lng(29) = "Open ini file"
Lng(30) = "Add to ini file"
Lng(31) = "The match does not exist in the adjacent folder"
Lng(32) = "Compare doubles"
Lng(33) = "Compare selected"
Lng(34) = "Error"
Lng(35) = "Paths must be specified."
Lng(36) = "The paths on the left and right are the same."
Lng(37) = "The path is not specified correctly"
Lng(38) = "Continue?"
Lng(39) = "One folder is a subfolder of another, continue?"
Lng(40) = "Use find package"
Lng(41) = "All files"
Lng(42) = "Mask ext1,ext2"
Lng(43) = "Except ext1,ext2"
Lng(44) = "List to clipboard"


CompilerSelect #PB_Compiler_OS
	CompilerCase #PB_OS_Windows
		If UserIntLang = 1049
	CompilerCase #PB_OS_Linux
		If UserIntLang$ = "ru"
CompilerEndSelect
	Lng(1) = "Синхронизация каталогов"
	Lng(2) = "Выбрать папку"
	Lng(3) = "Путь 1"
	Lng(4) = "Копировать выбранные в противоположный каталог"
	Lng(5) = "Удалить выбранные"
	Lng(6) = "Выделить все"
	Lng(7) = "Путь 2"
	Lng(8) = "разные пути"
	Lng(9) = "разные путь размер"
	Lng(10) = "разные путь дата"
	Lng(11) = "разные путь размер дата"
	Lng(12) = "одинаковые пути"
	Lng(13) = "одинаковые путь размер"
	Lng(14) = "одинаковые путь дата"
	Lng(15) = "одинаковые путь размер дата"
	Lng(16) = "Найти файлы и сравнить"
	Lng(17) = "Найти пустые каталоги"
	Lng(18) = "Открыть папку файла"
	Lng(19) = "Открыть файл"
	Lng(20) = "Выбор папки"
	Lng(21) = "Список ошибок операции"
	Lng(22) = "Выполнено за "
	Lng(23) = ", пунктов: "
	Lng(24) = " ч "
	Lng(25) = " м "
	Lng(26) = " с "
	Lng(27) = " мс "
	Lng(28) = "Имя пункта"
	Lng(29) = "Открыть ini-файл"
	Lng(30) = "Добавить в ini-файл"
	Lng(31) = "Парного в соседней папке не существует"
	Lng(32) = "Сравнить парный"
	Lng(33) = "Сравнить выделенные"
	Lng(34) = "Ошибка"
	Lng(35) = "Необходимо указать пути."
	Lng(36) = "Пути слева и справа одинаковы."
	Lng(37) = "Путь указан не верно"
	Lng(38) = "Продолжить?"
	Lng(39) = "Одна папка является подпапкой другой, продолжить?"
	Lng(40) = "Использовать пакет find"
	Lng(41) = "Все файлы"
	Lng(42) = "Маска ext1,ext2"
	Lng(43) = "Кроме ext1,ext2"
	Lng(44) = "Список в буфер обмена"
EndIf

Global hListView1
Global hListView2

CompilerIf  #PB_Compiler_OS = #PB_OS_Windows
	Global hListView, SortOrder.d, indexSort, lvi.LV_ITEM
	Global SortOrder1.d, indexSort1
	Global SortOrder2.d, indexSort2
	XIncludeFile "Sort.pb"
CompilerEndIf

;- Перечисления
#Window = 0
#MenuCont = 0
#MenuSel = 1

; Гаджеты
Enumeration
	#StrG1
	#StrG2
	#LV1
	#LV2
	#Open1
	#Open2
	#Copy1
	#Copy2
	#Del1
	#Del2
	#Cmb
	#Scan
	#Container1
	#Container2
	#Splitter
	#ChAll1
	#ChAll2
	#Empty
	#StatusBar
	#ChFind
	#btnMenuSel
	#StrMask
	#ChTMask
EndEnumeration

Define w, h, w1, w2, h1, h2
Define tmp$, tmp2$, itmp, em, ini_NotFindName

Global Path1$, Path2$, EvGad
Global ff = 1, ChFind
Global g_Mask$ = "*"
Global g_MaskType = 0

; CompilerSelect #PB_Compiler_OS
;     CompilerCase #PB_OS_Windows
; 		Declare FileSearch(List Files.s(), sPath.s, Mask$ = "*", depth=130, mode = 0)
;     CompilerCase #PB_OS_Linux
; 		Declare FileSearch_find(List Files.s(), sPath.s, Mask$ = "*", depth=130, mode = 0)
; CompilerEndSelect

;- Declare
; в Linux делаем две функции поиска файлов
CompilerIf  #PB_Compiler_OS = #PB_OS_Linux
	Declare FileSearch_find(List Files.s(), sPath.s, Mask$ = "*", MaskType = 0, depth=130, mode = 0)
CompilerEndIf
Declare FileSearch(List Files.s(), sPath.s, Mask$ = "*", MaskType = 0, depth=130, mode = 0)
Declare SplitL(String.s, List StringList.s(), Separator.s = " ")
Declare Compare(List Files1.s(), List Files2.s(), mode)
Declare Scan()
Declare EmptyFolders(StrG, LV)
Declare ChAll(LV, ChAll)
Declare ForceDirectories(Dir.s)
Declare CopyDel(mode, LV1, LV2, StrG1, StrG2)
Declare.s FormTime(time)
Declare OpenFileMenu(LV, StrG, mode)
Declare SaveFile_Buff(File.s, *Buff, Size)
Declare CompareProg(mode)
Declare GetSetting(em)
Declare AddedSample()
Declare ReadListFiles(LV)

CompilerIf  #PB_Compiler_OS = #PB_OS_Linux
	; https://www.purebasic.fr/english/viewtopic.php?p=531374#p531374
	ImportC ""
		gtk_window_set_icon(a.l,b.l)
	EndImport
CompilerEndIf

UseGIFImageDecoder()


;- ini
Global ini$ = GetPathPart(ProgramFilename()) + "Synchronization.ini"
Global isINI = 0
If FileSize(ini$) = -1
	CompilerSelect #PB_Compiler_OS
		CompilerCase #PB_OS_Windows
			ini$ = GetHomeDirectory() + "AppData\Roaming\Synchronization\Synchronization.ini"
		CompilerCase #PB_OS_Linux
			ini$ = GetHomeDirectory() + ".config/Synchronization/Synchronization.ini"
; 		CompilerCase #PB_OS_MacOS
; 			ini$ = GetHomeDirectory() + "Library/Application Support/Synchronization/Synchronization.ini"
	CompilerEndSelect
EndIf
If FileSize(ini$) = -1 And ForceDirectories(GetPathPart(ini$))
	SaveFile_Buff(ini$, ?ini, ?iniend - ?ini)
EndIf

Global ww=600
Global wh=500
Global wm=0
Global CompareProg$, isCompareProg;, RemAttrib

If FileSize(ini$) > -1 And OpenPreferences(ini$)
	isINI = 1

	PreferenceGroup("Set")
	ww = ReadPreferenceInteger("ww", ww)
	wh = ReadPreferenceInteger("wh", wh)
	wm = ReadPreferenceInteger("wm", wm)
	CompareProg$ = ReadPreferenceString("Compare", "")
	If Asc(CompareProg$) And FileSize(CompareProg$) > 0
		isCompareProg = 1
	EndIf

; 	PreferenceGroup("Path")
; 	ExaminePreferenceKeys()
; 	While  NextPreferenceKey()
; 		MessageRequester("1'", PreferenceKeyName() + " = " + PreferenceKeyValue())
; 	Wend

	ExamineDesktops()
	If ww > DesktopWidth(0) - 80
		ww = DesktopWidth(0) - 80
	EndIf
	If ww < 350
		ww = 350
	EndIf
	If wh > DesktopHeight(0) - 80
		wh = DesktopHeight(0) - 80
	EndIf
	If wh < 250
		wh = 250
	EndIf
EndIf

w = ww
h = wh

DataSection
	CompilerIf  #PB_Compiler_OS = #PB_OS_Linux
		IconTitle:
		IncludeBinary "Synchronization.gif"
		IconTitleend:
	CompilerEndIf
	Icon1:
	IncludeBinary "1.gif"
	Icon1end:
	Icon2:
	IncludeBinary "2.gif"
	Icon2end:
	Icon3:
	IncludeBinary "3.gif"
	Icon3end:
	Icon4:
	IncludeBinary "find.gif"
	Icon4end:
	Icon5:
	IncludeBinary "5.gif"
	Icon5end:
	Icon6:
	IncludeBinary "6.gif"
	Icon6end:

	ini:
	IncludeBinary "sample.ini"
	iniend:
EndDataSection

CompilerIf  #PB_Compiler_OS = #PB_OS_Linux
	CatchImage(0, ?IconTitle)
CompilerEndIf
CatchImage(1, ?Icon1)
CatchImage(2, ?Icon2)
CatchImage(3, ?Icon3)
CatchImage(4, ?Icon4)
CatchImage(5, ?Icon5)
CatchImage(6, ?Icon6)


Global mn1
Define ww2
ww2 = ww / 2

;- GUI
If OpenWindow(#Window, 0, 0, ww, wh, Lng(1), #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
	CompilerIf  #PB_Compiler_OS = #PB_OS_Linux
		gtk_window_set_icon_(WindowID(#Window), ImageID(0)) ; назначаем иконку в заголовке
	CompilerEndIf

	WindowBounds(#Window, 450, 250, #PB_Ignore, #PB_Ignore)

	ContainerGadget(#Container1, 0, 0, ww2, wh - 39)
	ButtonImageGadget(#Open1, ww2 - 49, 7, 39, 31, ImageID(6))
	GadgetToolTip(#Open1, Lng(2))
	StringGadget(#StrG1, 10, 7, ww2 - 63, 30, "")
	hListView1 = ListIconGadget(#LV1,10, 40, ww2 - 20, wh - 115, Lng(3), 400, #PB_ListIcon_CheckBoxes | #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
	AddGadgetColumn(#LV1, 1, "", 70)
	AddGadgetColumn(#LV1, 2, "", 110)
	ButtonImageGadget(#Copy1, ww2 - 48, wh - 73, 30, 30, ImageID(1))
	GadgetToolTip(#Copy1, Lng(4))
	ButtonImageGadget(#Del1, ww2 - 88, wh - 73, 30, 30, ImageID(3))
	GadgetToolTip(#Del1, Lng(5))
	CompilerSelect #PB_Compiler_OS
		CompilerCase #PB_OS_Windows
			CheckBoxGadget(#ChAll1, ww2 - 110, wh - 73, 22, 22, "")
		CompilerCase #PB_OS_Linux
			CheckBoxGadget(#ChAll1, ww2 - 130, wh - 73, 22, 22, "")
	CompilerEndSelect
	GadgetToolTip(#ChAll1, Lng(6))

	StringGadget(#StrMask, 10, wh - 73, (ww2 - 130) / 2, 30, "")
	CheckBoxGadget(#ChTMask, (ww2 - 130) / 2 + 15, wh - 73, (ww2 - 130) / 2, 22, Lng(41), #PB_CheckBox_ThreeState)
	SetGadgetData(#ChTMask, 1)
	CloseGadgetList()

	ContainerGadget(#Container2, ww2, 0, ww2, wh - 39)
	ButtonImageGadget(#Open2, ww2 - 49, 7, 39, 31, ImageID(6))
	GadgetToolTip(#Open2, Lng(2))
	StringGadget(#StrG2, 10, 7, ww2 - 63, 30, "")
	hListView2 = ListIconGadget(#LV2,10, 40, ww2 - 20, wh - 115, Lng(7), 400, #PB_ListIcon_CheckBoxes | #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
	AddGadgetColumn(#LV2, 1, "", 70)
	AddGadgetColumn(#LV2, 2, "", 110)
	ButtonImageGadget(#Copy2, 10, wh - 73, 30, 30, ImageID(2))
	GadgetToolTip(#Copy2, Lng(4))
	ButtonImageGadget(#Del2, 50, wh - 73, 30, 30, ImageID(3))
	GadgetToolTip(#Del2, Lng(5))
	CheckBoxGadget(#ChAll2, 90, wh - 73, 22, 22, "")
	GadgetToolTip(#ChAll2, Lng(6))
	ButtonGadget(#btnMenuSel, ww2 - 56, wh - 73, 30, 30, Chr($25BC))

; 	CompilerIf  #PB_Compiler_OS = #PB_OS_Linux
	CompilerIf  #PB_Compiler_OS = #PB_OS_Linux
		CheckBoxGadget(#ChFind, 120, wh - 73, 55, 22, "find")
		GadgetToolTip(#ChFind, Lng(40))
		ChFind = 1
		SetGadgetState(#ChFind, #PB_Checkbox_Checked)
	CompilerEndIf
	CloseGadgetList()

	If CountProgramParameters()
		SetGadgetText(#StrG1, ProgramParameter(0))
		If CountProgramParameters() > 1
			SetGadgetText(#StrG2, ProgramParameter(1))
		EndIf
	EndIf

	HideGadget(#ChAll1, #True)
	HideGadget(#ChAll2, #True)

	ComboBoxGadget(#Cmb, 10, wh - 38, 80, 28)
	AddGadgetItem(#Cmb, -1, Lng(8))
	AddGadgetItem(#Cmb, -1, Lng(9))
	AddGadgetItem(#Cmb, -1, Lng(10))
	AddGadgetItem(#Cmb, -1, Lng(11))
	AddGadgetItem(#Cmb, -1, Lng(12))
	AddGadgetItem(#Cmb, -1, Lng(13))
	AddGadgetItem(#Cmb, -1, Lng(14))
	AddGadgetItem(#Cmb, -1, Lng(15))
	SetGadgetState(#Cmb, 3)

	ResizeGadget(#Cmb, #PB_Ignore, #PB_Ignore, ww2 - 20, #PB_Ignore)

	ButtonImageGadget(#Scan, ww - 80, wh - 38, 70, 30, ImageID(4))
	GadgetToolTip(#Scan, Lng(16))
	ButtonImageGadget(#Empty, ww - 120, wh - 38, 30, 30, ImageID(5))
	GadgetToolTip(#Empty, Lng(17))

	TextGadget(#StatusBar, ww2, wh - 38, ww2 - 120, 30, "", #PB_Text_Border)

	SplitterGadget(#Splitter, 0, 0, ww, wh - 39, #Container1, #Container2, #PB_Splitter_Vertical | #PB_Splitter_Separator)
	SetGadgetAttribute(#Splitter, #PB_Splitter_FirstMinimumSize, 170)
	SetGadgetAttribute(#Splitter, #PB_Splitter_SecondMinimumSize, 170)

	;- Menu
	If CreatePopupMenu(#MenuCont) ; Создаёт всплывающее меню
		MenuItem(0, Lng(18))
		MenuItem(1, Lng(19))
		If isCompareProg
			MenuItem(4, Lng(32))
			MenuItem(5, Lng(33))
		EndIf
		MenuItem(6, Lng(44))
; 		MenuItem(2, "")
	EndIf


	If CreatePopupMenu(#MenuSel)
		MenuItem(2, Lng(29))
		MenuItem(3, Lng(30))
		MenuBar()
		mn1 = 6 ; так как 7 пунктов уже созданы ранее, то отсчёт начинаем с 6 и первый пункт будет с индексом 7

		If isINI And OpenPreferences(ini$)

			ExaminePreferenceGroups()
			While NextPreferenceGroup()
				If PreferenceGroupName() <> "Set"
					tmp$ = ReadPreferenceString("Name", "")
					mn1 + 1
					If Not Asc(tmp$) ; Если нет имени, то группу используем как имя
						tmp$ = PreferenceGroupName()
					EndIf
					MenuItem(mn1, tmp$)
				EndIf
			Wend

; 			PreferenceGroup("Path")
; 			ExaminePreferenceKeys()
; 			While NextPreferenceKey()
; ; 				Debug 1
; 				mn1 + 1
; 				MenuItem(mn1, PreferenceKeyName())
; 			Wend

			ClosePreferences()
		EndIf
	EndIf

; 	Активируем гаджеты, которые допускают перетаскивание на себя
	EnableGadgetDrop(#StrG1, #PB_Drop_Files, #PB_Drag_Copy)
	EnableGadgetDrop(#StrG2, #PB_Drop_Files, #PB_Drag_Copy)
	EnableGadgetDrop(#LV1, #PB_Drop_Files, #PB_Drag_Copy)
	EnableGadgetDrop(#LV2, #PB_Drop_Files, #PB_Drag_Copy)

CompilerIf  #PB_Compiler_OS = #PB_OS_Windows
	SetWindowCallback(@MyWindowCallback(), #Window)
CompilerEndIf
If wm
	SetWindowState(#Window, #PB_Window_Maximize)
EndIf


; GUI2
; If OpenWindow(#WinSet, 0, 0, 340, 210, Lng(1), #PB_Window_Tool | #PB_Window_Invisible | #PB_Window_ScreenCentered)
; 	CompilerIf  #PB_Compiler_OS = #PB_OS_Linux
; 		gtk_window_set_icon_(WindowID(#WinSet), ImageID(0)) ; назначаем иконку в заголовке
; 	CompilerEndIf
; EndIf

;- Цикл
	Repeat
		Select WaitWindowEvent()
			Case #PB_Event_GadgetDrop ; событие перетаскивания
				Select EventGadget()
					Case #StrG1, #LV1 ; гаджеты, которые получили событие перетаскивания файлов/папок
						tmp$ = EventDropFiles() ; получаем список
						tmp$ = StringField(tmp$, 1, Chr(10)) ; берём только первый элемент
						If FileSize(tmp$) = -2 ; если папка, то вставляем, иначе очищаем
							SetGadgetText(#StrG1, tmp$)
						Else
							SetGadgetText(#StrG1, "")
						EndIf
					Case #StrG2, #LV2
						tmp$ = EventDropFiles()
						tmp$ = StringField(tmp$, 1, Chr(10))
						If FileSize(tmp$) = -2
							SetGadgetText(#StrG2, tmp$)
						Else
							SetGadgetText(#StrG2, "")
						EndIf
				EndSelect
;- Цикл Меню
			Case #PB_Event_Menu        ; кликнут элемент всплывающего Меню
				em = EventMenu()	   ; получим кликнутый элемент Меню...
				Select em
					Case 0
						If EvGad = #LV1
							OpenFileMenu(EvGad, #StrG1, 0)
						ElseIf EvGad = #LV2
							OpenFileMenu(EvGad, #StrG2, 0)
						EndIf
					Case 1
						If EvGad = #LV1
							OpenFileMenu(EvGad, #StrG1, 1)
						ElseIf EvGad = #LV2
							OpenFileMenu(EvGad, #StrG2, 1)
						EndIf
					Case 2 ; Открыть
						CompilerSelect #PB_Compiler_OS
							CompilerCase #PB_OS_Windows
								RunProgram(ini$)
							CompilerCase #PB_OS_Linux
								RunProgram("xdg-open", Chr(34) + ini$ + Chr(34), "")
						CompilerEndSelect
					Case 3 ; Добавить
						AddedSample()
					Case 4 ; Сравнить парный
						CompareProg(0)
					Case 5 ; Сравнить выделенный
						CompareProg(1)
					Case 6 ; получить список в буфер
						If EvGad = #LV1 Or EvGad = #LV2
							ReadListFiles(EvGad)
						EndIf
					Case 7 To mn1
						GetSetting(em)
				EndSelect
;- Цикл Гаджет
			Case #PB_Event_Gadget
				EvGad = EventGadget()
				Select EvGad
; 				Select EventGadget()
					Case #btnMenuSel
						DisplayPopupMenu(#MenuSel, WindowID(#Window))
					CompilerIf  #PB_Compiler_OS = #PB_OS_Linux
						Case #ChFind
							If GetGadgetState(#ChFind) = #PB_Checkbox_Checked
								ChFind = 1
							Else
								ChFind = 0
							EndIf
					CompilerEndIf
				Case #ChTMask
					itmp = GetGadgetData(#ChTMask)
					itmp + 1
					If itmp > 3
						itmp = 1
					EndIf
					SetGadgetData(#ChTMask, itmp)
					Select itmp
						Case 1
							SetGadgetState(#ChTMask, #PB_Checkbox_Unchecked)
							g_MaskType = 0
							SetGadgetText(#ChTMask, Lng(41))
						Case 2
							SetGadgetState(#ChTMask, #PB_Checkbox_Checked)
							g_MaskType = 1
							SetGadgetText(#ChTMask, Lng(42))
						Case 3
							SetGadgetState(#ChTMask, #PB_Checkbox_Inbetween)
							g_MaskType = -1
							SetGadgetText(#ChTMask, Lng(43))
					EndSelect


					Case #LV1, #LV2
; 						EvGad = GetActiveGadget()
						Select EventType()
							Case #PB_EventType_RightClick
								If IsGadget(EvGad) And GetGadgetState(EvGad) <> -1
									DisplayPopupMenu(#MenuCont, WindowID(#Window))
								EndIf
						EndSelect
					Case #Empty
						ff = 0
						EmptyFolders(#StrG1, #LV1)
						EmptyFolders(#StrG2, #LV2)
					Case #ChAll1
						ChAll(#LV1, #ChAll1)
					Case #ChAll2
						ChAll(#LV2, #ChAll2)
					Case #Open1
						tmp$ = PathRequester(Lng(20), GetHomeDirectory())
						If tmp$
							SetGadgetText(#StrG1, tmp$)
						EndIf
					Case #Open2
						tmp$ = PathRequester(Lng(20), GetHomeDirectory())
						If tmp$
							SetGadgetText(#StrG2, tmp$)
						EndIf
					Case #Scan
						ff = 1
						Scan()
					Case #Copy1
						CopyDel(1, #LV1, #LV2, #StrG1, #StrG2)
					Case #Copy2
						CopyDel(1, #LV2, #LV1, #StrG2, #StrG1)
					Case #Del1
						CopyDel(0, #LV1, #LV2, #StrG1, #StrG2)
					Case #Del2
						CopyDel(0, #LV2, #LV1, #StrG2, #StrG1)

;- Цикл ресайз
					Case #Container1
						If EventType() = #PB_EventType_Resize
							w1 = GadgetWidth(#Container1)
							h1 = GadgetHeight(#Container2)
							ResizeGadget(#Copy1, w1-48, h1 - 34, #PB_Ignore, #PB_Ignore)
							ResizeGadget(#Del1, w1-88, h1 - 34, #PB_Ignore, #PB_Ignore)

							CompilerSelect #PB_Compiler_OS
								CompilerCase #PB_OS_Windows
									ResizeGadget(#ChAll1, w1-110, h1 - 34, #PB_Ignore, #PB_Ignore)
								CompilerCase #PB_OS_Linux
									ResizeGadget(#ChAll1, w1-130, h1 - 34, #PB_Ignore, #PB_Ignore)
							CompilerEndSelect
							ResizeGadget(#Open1, w1-49, #PB_Ignore, #PB_Ignore, #PB_Ignore)
							ResizeGadget(#StrG1, #PB_Ignore, #PB_Ignore, w1-63, #PB_Ignore)
							ResizeGadget(#LV1, #PB_Ignore, #PB_Ignore, w1-20, h1 - 76)
							ResizeGadget(#StrMask, #PB_Ignore, h1 - 34,  (w1 - 130) / 2, #PB_Ignore)
							ResizeGadget(#ChTMask, (w1 - 130) / 2 + 15, h1 - 34, (w1 - 130) / 2, #PB_Ignore)

						EndIf
					Case #Container2
						If EventType() = #PB_EventType_Resize
							w2 = GadgetWidth(#Container2)
							h2 = GadgetHeight(#Container2)
							ResizeGadget(#Copy2, #PB_Ignore, h2 - 34, #PB_Ignore, #PB_Ignore)
							ResizeGadget(#Del2, #PB_Ignore, h2 - 34, #PB_Ignore, #PB_Ignore)
							ResizeGadget(#ChAll2, #PB_Ignore, h2 - 34, #PB_Ignore, #PB_Ignore)
							ResizeGadget(#Open2, w2-49, #PB_Ignore, #PB_Ignore, #PB_Ignore)
							ResizeGadget(#StrG2, #PB_Ignore, #PB_Ignore, w2-63, #PB_Ignore)
							ResizeGadget(#LV2, #PB_Ignore, #PB_Ignore, w2-20, h2 - 76)
							ResizeGadget(#btnMenuSel, w2 - 56, h2 - 34, #PB_Ignore, #PB_Ignore)
; 							CompilerIf  #PB_Compiler_OS = #PB_OS_Linux
							CompilerIf  #PB_Compiler_OS = #PB_OS_Linux
								ResizeGadget(#ChFind, #PB_Ignore, h2 - 34, #PB_Ignore, #PB_Ignore)
							CompilerEndIf
						EndIf
				EndSelect
			Case #PB_Event_SizeWindow
				w = WindowWidth(#Window)
				h = WindowHeight(#Window)
				ww2 = w  / 2
; 				Debug h
				ResizeGadget(#Splitter, #PB_Ignore, #PB_Ignore, w, h - 39)
; 				ResizeGadget(#Container1, #PB_Ignore, #PB_Ignore, w/2, h - 39)
				ResizeGadget(#Scan, w - 80, h - 38, #PB_Ignore, #PB_Ignore)
				ResizeGadget(#Empty, w - 120, h - 38, #PB_Ignore, #PB_Ignore)
				ResizeGadget(#Cmb, #PB_Ignore, h - 38, ww2 - 20, #PB_Ignore)
				ResizeGadget(#StatusBar, ww2, h - 38, ww2 - 120, #PB_Ignore)

			Case #PB_Event_CloseWindow
				If isINI And OpenPreferences(ini$, #PB_Preference_GroupSeparator | #PB_Preference_NoSpace)
					If PreferenceGroup("Set")
						If GetWindowState(#Window) = #PB_Window_Maximize
							itmp = 1
						Else
							itmp = 0
						EndIf
						If wm <> itmp
							WritePreferenceInteger("wm", itmp)
						EndIf
						If (ww <> w Or wh <> h) And itmp = 0
							WritePreferenceInteger("wh", h)
							WritePreferenceInteger("ww", w)
						EndIf
					EndIf
					ClosePreferences()
				EndIf

				CloseWindow(#Window)
				Break
		EndSelect
	ForEver
EndIf





Procedure IsLatin(*text)
    Protected flag = #True, *c.Character = *text

    If *c = 0 Or *c\c = 0
        ProcedureReturn 0
    EndIf

    Repeat
        If Not ((*c\c >= '0' And *c\c <= '9') Or (*c\c >= 'a' And *c\c <= 'z') Or (*c\c >= 'A' And *c\c <= 'Z') Or *c\c = '_')
            flag = #False
            Break
        EndIf
        *c + SizeOf(Character)
    Until Not *c\c

    ProcedureReturn flag
EndProcedure


Procedure ReadMask()
	Protected itmp

	g_Mask$ = GetGadgetText(#StrMask)
	itmp = GetGadgetState(#ChTMask)
; 	Debug itmp & #PB_Checkbox_Inbetween
; 	Debug itmp & #PB_Checkbox_Unchecked
; 	Debug itmp & #PB_Checkbox_Checked
	If (itmp & #PB_Checkbox_Inbetween) = -1
		g_MaskType = -1
	ElseIf itmp & #PB_Checkbox_Unchecked
		g_MaskType = 0
	ElseIf itmp & #PB_Checkbox_Checked
		g_MaskType = 1
	EndIf
EndProcedure


Procedure WritingValues()
	WritePreferenceInteger("Mode" , GetGadgetState(#Cmb))
	WritePreferenceString("Path1" , GetGadgetText(#StrG1))
	WritePreferenceString("Path2" , GetGadgetText(#StrG2))
	WritePreferenceString("Mask" , g_Mask$)
	WritePreferenceInteger("Tmask" , g_MaskType)
EndProcedure


Procedure AddedSample()
	Protected tmp$, Name$, KeyName$, IsNotFind = 1, i, IsLatin
	Protected NewMap GroupsMap()
	If isINI
		Name$ = InputRequester(Lng(28), "", "")
		If Asc(Name$)
; 			ReplaceString(Name$, " ", "_", #PB_String_InPlace)
			If OpenPreferences(ini$, #PB_Preference_GroupSeparator | #PB_Preference_NoSpace)
				ReadMask()
				IsLatin = IsLatin(@Name$)
; 				If IsLatin
					ExaminePreferenceGroups()
					While NextPreferenceGroup()
						tmp$ = PreferenceGroupName()
; 						Debug tmp$
						If FindMapElement(GroupsMap() , tmp$)
							GroupsMap(tmp$) + 1
						Else
							AddMapElement(GroupsMap() , tmp$)
							GroupsMap(tmp$) = 1
						EndIf

						If tmp$ = Name$
							If MessageRequester("Перезаписать?", "Имя уже существует, перезаписать?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
								PreferenceGroup(Name$)
								WritingValues()
							EndIf
							IsNotFind = 0
							Break
						EndIf
					Wend
; 				EndIf

; 					невозможно таким образом отследить дубликат группы, так как ExaminePreferenceGroups игнорирует дубликаты
; 					ForEach GroupsMap()
; 						Debug MapKey(GroupsMap())
; 						Debug GroupsMap()
; 						If GroupsMap() > 1
; 							MessageRequester(Lng(34), "Повторяется группа: " + MapKey(GroupsMap()))
; 						EndIf
; 					Next

				If IsNotFind
					ExaminePreferenceGroups()
					While NextPreferenceGroup()
						tmp$ = PreferenceGroupName()
						If tmp$ <> "Set"
							PreferenceGroup(tmp$)
							KeyName$ = ReadPreferenceString("Name", "")
							If Asc(KeyName$) And KeyName$ = Name$
								If MessageRequester("Перезаписать?", "Имя уже существует, перезаписать?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
									WritingValues()
								EndIf
								IsNotFind = 0
								Break
							EndIf
						EndIf
					Wend
				EndIf

				If IsNotFind
					If IsLatin
						PreferenceGroup(Name$)
					Else
						i = 0
						Repeat
; 							tmp$ = Str(Random(9999999))
							i + 1
							tmp$ = Str(i)
						Until Not FindMapElement(GroupsMap() , tmp$)
						PreferenceGroup(tmp$)
						WritePreferenceString("Name", Name$)
					EndIf
					WritingValues()
					mn1 + 1
					MenuItem(mn1, Name$)
				EndIf


				ClosePreferences()
			EndIf
		EndIf
	EndIf
EndProcedure


Procedure ReadingValues()
	SetGadgetText(#StrG1, ReadPreferenceString("Path1", ""))
	SetGadgetText(#StrG2, ReadPreferenceString("Path2", ""))
	SetGadgetState(#Cmb, ReadPreferenceInteger("Mode", 3))
; 	RemAttrib = ReadPreferenceInteger("RemAttrib", 0)
	g_Mask$ = ReadPreferenceString("Mask", "")
	SetGadgetText(#StrMask, g_Mask$)
	g_MaskType = ReadPreferenceInteger("Tmask", 0)
	Select g_MaskType
		Case 0
			SetGadgetState(#ChTMask, #PB_Checkbox_Unchecked)
			SetGadgetText(#ChTMask, Lng(41))
			SetGadgetData(#ChTMask, 1)
		Case 1
			SetGadgetState(#ChTMask, #PB_Checkbox_Checked)
			SetGadgetText(#ChTMask, Lng(42))
			SetGadgetData(#ChTMask, 2)
		Case -1
			SetGadgetState(#ChTMask, #PB_Checkbox_Inbetween)
			SetGadgetText(#ChTMask, Lng(43))
			SetGadgetData(#ChTMask, 3)
	EndSelect
EndProcedure


Procedure GetSetting(em)
	Protected tmp$, Name$, KeyName$, IsNotFind = 1
	Name$ = GetMenuItemText(#MenuSel, em)
	If isINI And OpenPreferences(ini$)
		ExaminePreferenceGroups()
		While NextPreferenceGroup()
			If PreferenceGroupName() = Name$
				PreferenceGroup(Name$)
				ReadingValues()
				IsNotFind = 0
				Break
			EndIf
		Wend
		If IsNotFind
			ExaminePreferenceGroups()
			While NextPreferenceGroup()
				tmp$ = PreferenceGroupName()
				If tmp$ <> "Set"
					PreferenceGroup(tmp$)
					KeyName$ = ReadPreferenceString("Name", "")
					If Asc(KeyName$) And KeyName$ = Name$
						ReadingValues()
						Break
					EndIf
				EndIf
			Wend
		EndIf

		ClosePreferences()
	EndIf
EndProcedure

Procedure OpenFileMenu(LV, StrG, mode)
	Protected itmp, tmp$
	itmp = GetGadgetState(LV)
	If itmp <> -1
		tmp$ = GetGadgetText(StrG) + GetGadgetItemText(LV , itmp)
		If mode = 1
			CompilerSelect #PB_Compiler_OS
			    CompilerCase #PB_OS_Windows
					RunProgram(tmp$)
			    CompilerCase #PB_OS_Linux
					RunProgram("xdg-open", Chr(34) + tmp$ + Chr(34), GetPathPart(tmp$))
			CompilerEndSelect
		ElseIf mode = 0
			CompilerSelect #PB_Compiler_OS
			    CompilerCase #PB_OS_Windows
					RunProgram("explorer.exe", "/select," + Chr(34) + tmp$ + Chr(34), "")
			    CompilerCase #PB_OS_Linux
			    	; 					RunProgram("nemo", Chr(34) + tmp$ + Chr(34), "")
			    	Select FileSize(tmp$)
			    		Case -2
			    			RunProgram("xdg-open", Chr(34) + tmp$ + Chr(34), "")
			    		Case -1
			    		Default
			    			RunProgram("xdg-open", Chr(34) + GetPathPart(tmp$) + Chr(34), "")
			    	EndSelect
			CompilerEndSelect
		EndIf
	EndIf
EndProcedure


Procedure EmptyFoldersSearch(Dir.s, List Files.s())
	Protected ID, EntryName.s, d, z
	ID = ExamineDirectory(#PB_Any, Dir, "*.*")
	d = 0
	If ID
		Repeat
			z = NextDirectoryEntry(ID)
			d + 1
			If z
				EntryName=DirectoryEntryName(ID)
				If EntryName = "." Or EntryName = ".."
					Continue
				EndIf
				If DirectoryEntryType(ID) = #PB_DirectoryEntry_Directory ; если путь является папкой, то
					EmptyFoldersSearch(Dir + "/" + EntryName, Files())			 ; рекурсивный вызов во вложенную папку
				EndIf
			Else
				If d = 3 And AddElement(Files())
					Files() = Dir
				EndIf
				d = 0
				Break
			EndIf
		ForEver
		FinishDirectory(ID)
	EndIf
EndProcedure

Procedure EmptyFolders(StrG, LV)
	Protected Path$, LenPath
	Protected NewList Files.s()
	ClearGadgetItems(LV)
	Path$ = GetGadgetText(StrG)
	Path$ = RTrim(Path$, #PS$)
	LenPath = Len(Path$) + 1
	If Asc(Path$)
		EmptyFoldersSearch(Path$, Files())
		ForEach Files()
			AddGadgetItem(LV, -1, Mid(Files(), LenPath))
		Next
	EndIf
	ClearList(Files())
EndProcedure


Procedure ChAll(LV, ChAll)
	Protected CountLV, i

	CountLV = CountGadgetItems(LV)
	If GetGadgetState(ChAll) = #PB_Checkbox_Checked
		For i = 0 To CountLV - 1
			SetGadgetItemState(LV, i, #PB_ListIcon_Checked)
		Next
	Else
		For i = 0 To CountLV - 1
			SetGadgetItemState(LV, i, #PB_Checkbox_Unchecked)
		Next
	EndIf
EndProcedure


Procedure CompareProg2(LV, StrG1, StrG2, flag = 0)
	Protected Path1$, Path2$
	Path1$ = GetGadgetText(LV)
	Path2$ = RTrim(GetGadgetText(StrG2), #PS$) + Path1$
	If FileSize(Path2$) > -1
		Path1$ = RTrim(GetGadgetText(StrG1), #PS$) + Path1$
		If flag
			RunProgram(CompareProg$, Chr(34) + Path2$ + Chr(34) + " " + Chr(34) + Path1$ + Chr(34), "")
		Else
			RunProgram(CompareProg$, Chr(34) + Path1$ + Chr(34) + " " + Chr(34) + Path2$ + Chr(34), "")
		EndIf
; 		MessageRequester("1", Chr(34) + Path1$ + Chr(34) + " " + Chr(34) + Path2$ + Chr(34))
	Else
		MessageRequester("", Lng(31))
	EndIf
EndProcedure

Procedure CompareProg(mode)
	Protected Path1$, Path2$;, ActiveGadget
	If mode
		Path1$ = RTrim(GetGadgetText(#StrG1), #PS$) + GetGadgetText(#LV1)
		Path2$ = RTrim(GetGadgetText(#StrG2), #PS$) + GetGadgetText(#LV2)
		RunProgram(CompareProg$, Chr(34) + Path1$ + Chr(34) + " " + Chr(34) + Path2$ + Chr(34), "")
; 		MessageRequester("2", Chr(34) + Path1$ + Chr(34) + " " + Chr(34) + Path2$ + Chr(34))
	Else
; 		ActiveGadget = GetActiveGadget()
; 		ActiveGadget = EvGad
; 		MessageRequester("ActiveGadget", Str(ActiveGadget))
		If EvGad = #LV1
			CompareProg2(#LV1, #StrG1, #StrG2)
		ElseIf EvGad = #LV2
			CompareProg2(#LV2, #StrG2, #StrG1, 1)
		EndIf
	EndIf
EndProcedure

Procedure CopyDel(mode, LV1, LV2, StrG1, StrG2)
	Protected Path1$, Path2$, CountLV, i, tmp$, Error$
	Path1$ = RTrim(GetGadgetText(StrG1), #PS$)
	Path2$ = RTrim(GetGadgetText(StrG2), #PS$)
	If mode
		If ff ; если режим файлов, а не копирование пустых папок
			CountLV = CountGadgetItems(LV1)
			For i = 0 To CountLV -1
				If GetGadgetItemState(LV1, i) & #PB_ListIcon_Checked
					tmp$ = GetGadgetItemText(LV1, i)
	; 				Debug Path2$ + tmp$
	; 				Debug GetPathPart(Path2$ + tmp$)
					If ForceDirectories(GetPathPart(Path2$ + tmp$))
; 						надо сначала снять атрибуты "только чтение" с файлов назначения, чтобы копирование было успешно
; 						If CopyFile(Path1$ + tmp$, Path2$ + tmp$) Or (RemAttrib And SetFileAttributes(Path2$ + tmp$ , #PB_FileSystem_Normal) And CopyFile(Path1$ + tmp$, Path2$ + tmp$))
						If CopyFile(Path1$ + tmp$, Path2$ + tmp$)
							SetGadgetItemState(LV1, i, #PB_Checkbox_Unchecked)
						Else
							Error$ + Path1$ + tmp$ + #LF$
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	Else
		CountLV = CountGadgetItems(LV1)
		For i = 0 To CountLV -1
			If GetGadgetItemState(LV1, i) & #PB_ListIcon_Checked
				tmp$ = GetGadgetItemText(LV1, i)
				If ff
					If DeleteFile(Path1$ + tmp$, #PB_FileSystem_Force)
						SetGadgetItemState(LV1, i, #PB_Checkbox_Unchecked)
					Else
						Error$ + Path1$ + tmp$ + #LF$
					EndIf
				Else
; 					удаление пустых папок
					If DeleteDirectory(Path1$ + tmp$, "", #PB_FileSystem_Force)
						SetGadgetItemState(LV1, i, #PB_Checkbox_Unchecked)
					Else
						Error$ + Path1$ + tmp$ + #LF$
					EndIf
				EndIf
			EndIf
		Next
	EndIf

	If Asc(Error$)
		MessageRequester(Lng(21), Error$)
	EndIf
EndProcedure


Procedure ReadListFiles(LV)
	Protected i, tmp$, LenF, *Point, Result.string, NewList f.s()
	For i = 0 To CountGadgetItems(LV) -1
		tmp$ = GetGadgetItemText(LV, i)
		If AddElement(f())
			f() = tmp$
			LenF + Len(tmp$)
		EndIf
	Next
	LenF + ListSize(f()) * 2
	Result\s = Space(LenF)
	*Point = @Result\s
	ForEach f()
		CopyMemoryString(f() + #CRLF$, @*Point)
	Next
	SetClipboardText(Result\s)
EndProcedure


Procedure Compare(List Files1.s(), List Files2.s(), mode)
	Protected i
	Protected NewMap CompareFiles.i()

	ForEach Files2()
		CompareFiles(Files2()) + 1
	Next
	ForEach Files1()
		CompareFiles(Files1()) - 1
	Next

	ClearList(Files1())
	ClearList(Files2())

; 	запрет перерисовки ускоряет наполнение в 2 раза при 5000 элементов списка.
	CompilerIf  #PB_Compiler_OS = #PB_OS_Windows
		SendMessage_(hListView1, #WM_SETREDRAW, 0, 0)
		SendMessage_(hListView2, #WM_SETREDRAW, 0, 0)
	CompilerEndIf

	Select mode
		Case 0 To 3
			ForEach CompareFiles()
				If CompareFiles() < 0
					If AddElement(Files1())
; 						AddGadgetItem(#LV1, -1, MapKey(CompareFiles()))
						Files1() = MapKey(CompareFiles())
					EndIf
				ElseIf CompareFiles() > 0
					If AddElement(Files2())
; 						 AddGadgetItem(#LV2, -1, MapKey(CompareFiles()))
						Files2() = MapKey(CompareFiles())
					EndIf
				EndIf
			Next

			SortList(Files1(), #PB_Sort_Ascending | #PB_Sort_NoCase)
			SortList(Files2(), #PB_Sort_Ascending | #PB_Sort_NoCase)
			ForEach Files1()
				AddGadgetItem(#LV1, -1, Files1())
			Next
			ForEach Files2()
				AddGadgetItem(#LV2, -1, Files2())
			Next

		Case 4 To 7
			ForEach CompareFiles()
				If CompareFiles() = 0
					If AddElement(Files1())
						Files1() = MapKey(CompareFiles())
					EndIf
				EndIf
			Next
			SortList(Files1(), #PB_Sort_Ascending | #PB_Sort_NoCase)
			ForEach Files1()
				AddGadgetItem(#LV1, -1, Files1())
				AddGadgetItem(#LV2, -1, Files1())
			Next
	EndSelect

	CompilerIf  #PB_Compiler_OS = #PB_OS_Windows
		SendMessage_(hListView1, #WM_SETREDRAW, 1, 0)
		SendMessage_(hListView2, #WM_SETREDRAW, 1, 0)
	CompilerEndIf


	If CountGadgetItems(#LV1)
		CompilerIf  #PB_Compiler_OS = #PB_OS_Windows
; 			Выравниваем 3 колонки по содержимому
			For i = 0 To 2
				SetGadgetItemAttribute(#LV1 , 0 , #PB_ListIcon_ColumnWidth , -1, i)
			Next
		CompilerEndIf
		HideGadget(#ChAll1, #False)
	Else
		HideGadget(#ChAll1, #True)
	EndIf

	If CountGadgetItems(#LV2)
		CompilerIf  #PB_Compiler_OS = #PB_OS_Windows
; 			Выравниваем 3 колонки по содержимому
			For i = 0 To 2
				SetGadgetItemAttribute(#LV2 , 0 , #PB_ListIcon_ColumnWidth , -1, i)
			Next
		CompilerEndIf
		HideGadget(#ChAll2, #False)
	Else
		HideGadget(#ChAll2, #True)
	EndIf
EndProcedure

Procedure Scan()
	Protected Path1$, Path2$, StartTime, FindSub, Len1, Len2
	Protected NewList Files1.s()
	Protected NewList Files2.s()
	Protected mode = GetGadgetState(#Cmb)
	; 	Debug mode

	ClearGadgetItems(#LV1) ; Очищает ListIconGadget
	ClearGadgetItems(#LV2)
	SetGadgetState(#ChAll1, #PB_Checkbox_Unchecked)
	SetGadgetState(#ChAll2, #PB_Checkbox_Unchecked)

	Path1$ = RTrim(GetGadgetText(#StrG1), #PS$)
	Path2$ = RTrim(GetGadgetText(#StrG2), #PS$)
	If Not Asc(Path1$) Or Not Asc(Path2$)
; 		пути пусты
		MessageRequester(Lng(34), Lng(35))
		ProcedureReturn
	EndIf
	If Path1$ = Path2$
; 		пути одинаковы
		MessageRequester(Lng(34), Lng(36))
		ProcedureReturn
	EndIf
	If FileSize(Path1$) <> -2
; 		путь не существует
		MessageRequester(Lng(34), Lng(37) + " (1).")
		ProcedureReturn
	EndIf
	If FileSize(Path2$) <> -2
		; 		путь не существует
		MessageRequester(Lng(34), Lng(37) + " (2).")
		ProcedureReturn
	EndIf

	Len1 = Len(Path1$)
	Len2 = Len(Path2$)
	If Len1 > Len2 And Left(Path1$, Len2 + 1) = Path2$ + #PS$
		FindSub = 1
	ElseIf Len1 < Len2 And Left(Path2$, Len1 + 1) = Path1$ + #PS$
		FindSub = 1
	EndIf
	If FindSub And MessageRequester(Lng(38), Lng(39), #PB_MessageRequester_YesNo) = #PB_MessageRequester_No
		ProcedureReturn
	EndIf

	StartTime=ElapsedMilliseconds() ; метка времени, запоминаем
; 	SetGadgetText(#StatusBar, "Сканирование каталога 1")


	ReadMask()

	CompilerSelect #PB_Compiler_OS
	    CompilerCase #PB_OS_Windows
			FileSearch(Files1(), Path1$, g_Mask$, g_MaskType, 130, mode)
		CompilerCase #PB_OS_Linux
			If GetGadgetState(#ChFind) = #PB_Checkbox_Checked
				FileSearch_find(Files1(), Path1$, g_Mask$, g_MaskType, 130, mode)
			Else
				FileSearch(Files1(), Path1$, g_Mask$, g_MaskType, 130, mode)
			EndIf
	CompilerEndSelect

; 		ForEach Files1()
; 			Debug Files1()
; 		Next

; 	SetGadgetText(#StatusBar, "Сканирование каталога 2")
	CompilerSelect #PB_Compiler_OS
	    CompilerCase #PB_OS_Windows
			FileSearch(Files2(), Path2$, g_Mask$, g_MaskType, 130, mode)
	    CompilerCase #PB_OS_Linux
			If GetGadgetState(#ChFind) = #PB_Checkbox_Checked
				FileSearch_find(Files2(), Path2$, g_Mask$, g_MaskType, 130, mode)
			Else
				FileSearch(Files2(), Path2$, g_Mask$, g_MaskType, 130, mode)
			EndIf
	CompilerEndSelect

; 	SetGadgetText(#StatusBar, "Сравнение")
	Compare(Files1(), Files2(), mode)

CompilerIf  #PB_Compiler_OS = #PB_OS_Windows
	; 	сортировка списков
	If ListSize(Files1())
		SortOrder1 = -1
		indexSort1 = 0
		UpdatelParam(hListView1)
; 		SendMessage_(hListView1, #LVM_SORTITEMS, indexSort1, @CompareFunc())
; 		UpdatelParam(hListView1)
; 		UpdateWindow_(hListView1) ; без неё работает
; 		SortOrder1 = -SortOrder1
	EndIf

	If ListSize(Files2())
		SortOrder2 = -1
		indexSort2 = 0
		UpdatelParam(hListView2)
	; 	indexSort = 3
; 		SendMessage_(hListView2, #LVM_SORTITEMS, indexSort2, @CompareFunc())
; 		UpdatelParam(hListView2)
; 		UpdateWindow_(hListView2) ; без неё работает
; 		SortOrder2 = -SortOrder2
	EndIf
	; 	сортировка списков => конец
CompilerEndIf

	StartTime=ElapsedMilliseconds()-StartTime ; сохраняем разницу
	SetGadgetText(#StatusBar, Lng(22) + FormTime(StartTime) + Lng(23) + CountGadgetItems(#LV1) + ":" + CountGadgetItems(#LV2))
EndProcedure

; MaskType
; 	0 - wildcard (for example Mask$ = "*.exe")
; 	1 - listing file extensions (for example Mask$ = "pb,exe")
; 	-1 - excluding the listed file extensions (for example Mask$ = "pb,exe")

; удалённые флаги
; 	3 - regular expression (for example Mask$ = "IMG[_\d].jpg")
; 	-3 - excluding files matching a regular expression (for example Mask$ = "IMG[_\d].jpg")

Procedure FileSearch(List Files.s(), sPath.s, Mask$ = "*", MaskType = 0, depth=130, mode = 0)

	Protected sName.s, c = 0, LenSPath, tmp$, itmp
	Protected Dim hFind(depth)
	Protected Dim aPath.s(depth)

	Protected NewList Ext.s()
	Protected hRE, Mask2$, isNotFind, flgAddFile

	If mode > 3
		mode - 4
	EndIf

	Select MaskType
		Case 0
; 			Mask2$ = Mask$
			Mask2$ = ""
		Case 1, -1
			Mask$ = ReplaceString(Mask$, " ", "")
			Mask$ = LCase(Mask$)
			SplitL(Mask$, Ext(), ",")
; 		Case 3, -3
; 			hRE = CreateRegularExpression(#PB_Any, Mask$, #PB_RegularExpression_NoCase)
; 			If Not hRE
; 				ProcedureReturn 2
; 			EndIf
	EndSelect
; 	Mask$ = CorrectMask(Mask$)

	If  Right(sPath, 1) <> #PS$
		sPath + #PS$
	EndIf
	LenSPath = Len(sPath)

	aPath(c) = sPath
	hFind(c) = ExamineDirectory(#PB_Any, sPath, Mask2$)
	If Not hFind(c)
		ProcedureReturn 1
	EndIf

	Repeat
		While NextDirectoryEntry(hFind(c))
			sName=DirectoryEntryName(hFind(c))
			If sName = "." Or sName = ".."
				Continue
			EndIf
			If DirectoryEntryType(hFind(c)) = #PB_DirectoryEntry_Directory
				If c >= depth
					Continue
				EndIf
				sPath = aPath(c)
				c + 1
				aPath(c) = sPath + sName + #PS$
				hFind(c) = ExamineDirectory(#PB_Any, aPath(c), Mask2$)
				If Not hFind(c)
					c - 1
				EndIf
			Else


				flgAddFile = 0
				Select MaskType
					Case 0
						flgAddFile = AddElement(Files())
					Case 1
						ForEach Ext()
							If LCase(GetExtensionPart(sName)) = Ext()
								flgAddFile = AddElement(Files())
								Break
							EndIf
						Next
; 					Case 3
; 						If MatchRegularExpression(hRE, sName)
; 							flgAddFile = AddElement(Files())
; 						EndIf
; 					Case -3
; 						If Not MatchRegularExpression(hRE, sName)
; 							flgAddFile = AddElement(Files())
; 						EndIf
					Case -1
						isNotFind = 1
						ForEach Ext()
							If LCase(GetExtensionPart(sName)) = Ext()
								isNotFind = 0
								Break
							EndIf
						Next
						If isNotFind
							flgAddFile = AddElement(Files())
						EndIf
				EndSelect
				If flgAddFile
					tmp$ = aPath(c) + sName
					Select mode
						Case 0 ; путь
							Files() = tmp$
						Case 1 ; путь размер
							Files() = tmp$ + Chr(10) + Str(FileSize(tmp$))
						Case 2 ; путь дата
							Files() = tmp$ + Chr(10) + Chr(10) + FormatDate("%yyyy.%mm.%dd %hh:%ii:%ss", GetFileDate(tmp$, #PB_Date_Modified))
						Case 3 ; путь размер дата
							Files() = tmp$ + Chr(10) + Str(FileSize(tmp$)) + Chr(10) + FormatDate("%yyyy.%mm.%dd %hh:%ii:%ss", GetFileDate(tmp$, #PB_Date_Modified))
					EndSelect
				EndIf
			EndIf
		Wend
		FinishDirectory(hFind(c))
		c - 1
	Until c < 0

; 	обрезаем пути, делая их относительными
	ForEach Files()
		Files() = Mid(Files(), LenSPath)
	Next

; 	If MaskType = 3 Or MaskType = -3
; 		FreeRegularExpression(hRE)
; 	EndIf
	ProcedureReturn 0
EndProcedure


; wilbert
; https://www.purebasic.fr/english/viewtopic.php?p=486382#p486382
Procedure SplitL(String.s, List StringList.s(), Separator.s = " ")

	Protected S.String, *S.Integer = @S
	Protected.i p, slen
	slen = Len(Separator)
	ClearList(StringList())

	*S\i = @String
	Repeat
		AddElement(StringList())
		p = FindString(S\s, Separator)
		StringList() = PeekS(*S\i, p - 1)
		*S\i + (p + slen - 1) << #PB_Compiler_Unicode
	Until p = 0
	*S\i = 0

EndProcedure


CompilerIf  #PB_Compiler_OS = #PB_OS_Linux

Procedure FileSearch_find(List Files.s(), sPath.s, Mask$ = "*", MaskType = 0, depth=130, mode = 0)
	Protected tmp, printf$, Len, Result.string, *Point;, shell$, comstr$, string$

	If mode > 3
		mode - 4
	EndIf
	Select mode
		Case 0 ; путь
			printf$ = "-printf '/%P\n" ; в итоге \n не попадает в результат
		Case 1 ; путь размер
			printf$ = "-printf '/%P" + Chr(1) + "%s\n"
; 			printf$ = "-printf '%P" + Chr(10) + "%s"
		Case 2 ; путь дата
			printf$ = "-printf '/%P" + Chr(1) + Chr(1) + "%TF %TH:%TM\n"
;			printf$ = "-printf '%P" + Chr(10) + "%TF"
		Case 3 ; путь размер дата
; 			printf$ = "-printf '%P" + Chr(10) + "%s" + Chr(10) + "%TF"
			printf$ = "-printf '/%P" + Chr(1) + "%s" + Chr(1) + "%TF %TH:%TM\n"
	EndSelect

	Mask$ = ReplaceString(Mask$, " ", "")
	Select MaskType
		Case 0
			If Mask$ = "" Or Mask$ = "*.*"
				Mask$ = ""
			ElseIf Mask$ = "*"
				Mask$ = " -regex '^[^.]*$'"
			Else
				Mask$ = " -iname " + Mask$
			EndIf
		Case 1
			Mask$ = " -iregex '^.*?\.\(" + ReplaceString(Mask$, ",", "\|") + "\)$'"
		Case -1
			Mask$ = " -not -iregex '^.*?\.\(" + ReplaceString(Mask$, ",", "\|") + "\)$'"
	EndSelect

; 	string$ = "'" + sPath + "' -type f " + printf$ + "'"
; 	shell$ = "bash"
; 	comstr$ = ~"-c \"find %s 2>&1\""
; 	tmp = RunProgram(shell$, ReplaceString(comstr$ , "%s" , string$), "", #PB_Program_Open | #PB_Program_Read)
	If MaskType
		tmp = RunProgram("bash", ~"-c \"find '" + sPath + "'" + Mask$ + " -type f " + printf$ + ~"' 2>&1\"", "", #PB_Program_Open | #PB_Program_Read)
	Else
		tmp = RunProgram("bash", ~"-c \"find '" + sPath + "'" + Mask$ + " -type f " + printf$ + ~"' 2>&1\"", "", #PB_Program_Open | #PB_Program_Read)
	EndIf
	If tmp
		While ProgramRunning(tmp)
			If AvailableProgramOutput(tmp)
				If AddElement(Files())
					Files() = ReadProgramString(tmp)
				EndIf
			EndIf
		Wend
		CloseProgram(tmp)

; 		Подсчитываем размер
		ForEach Files()
			Len + Len(Files())
		Next
		Len+ListSize(Files()) ; добавляем число переносов строк #CR$ по количеству данных

		Result\s = Space(Len)
		*Point = @Result\s
		ForEach Files()
			CopyMemoryString(Files()+Chr(2), @*Point)
		Next
; 		ReplaceString(Result\s, #LF$, #CR$, #PB_String_InPlace) ; теоретически надо заменять на #CR$+#CR$, но достаточно переписать первый символ
; 		Result\s = RTrim(Result\s, Chr(2))
; 		Debug "FindString = " + Str(FindString(Result\s, #LF$)) ; не найдено

		Result\s = Left(Result\s, Len(Result\s) - 1) ; заранее известен лишний символ добавляемый в перечислении CopyMemoryString()
		If mode
			ReplaceString(Result\s, Chr(1), #LF$, #PB_String_InPlace)
		EndIf
; 		printf$ = ""
; 		For Len = 1 To 10
; 			printf$ + "," + Str(Asc(Mid(Result\s, Len, 1)))
; 		Next
; 		SetClipboardText(printf$)
; 		Debug "-_________________________"
; 		Debug "|" +Result\s + "|"

; 		внутри функции Files() очищается и заполняется новыми данными
		SplitL(Result\s, Files(), Chr(2))
		If ListSize(Files()) = 1 And Files() = ""
			ClearList(Files())
		EndIf
; 		Debug ListSize(Files())
; 		ForEach Files()
; 			Debug "|" + Files() + "|"
; 		Next

	EndIf
EndProcedure

CompilerEndIf


Procedure.s FormTime(time)
	Protected res$, h, m, s, ms
	If time >= 3600000
		h = time/3600000
		time % 3600000
		res$ + Str(h) + Lng(24)
	EndIf
	If time >= 60000
		m = time/60000
		time % 60000
		res$ + Str(m) + Lng(25)
	EndIf
	If time >= 1000
		s = time/1000
		time % 1000
		res$ + Str(s) + Lng(26)
	EndIf
	If time > 0
		res$ + Str(time) + Lng(27)
	EndIf
	ProcedureReturn res$
EndProcedure

;==================================================================
;
; Author:    ts-soft
; Date:       March 5th, 2010
; Explain:
;     modified version from IBSoftware (CodeArchiv)
;     on vista and above check the Request for "User mode" or "Administrator mode" in compileroptions
;    (no virtualisation!)
; Модификация AZJIO всвязи с особыми условиями: так как функция работает в цикле, то убираем проверку слеша, добавил снова
;==================================================================
Procedure ForceDirectories(Dir.s)
	Static tmpDir.s, Init
	Protected result

	If Asc(Dir)
		If Not Init
			tmpDir = Dir
			Init   = #True
		EndIf
; 		Dir = RTrim(Dir, #PS$)
		If (Right(Dir, 1) = #PS$)
			Dir = Left(Dir, Len(Dir) - 1)
		EndIf
		If (Len(Dir) < 3) Or FileSize(Dir) = -2 Or GetPathPart(Dir) = Dir
			If FileSize(tmpDir) = -2
				result = #True
			EndIf
			tmpDir = ""
			Init = #False
			ProcedureReturn result
		EndIf
		ForceDirectories(GetPathPart(Dir))
		ProcedureReturn CreateDirectory(Dir)
	Else
		ProcedureReturn #False
	EndIf
EndProcedure



Procedure SaveFile_Buff(File.s, *Buff, Size)
	Protected Result = #False
	Protected ID = CreateFile(#PB_Any, File)
	If ID
		If WriteData(ID, *Buff, Size) = Size
			Result = #True
		EndIf
		CloseFile(ID)
	EndIf
	ProcedureReturn Result
EndProcedure
; IDE Options = PureBasic 6.00 LTS (Windows - x86)
; CursorPosition = 133
; FirstLine = 120
; Folding = -----f-
; Markers = 428
; EnableAsm
; EnableXP
; DPIAware
; UseIcon = Synchronization.ico
; Executable = Synchronization
; CompileSourceDirectory
; DisableCompileCount = 4
; EnableBuildCount = 0
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 1.3.7.%BUILDCOUNT
; VersionField2 = AZJIO
; VersionField3 = Synchronization
; VersionField4 = 1.3.7
; VersionField6 = Synchronization
; VersionField9 = AZJIO