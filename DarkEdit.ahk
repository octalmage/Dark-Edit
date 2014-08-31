#singleinstance, force
#MaxHotkeysPerInterval 200 ;Necessary to prevent a warning dialog while scrolling. 

OnMessage(0x200,"WM_MOUSEMOVE") 

all=0
main=1
starttop=0


mtog=1

Hotkey, ~alt, menutoggle  


open:
gui, color, black, black
gui, font, s12 c00FF00, Courier New
gui, add, edit,section vnewtext black w600 h400 HWNDhe1 +ES_AUTOHSCROLL -boder -VScroll -E0x200 -0x200000, %text%
gui,font, s12 c00ff00 bold , Webdings
gui, add, text,HWNDhe2 ys v1  garrow, % chr(053)
gui,font, s12 c00ff00 normal, Webdings
gui, add, text,HWNDhe3 garrow v2, % chr(053)
gui, add, text,HWNDhe4 garrow v3, % chr(054)
gui,font, s12 c00ff00 bold, Webdings
gui, add, text,HWNDhe5 garrow v4, % chr(054)
Gui, +Resize +MinSize



	Menu, FileMenu, Add, &Open    Ctrl+O, MenuFileOpen  ; See remarks below about Ctrl+O.
	Menu, FileMenu, Add, E&xit, MenuHandler
	Menu, HelpMenu, Add, &about, MenuHandler
	Menu, MyMenuBar, Add, &File, :FileMenu  ; Attach the two sub-menus that were created above.
	Menu, MyMenuBar, Add, &Help, :HelpMenu
	Gui, Menu, MyMenuBar





gosub SetAttach					;comment this line to disable Attach
Gui, Show,, DarkEdit
gui, +lastfound
thisid:=winexist()
if starttop
	controlsend, Edit1, {ctrl down}{home}{ctrl up},  ahk_id %thisid%
	
controlsend, Edit1, {end},  ahk_id %thisid%
	
Hotkey, IfWinActive, ahk_id %thisid%
Hotkey, f12, full  

Hotkey, IfWinActive, ahk_id %thisid%
Hotkey, WheelDown, wheel  

Hotkey, IfWinActive, ahk_id %thisid%
Hotkey, WheelUp, wheel  

Hotkey, IfWinActive, ahk_id %thisid%
Hotkey, esc, esc  


text:=


gosub full
return

SetAttach:
	Attach(he1, "x.5 h")
	Attach(he2, "x.5 r2")
	Attach(he3, "x.5  r2")
	Attach(he4, "x.5  r2")
	Attach(he5, "x.5  r2")
return

arrow:
	If A_GuiControl=2
		{
			controlsend, Edit1, {up},  ahk_id %thisid%
		}
		Else If A_GuiControl=3
		{
			controlsend, Edit1, {down},  ahk_id %thisid%
		}
		
			If A_GuiControl=1
		{
			controlsend, Edit1, {PgUp},  ahk_id %thisid%
		}
		Else If A_GuiControl=4
		{
			controlsend, Edit1, {PgDn},  ahk_id %thisid%
		}

	KeyWait, lbutton , t.6


	while (getkeystate("lbutton"))
	{
		If A_GuiControl=2
		{
			controlsend, Edit1, {up},  ahk_id %thisid%
		}
		Else If A_GuiControl=3
		{
			controlsend, Edit1, {down},  ahk_id %thisid%
		}
		sleep 50
	}

return

menutoggle:

	ToggleMenu(thisid)

return


full:
	If not full
	{
		gui, -border  -caption +toolwindow  +alwaysontop
		winmaximize, ahk_id %thisid%
		if all=1
		{
			SysGet, VirtualScreenWidth, 78
			SysGet, VirtualScreenHeight, 79
			gui 7: color, black
			gui 7: -border -caption +toolwindow 
			gui 7: show,NoActivate x0 y0 w%VirtualScreenWidth% h%VirtualScreenHeight%
			winactivate, ahk_id %thisid%
		}
		full=1
	}
	Else
	{
		gui 7: destroy
		gui, +border  +caption -toolwindow -alwaysontop
		winrestore, ahk_id %thisid%
		full=0
	}


return

esc:
full=0
gui 7: destroy
gui, submit
gui, destroy
if not newtext
	return
	
	
if (text=newtext)
	return
	
	/*if fromhotkey
	{
		fromhotkey=0
		return
	
	}
	*/
oldclip:=Clipboard

Clipboard:=newtext
winactivate, %atitle%
send {ctrl down}a{ctrl up}
send {ctrl down}v{ctrl up}
Clipboard:=oldclip
oldclip:=

return


^`::
fromhotkey=1
wingetactivetitle, atitle
gui,destroy
oldclip:=Clipboard
Clipboard:=
send {ctrl down}a{ctrl up}
send {ctrl down}c{ctrl up}
text:=Clipboard
Clipboard:=oldclip
oldclip:=

gosub open
return

wheel:
if A_Thishotkey=WheelDown
{
	ControlGetFocus, control, A 
	SendMessage, 0x115, 1, 0, %control%, A 
}
else
{
	ControlGetFocus, control, A 
	SendMessage, 0x115, 0, 0, %control%, A 
}


return

MenuFileOpen:

return

MenuHandler:

return

ToggleMenu( hWin )
	{
		static hMenu, visible=1
		If hMenu =
			hMenu := DllCall("GetMenu", "uint", hWin)

		If !visible
		{
			DllCall("SetMenu", "uint", hWin, "uint", hMenu)
		}
		Else
		{
			DllCall("SetMenu", "uint", hWin, "uint", 0)
		}
		visible := !visible
	}



WM_MOUSEMOVE(wParam,lParam)
{
	global octrl
 	MouseGetPos,,,,ctrl

	if (ctrl=octrl)
	{
		return
	}

	If ctrl in Static1,Static2,Static3,Static4
	{
		octrl:=ctrl
		GuiControl, +cwhite, %ctrl%
		GuiControl, MoveDraw, %ctrl%
	}
	else
	{
		GuiControl, +c00FF00, %octrl%
		GuiControl, MoveDraw, %octrl%
		octrl:=ctrl
	}
	
  Return
}



mouseOverControl:
	MouseGetPos, , , mWin, mCtrl

	if not (mWin=thisid)
		return

	
	if mCtrl=Static1
	{
		on=1
		GuiControl, +cwhite, Static1  
		bob=test
	}
	else if mCtrl=Static2
	{
		on=2
		GuiControl, +cwhite, Static2
	}
	else if mCtrl=Static3
	{
		on=3
		GuiControl, +cwhite, Static3
	}
	else if mCtrl=Static4
	{
		on=4
		GuiControl, +cwhite, Static4
	}
	else if on=5
		on=0
	else
		on=5

		
	if on
	{
		loop 4
		{
			if not (on=a_index)
				GuiControl, +c00FF00, Static%a_index%
		}
		;WinSet, redraw,  , ahk_id %thisid%
	}

return


Attach(hCtrl="", aDef="") {
		Attach_(hCtrl, aDef, "", "")
	}

Attach_(hCtrl, aDef, Msg, hParent){
		static
		local s1,s2, enable, reset, oldCritical

		If (aDef = "") {							;Reset if integer, Handler if string
			If IsFunc(hCtrl)
				return Handler := hCtrl

			IfEqual, adrWindowInfo,, return			;Resetting prior to adding any control just returns.
			hParent := hCtrl != "" ? hCtrl+0 : hGui
			Loop, parse, %hParent%a, %A_Space%
			{
				hCtrl := A_LoopField, SubStr(%hCtrl%,1,1), aDef := SubStr(%hCtrl%,1,1)="-" ? SubStr(%hCtrl%,2) : %hCtrl%,  %hCtrl% := ""
				gosub Attach_GetPos
				Loop, parse, aDef, %A_Space%
				{
					StringSplit, z, A_LoopField, :
					%hCtrl% .= A_LoopField="r" ? "r " : (z1 ":" z2 ":" c%z1% " ")
				}
				%hCtrl% := SubStr(%hCtrl%, 1, -1)
			}
			reset := 1,  %hParent%_s := %hParent%_pw " " %hParent%_ph
		}

		If (hParent = "")  {						;Initialize controls
			If !adrSetWindowPos
				adrSetWindowPos		:= DllCall("GetProcAddress", "uint", DllCall("GetModuleHandle", "str", "user32"), A_IsUnicode ? "astr" : "str", "SetWindowPos")
											,adrWindowInfo		:= DllCall("GetProcAddress", "uint", DllCall("GetModuleHandle", "str", "user32"), A_IsUnicode ? "astr" : "str", "GetWindowInfo")
											,OnMessage(5, A_ThisFunc),	VarSetCapacity(B, 60), NumPut(60, B), adrB := &B
											,hGui := DllCall("GetParent", "uint", hCtrl, "Uint")

			hParent := DllCall("GetParent", "uint", hCtrl, "Uint")

			If !%hParent%_s
				DllCall(adrWindowInfo, "uint", hParent, "uint", adrB), %hParent%_pw := NumGet(B, 28) - NumGet(B, 20), %hParent%_ph := NumGet(B, 32) - NumGet(B, 24), %hParent%_s := !%hParent%_pw || !%hParent%_ph ? "" : %hParent%_pw " " %hParent%_ph

			If InStr(" " aDef " ", "p")
				StringReplace, aDef, aDef, p, xp yp wp hp
			IfEqual, aDef, -, return SubStr(%hCtrl%,1,1) != "-" ? %hCtrl% := "-" %hCtrl% :
			Else If (aDef = "+")
				If SubStr(%hCtrl%,1,1) != "-"
					return
				Else %hCtrl% := SubStr(%hCtrl%, 2), enable := 1
				Else {
					gosub Attach_GetPos
					%hCtrl% := ""
					Loop, parse, aDef, %A_Space%
					{
						If (l := A_LoopField) = "-"	{
							%hCtrl% := "-" %hCtrl%
							continue
						}
						f := SubStr(l,1,1), k := StrLen(l)=1 ? 1 : SubStr(l,2)
						If (j := InStr(l, "/"))
							k := SubStr(l, 2, j-2) / SubStr(l, j+1)
						%hCtrl% .= f ":" k ":" c%f% " "
					}
					return %hCtrl% := SubStr(%hCtrl%, 1, -1), %hParent%a .= InStr(%hParent%, hCtrl) ? "" : (%hParent%a = "" ? "" : " ")  hCtrl
				}
		}
		IfEqual, %hParent%a,, return				;return if nothing to anchor.

		If !reset && !enable {
			%hParent%_pw := aDef & 0xFFFF, %hParent%_ph := aDef >> 16
			IfEqual, %hParent%_ph, 0, return		;when u create gui without any control, it will send message with height=0 and scramble the controls ....
		}

		If !%hParent%_s
			%hParent%_s := %hParent%_pw " " %hParent%_ph

		oldCritical := A_IsCritical
		critical, 5000

		StringSplit, s, %hParent%_s, %A_Space%
		Loop, parse, %hParent%a, %A_Space%
		{
			hCtrl := A_LoopField, aDef := %hCtrl%, 	uw := uh := ux := uy := r := 0, hCtrl1 := SubStr(%hCtrl%,1,1)
			If (hCtrl1 = "-")
				IfEqual, reset,, continue
			Else aDef := SubStr(aDef, 2)

			gosub Attach_GetPos
			Loop, parse, aDef, %A_Space%
			{
				StringSplit, z, A_LoopField, :		; opt:coef:initial
				IfEqual, z1, r, SetEnv, r, %z2%
				If z2=p
					c%z1% := z3 * (z1="x" || z1="w" ?  %hParent%_pw/s1 : %hParent%_ph/s2), u%z1% := true
				Else c%z1% := z3 + z2*(z1="x" || z1="w" ?  %hParent%_pw-s1 : %hParent%_ph-s2), 	u%z1% := true
			}
			flag := 4 | (r=1 ? 0x100 : 0) | (uw OR uh ? 0 : 1) | (ux OR uy ? 0 : 2)			; nozorder=4 nocopybits=0x100 SWP_NOSIZE=1 SWP_NOMOVE=2
			;m(hParent, %hParent%a, hCtrl, %hCTRL%)
			DllCall(adrSetWindowPos, "uint", hCtrl, "uint", 0, "uint", cx, "uint", cy, "uint", cw, "uint", ch, "uint", flag)
			r+0=2 ? Attach_redrawDelayed(hCtrl) :
		}
		critical %oldCritical%
		return Handler != "" ? %Handler%(hParent) : ""

Attach_GetPos:									;hParent & hCtrl must be set up at this point
	DllCall(adrWindowInfo, "uint", hParent, "uint", adrB), 	lx := NumGet(B, 20), ly := NumGet(B, 24), DllCall(adrWindowInfo, "uint", hCtrl, "uint", adrB)
									,cx :=NumGet(B, 4),	cy := NumGet(B, 8), cw := NumGet(B, 12)-cx, ch := NumGet(B, 16)-cy, cx-=lx, cy-=ly
return
}

Attach_redrawDelayed(hCtrl){
		static s
		s .= !InStr(s, hCtrl) ? hCtrl " " : ""
		SetTimer, %A_ThisFunc%, -100
		return
Attach_redrawDelayed:
	Loop, parse, s, %A_Space%
		WinSet, Redraw, , ahk_id %A_LoopField%
	s := ""
return
}
