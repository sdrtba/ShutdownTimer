@echo off
schtasks /Delete /tn "Shutdown" /F
cls
set /p wait_hours="hours: "
set /p wait_minutes="minutes: "
set mytime=%time%
set /a cur_hours=%mytime:~0,2%
set /a cur_minutes=%mytime:~3,2%
set /a new_hours=((%cur_hours%+%wait_hours%)+((%cur_minutes%+%wait_minutes%)/60)) "%% 24
set /a new_minutes=(%cur_minutes%+%wait_minutes%) "%%" 60
set /a new_hours_d=%new_hours%/10
set /a new_hours_e=%new_hours% "%%" 10
set /a new_minutes_d=%new_minutes%/10
set /a new_minutes_e=%new_minutes% "%%" 10
set new_time=%new_hours_d%%new_hours_e%:%new_minutes_d%%new_minutes_e%

set dir=%cd%\shutdown.bat

set mydate=%date%
set /a add_day=((%cur_hours%+%wait_hours%)+((%cur_minutes%+%wait_minutes%)/60))/24

for /f "usebackq" %%i in (`PowerShell $date ^= Get-Date^; $date ^= $date.AddDays^(%add_day%^)^; $date.ToString^('yyyy-MM-dd'^)`) do set new_date=%%i

set year=%new_date:~0,4%
set month=%new_date:~5,2%
set day=%new_date:~8,2%
set date=%day%:%month%:%year%

@echo time %new_time%
@echo date %date%

schtasks /create /tn "Shutdown" /sc ONCE /tr "'%dir%'" /st %new_time% /sd %date%

timeout /t 10