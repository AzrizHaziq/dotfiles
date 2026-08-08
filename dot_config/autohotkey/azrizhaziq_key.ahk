#Requires AutoHotkey v2.0

; Map both physical Win keys to F13
*LWin::Send "{F13 down}"
*LWin up::Send "{F13 up}"
*RWin::Send "{F13 down}"
*RWin up::Send "{F13 up}"

; Quick test: if F13 is received, show a tooltip for 1 second
F13:: {
	ToolTip "F13 detected"
	SetTimer () => ToolTip(), -1000
}

; Make CapsLock behave like a held Win (Super) key
SetCapsLockState "AlwaysOff"
*CapsLock::Send "{LWin down}"
*CapsLock up::Send "{LWin up}"
