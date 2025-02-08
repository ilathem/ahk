#Requires AutoHotkey v2.0

#include Notify.ahk

; Used for notifications: https://github.com/XMCQCX/NotifyClass-NotifyCreator

; Globals
paused := false
endTime := 0
timeLeft := ''

; Press <F9> to Start Timer, input minutes
^F9:: {
    InputBoxObj := InputBox("Enter number of minutes", "Timer")
    timerText := 'Setting timer for ' . InputBoxObj.value . ' minutes'
    Notify.Show('Timer', timerText,,,, 'dur=5 pos=TC tali=Center')
    global endTime
    endTime := DateAdd(A_Now, InputBoxObj.value, "m")
}

; Loop to see if timer is up or stopped
Loop {
    global endTime
    if (endTime == A_Now || endTime == -1) {
        Notify.Show('Timer', 'timer is finished`n(press Ctrl + F12 to close)',, 'Alarm03',, 'dur=0 pos=TC tali=Center tag=timer')
        break
    }
}

; Press <F12> to close ending timer message and cancel the timer
^F12::{
    Notify.Destroy('timer')    
    global endTime
    endTime := -1
}

; Press <F11> to pause/unpause the timer
^F11:: {
    global paused
    global endTime
    global timeLeft
    if (!paused) {
        paused := true
        timeLeft := DateDiff(endTime, A_Now, 's')
        now := A_Now
        mLeft := DateDiff(endTime, now, 'm')
        sLeft := DateDiff(endTime, now, 's')
        timeLeftMsg := mLeft . 'm:' . sLeft . 's left'
        msg := 'Timer paused with ' timeLeftMsg
        endTime := 0
        Notify.Show('Timer', msg,,,, 'dur=5 pos=TC tali=Center')
    } else if (paused) {
        paused := false
        endTime := DateAdd(A_Now, timeLeft, 's')
        now := A_Now
        mLeft := DateDiff(endTime, now, 'm')
        sLeft := DateDiff(endTime, now, 's')
        timeLeftMsg := mLeft . 'm:' . sLeft . 's left'
        msg := 'Timer unpaused with ' . timeLeftMsg
        Notify.Show('Timer', msg,,,, 'dur=5 pos=TC tali=Center')
    }
}

; Press <F10> to see current timer status
^F10:: {
    global endTime
    if (endTime == 0 || endTime = -1) {
        return
    }
    now := A_Now
    mLeft := DateDiff(endTime, now, 'm')
    sLeft := DateDiff(endTime, now, 's')
    msg := 'Time left: ' . mLeft . 'm:' . sLeft . 's'
    Notify.Show('Timer', msg,,,, 'dur=5 pos=TC tali=Center')
}
