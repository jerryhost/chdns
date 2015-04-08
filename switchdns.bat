@echo off
echo 當出現"使用者帳戶控制"提示視窗時請按"是" 
echo 切換前請先關閉瀏覽器	
REM -- Sam 20120814 DNS 切換小工具，搭配 UAC 提示
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
	
echo ---------------------------------------
echo 線上   請按 online
echo beta   請按 beta
echo ---------------alpha-------------------
echo alpha 請按 alpha
echo ---------------------------------------

SET /P INPUT=[請輸入您要使用的DNS]

CALL :LowCase INPUT
echo %INPUT%
GOTO :EOF 

:LowCase
FOR %%i IN ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i" "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r" "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") DO CALL SET "%1=%%%1:%%~i%%"
GOTO :START

:START
if "%INPUT%"=="online" goto :Online
if "%INPUT%"=="beta" goto :Beta
if "%INPUT%"=="alpha" goto :Alpha


:Default
	echo  請輸入人名，感謝您! 
	goto :END

:Online
	echo 切換至線上 Server 
	netsh interface ip set dns "區域連線" static 168.95.1.1 primary 
	netsh interface ip set dns "無線網路連線" static 168.95.1.1 primary 
	goto :END

:Beta
	echo 切換至 Beta Server
	netsh interface ip set dns "區域連線" static 192.168.1.1 primary
	netsh interface ip set dns "無線網路連線" static 192.168.1.1 primary
	goto :END

:Alpha
	echo 切換到 Alpha
	netsh interface ip set dns "區域連線" static 192.168.2.1 primary
	netsh interface ip set dns "無線網路連線" static 192.168.2.1 primary
	goto :END
	
:END
	pause
	ipconfig /flushdns
	pause
	netsh interface ip show  dns "區域連線"
	netsh interface ip show  dns "無線網路連線"
	pause
