
; http://purebasic.info/phpBB3ex/viewtopic.php?p=94488#p94488

EnableExplicit

Structure PB_ListIconItem
	UserData.i
EndStructure

#LVM_SETEXTENDEDLISTVIEWSTYLE = #LVM_FIRST + 54
#LVM_GETEXTENDEDLISTVIEWSTYLE = #LVM_FIRST + 55

Declare CompareFunc(*item1.PB_ListIconItem, *item2.PB_ListIconItem, lParamSort)
Declare UpdatelParam(hListView)
; Declare ForceSort()

; Procedure ForceSort()
; 	If indexSort < 3 Or indexSort > -1
; 		SendMessage_(hListView, #LVM_SORTITEMS, indexSort, @CompareFunc())
; 		UpdatelParam()
; 		SortOrder = -SortOrder
; 	EndIf
; EndProcedure

Procedure CompareFunc(*item1.PB_ListIconItem, *item2.PB_ListIconItem, lParamSort)
	Protected *Buffer1, *Buffer2, *Seeker1, *Seeker2, result.d, done, char1, char2, Num1.d, Num2.d
	#SizeChar = SizeOf(Character)
	#MemSize = 256
	*Buffer1 = AllocateMemory(#MemSize * #SizeChar)
	*Buffer2 = AllocateMemory(#MemSize * #SizeChar)
	result = 0
	lvi\iSubItem = lParamSort
	lvi\pszText = *Buffer1
	lvi\cchTextMax = #MemSize
	lvi\Mask = #LVIF_TEXT
	SendMessage_(hListView, #LVM_GETITEMTEXT, *item1\UserData, @lvi)
	lvi\pszText = *Buffer2
	SendMessage_(hListView, #LVM_GETITEMTEXT, *item2\UserData, @lvi)
	*Seeker1 = *Buffer1
	*Seeker2 = *Buffer2
	Select lParamSort
		Case 1 ; если колонка 1 то сравниваем как числа (иначе как строки без учёта регистра)
			Num1 = Val(PeekS(*Seeker1))
			Num2 = Val(PeekS(*Seeker2))
			If SortOrder = -1
				result = Round((Num1-Num2), #PB_Round_Down) * SortOrder
			Else
				result = Round((Num1-Num2), #PB_Round_Up) * SortOrder
			EndIf
		Case 2
			done = 1
			While done
				char1 = PeekC(*Seeker1)
				char2 = PeekC(*Seeker2)
				result = (char1-char2) * SortOrder
				If result<>0 Or (*Seeker1-*Buffer1)>(#MemSize - 1) * #SizeChar
					done = 0
				EndIf
				*Seeker1+ #SizeChar
				*Seeker2+ #SizeChar
			Wend
		Default
			done = 1
			While done
				char1 = Asc(UCase(Chr(PeekC(*Seeker1))))
				char2 = Asc(UCase(Chr(PeekC(*Seeker2))))
				result = (char1-char2) * SortOrder
				If result<>0 Or (*Seeker1-*Buffer1)>(#MemSize - 1) * #SizeChar
					done = 0
				EndIf
				*Seeker1+ #SizeChar
				*Seeker2+ #SizeChar
			Wend
	EndSelect
	FreeMemory(*Buffer1)
	FreeMemory(*Buffer2)
	ProcedureReturn result
EndProcedure

Procedure UpdatelParam(hListView)
	Protected i
	For i = 0 To SendMessage_(hListView, #LVM_GETITEMCOUNT, 0, 0) - 1
		SetGadgetItemData(GetDlgCtrlID_(hListView), i, i)
	Next
EndProcedure

Procedure MyWindowCallback(hwnd, uMsg, wParam, lParam)
	Protected result, *msg.NMHDR, *pnmv.NM_LISTVIEW
	result = #PB_ProcessPureBasicEvents
	If uMsg = #WM_NOTIFY
		*msg.NMHDR = lParam
		If *msg\hwndFrom = hListView1 And *msg\code = #LVN_COLUMNCLICK
			hListView = hListView1
			indexSort = indexSort1
			*pnmv.NM_LISTVIEW = lParam
			If indexSort<>*pnmv\iSubItem
				SortOrder1 = 1
			EndIf
			SortOrder = SortOrder1
			SendMessage_(*msg\hwndFrom, #LVM_SORTITEMS, *pnmv\iSubItem, @CompareFunc())
			UpdatelParam(*msg\hwndFrom)
			UpdateWindow_(*msg\hwndFrom) ; без неё работает
			indexSort1 = *pnmv\iSubItem
			SortOrder1 = -SortOrder
		ElseIf *msg\hwndFrom = hListView2 And *msg\code = #LVN_COLUMNCLICK
			hListView = hListView2
			indexSort = indexSort2
			*pnmv.NM_LISTVIEW = lParam
			If indexSort<>*pnmv\iSubItem
				SortOrder2 = 1
			EndIf
			SortOrder = SortOrder2
			SendMessage_(*msg\hwndFrom, #LVM_SORTITEMS, *pnmv\iSubItem, @CompareFunc())
			UpdatelParam(*msg\hwndFrom)
			UpdateWindow_(*msg\hwndFrom) ; без неё работает
			indexSort2 = *pnmv\iSubItem
			SortOrder2 = -SortOrder
		EndIf
	EndIf
	ProcedureReturn result
EndProcedure
; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 120
; FirstLine = 82
; Folding = -
; EnableXP
; UseIcon = ChkDskGui.ico
; Executable = ChkDskGui_x64.exe
; IncludeVersionInfo
; VersionField0 = 3.5.0.0
; VersionField2 = AZJIO
; VersionField3 = ChkDskGui
; VersionField4 = 3.5
; VersionField6 = ChkDskGui
; VersionField9 = AZJIO