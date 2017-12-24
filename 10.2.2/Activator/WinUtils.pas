{ *********************************************************************** }
{                                                                         }
{   Win 辅助函数单元                                                      }
{                                                                         }
{   设计：Lsuper 2013.04.26                                               }
{   备注：                                                                }
{   审核：                                                                }
{                                                                         }
{   Copyright (c) 1998-2014 Super Studio                                  }
{                                                                         }
{ *********************************************************************** }

unit WinUtils;

{$WARNINGS OFF}

interface

uses
  SysUtils, Windows;

function  GetCommandLineOutput(const ACommandLine, AWorkDir: string;
  out ExitCode: LongWord): string;
function  GetFileBuildVersion(const AFile: string): Integer;
function  GetShellFolderPath(nFolder: Integer): string;
function  GetWindowsPath: string;

function  TaskMessageBox(const AHandle: THandle; const AText, ACaption: string;
  const Icon, Buttons: Integer): Integer;
function  IsWindowsVista: Boolean;

procedure Delay(ASeconds: Double);

function  CreateProcessEx(lpApplicationName: PChar; lpCommandLine: PChar;
  lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
  bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer;
  lpCurrentDirectory: PChar; const lpStartupInfo: TStartupInfo;
  var lpProcessInformation: TProcessInformation; const ALibraryName: AnsiString): Boolean;
function  InjectLibraryModule(AProcessID: LongWord; const ALibraryName: AnsiString): Boolean;

procedure LogMessage(const AMessage: string);

procedure ShowMessage(const ACaption, AMessage: string);
procedure ShowError(const AMessage: string);

procedure SetMainFormHandle(const AHandle: HWND);

implementation

uses
  ShlObj;

const
  TD_BUTTON_OK          = 01;
  TD_BUTTON_YES         = 02;
  TD_BUTTON_NO          = 04;
  TD_BUTTON_CANCEL      = 08;
  TD_BUTTON_RETRY       = 16;
  TD_BUTTON_CLOSE       = 32;

  TD_ICON_BLANK         = 00;
  TD_ICON_WARNING       = 84;
  TD_ICON_QUESTION      = 99;
  TD_ICON_ERROR         = 98;
  TD_ICON_INFORMATION   = 81;

  TD_ICON_SHIELD_QUESTION = 104;
  TD_ICON_SHIELD_ERROR    = 105;
  TD_ICON_SHIELD_OK       = 106;
  TD_ICON_SHIELD_WARNING  = 107;

var
  MainFormHandle: HWND = 0;

////////////////////////////////////////////////////////////////////////////////
// 说明：用于延迟n秒
// 参数：ASeconds -- 延迟秒数
////////////////////////////////////////////////////////////////////////////////
procedure Delay(ASeconds: Double);
  ////////////////////////////////////////////////////////////////////////////////
  //设计: Lsuper 2004.11.10
  //功能: 调用消息循环，防止僵死
  //参数：
  ////////////////////////////////////////////////////////////////////////////////
  procedure ProcessMessages;
  const
    WM_QUIT             = $0012;
  var
    Msg: TMsg;
  begin
    while PeekMessage(Msg, 0, 0, 0, PM_REMOVE) do
    begin
      if Msg.Message = WM_QUIT then
        Halt(Msg.wParam);
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;
var
  nTimeOut: TDateTime;
  nHours, nMins, nSeconds, nMilliSecs: Integer;
begin
  nSeconds := Trunc(ASeconds);
  nMilliSecs := Round(Frac(ASeconds) * 1000);
  nHours := nSeconds div 3600;
  nMins := (nSeconds mod 3600) div 60;
  nSeconds := nSeconds mod 60;
  nTimeOut := Now + EncodeTime(nHours, nMins, nSeconds, nMilliSecs);
  // wait until the TimeOut time
  while Now < nTimeOut do
    ProcessMessages;
end;

////////////////////////////////////////////////////////////////////////////////
//设计: Lsuper 2003.09.21
//功能: 取得运行命令行的输出
//参数：
////////////////////////////////////////////////////////////////////////////////
function GetCommandLineOutput(const ACommandLine, AWorkDir: string;
  out ExitCode: LongWord): string;
var
  strCommandLine,
  strWorkDir: string;
  strOutLine,
  strBuffer: AnsiString;
  bRunResult: Boolean;
  nBytesRead: Cardinal;
  nStdOutPipeRead,
  nStdOutPipeWrite: THandle;
  PI: TProcessInformation;
  SA: TSecurityAttributes;
  SI: TStartupInfo;
begin
  with SA do
  begin
    nLength := SizeOf(SA);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  if not CreatePipe(nStdOutPipeRead, nStdOutPipeWrite, @SA, 0) then
    RaiseLastOSError;
  try
    with SI do
    begin
      FillChar(SI, SizeOf(SI), 0);
      cb := SizeOf(SI);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE);
      hStdOutput := nStdOutPipeWrite;
      hStdError := nStdOutPipeWrite;
    end;
    if DirectoryExists(AWorkDir) then
      strWorkDir := AWorkDir
    else strWorkDir := GetCurrentDir;
    strCommandLine := ACommandLine;
    UniqueString(strCommandLine);
    bRunResult := CreateProcess(nil, PChar(strCommandLine), nil, nil, True, 0, nil,
      PChar(strWorkDir), SI, PI);
    CloseHandle(nStdOutPipeWrite);
    if bRunResult then
    try
      strOutLine := '';
      SetLength(strBuffer, MAXBYTE);
      repeat
        nBytesRead := 0;
        bRunResult := ReadFile(nStdOutPipeRead, PAnsiChar(strBuffer)^, Length(strBuffer), nBytesRead, nil);
        if nBytesRead > 0 then
          strOutLine := strOutLine + Copy(strBuffer, 1, nBytesRead);
      until not bRunResult or (nBytesRead = 0);
      WaitForSingleObject(PI.hProcess, INFINITE);
      GetExitCodeProcess(PI.hProcess, ExitCode);
    finally
      CloseHandle(PI.hThread);
      CloseHandle(PI.hProcess);
    end
    else RaiseLastOSError;
  finally
    CloseHandle(nStdOutPipeRead);
    Result := string(strOutLine);
  end;
end;

function GetFileBuildVersion(const AFile: string): Integer;
var
  nInfoSize, dwHandle: DWORD;
  cFileInfo: PVSFixedFileInfo;
  nVerSize: DWORD;
  strBuffer: AnsiString;
begin
  Result := 0;
  nInfoSize := GetFileVersionInfoSize(PChar(AFile), dwHandle);
  if nInfoSize = 0 then
    Exit;
  SetLength(strBuffer, nInfoSize);
  if not GetFileVersionInfo(PChar(AFile), dwHandle, nInfoSize, Pointer(strBuffer)) then
    Exit;
  if VerQueryValue(Pointer(strBuffer), '\', Pointer(cFileInfo), nVerSize) then
    Result := LOWORD(cFileInfo.dwFileVersionLS);
end;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2010.04.09
//功能：获取 Shell 文件夹位置，如 GetSpecialFolderPath(CSIDL_COMMON_APPDATA) 等
//参数：
////////////////////////////////////////////////////////////////////////////////
function GetShellFolderPath(nFolder: Integer): string;
begin
  SetLength(Result, MAX_PATH);
  SHGetSpecialFolderPath(0, PChar(Result), nFolder, False);
  SetLength(Result, StrLen(PChar(Result)));
  if (Result <> '') and (Result[Length(Result)] <> '\') then
    Result := Result + '\';
end;

function GetWindowsPath: string;
var
  nRet: LongWord;
begin
  SetLength(Result, MAX_PATH);
  nRet := GetWindowsDirectory(PChar(Result), MAX_PATH);
  if nRet = 0 then
    Result := ''
  else begin
    SetLength(Result, nRet);
    if (Result <> '') and (Result[Length(Result)] <> '\') then
      Result := Result + '\';
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2013.05.01
//功能：创建注入进程
//参数：
//注意：加入 500ms 等待时间，确保 dll 加载成功后执行
////////////////////////////////////////////////////////////////////////////////
function CreateProcessEx(lpApplicationName: PChar; lpCommandLine: PChar;
  lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
  bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer;
  lpCurrentDirectory: PChar; const lpStartupInfo: TStartupInfo;
  var lpProcessInformation: TProcessInformation; const ALibraryName: AnsiString): Boolean;
begin
  Result := False;
  if not CreateProcess(lpApplicationName, lpCommandLine, lpProcessAttributes, lpThreadAttributes, bInheritHandles, dwCreationFlags or CREATE_SUSPENDED, lpEnvironment, lpCurrentDirectory, lpStartupInfo, lpProcessInformation) then
    Exit;
  Result := InjectLibraryModule(lpProcessInformation.hProcess, ALibraryName);
{
  Result := uallHook.InjectLibrary(lpProcessInformation.dwProcessId, PChar(ALibraryName));
}
  Sleep(500);
  ResumeThread(lpProcessInformation.hThread);
end;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2013.05.01
//功能：注入 DLL
//参数：
////////////////////////////////////////////////////////////////////////////////
function InjectLibraryModule(AProcessID: LongWord; const ALibraryName: AnsiString): Boolean;
var
  dwProcessID2: DWord;
  dwMemSize: DWord;
  dwWritten: DWord;
  dwThreadID: DWord;
  pLLA: Pointer;
  pTargetMemory: Pointer;
begin
  Assert(ALibraryName <> '');
  Result := False;
  dwProcessID2 := OpenProcess(PROCESS_ALL_ACCESS, False, AProcessID);
  if (dwProcessID2 <> 0) then
    AProcessID := dwProcessID2;
  dwMemSize := Length(ALibraryName) + 1;
  pTargetMemory := VirtualAllocEx(AProcessID, nil, dwMemSize, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
  pLLA := GetProcAddress(GetModuleHandleA('kernel32.dll'), 'LoadLibraryA');
  if (pLLA <> nil) and (pTargetMemory <> nil) then
  begin
    if WriteProcessMemory(AProcessID, pTargetMemory, PChar(ALibraryName), dwMemSize, dwWritten) and (dwWritten = dwMemSize) then
      Result := CreateRemoteThread(AProcessID, nil, 0, pLLA, pTargetMemory, 0, dwThreadID) <> 0;
  end;
  if (dwProcessID2 <> 0) then
    CloseHandle(dwProcessID2);
end;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2009.10.25
//功能：判断是否 Vista/7
//参数：
////////////////////////////////////////////////////////////////////////////////
function IsWindowsVista: Boolean;
var
  hKernel32: HMODULE;
begin
  hKernel32 := GetModuleHandle('kernel32');
  if hKernel32 > 0 then
    Result := GetProcAddress(hKernel32, 'GetLocaleInfoEx') <> nil
  else Result := false;
end;

procedure LogMessage(const AMessage: string);
begin
  OutputDebugString(PChar(AMessage));
end;

procedure SetMainFormHandle(const AHandle: HWND);
begin
  MainFormHandle := AHandle;
end;

procedure ShowError(const AMessage: string);
begin
  TaskMessageBox(MainFormHandle, AMessage, 'Error', TD_ICON_ERROR, TD_BUTTON_OK);
end;

procedure ShowMessage(const ACaption, AMessage: string);
begin
  TaskMessageBox(MainFormHandle, AMessage, ACaption, TD_ICON_INFORMATION, TD_BUTTON_OK);
end;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2009.10.25
//功能: 内部使用的用于显示对话框的函数，适应 Vista/7 系统风格
//参数：
//注意：参考 Application 的 MessageBox 和 Dialogs 的 代码，忽略多显示器判断代码
//      http://www.tmssoftware.com/site/atbdev5.asp
////////////////////////////////////////////////////////////////////////////////
function TaskMessageBox(const AHandle: THandle; const AText, ACaption: string;
  const Icon, Buttons: Integer): Integer;
const
  conTaskDialogProcName = 'TaskDialog';
var
  DLLHandle: THandle;
  wTitle, wContent: array[0..1024] of widechar;
  TaskDialogProc: function(HWND: THandle; hInstance: THandle; cTitle,
    cDescription, cContent: PWideChar; Buttons: Integer; Icon: Integer;
    ResButton: PInteger): Integer; cdecl stdcall;
  Flags: Integer;
begin
  Result := 0;
  if IsWindowsVista then
  begin
    DLLHandle := LoadLibrary(comctl32);
    @TaskDialogProc := GetProcAddress(DLLHandle, conTaskDialogProcName);
  end
  else TaskDialogProc := nil;
  if Assigned(TaskDialogProc) then
  begin
    StringToWideChar(ACaption, wTitle, SizeOf(wTitle));
    StringToWideChar(AText, wContent, SizeOf(wContent));
    TaskDialogProc(AHandle, 0, wTitle, nil, wContent, Buttons, Icon, @Result);
  end
  else begin
    Flags := 0;
    if Buttons = TD_BUTTON_OK then
      Flags := MB_OK;
    if Buttons = TD_BUTTON_OK or TD_BUTTON_CANCEL then
      Flags := MB_OKCANCEL;
    if Buttons = TD_BUTTON_CLOSE or TD_BUTTON_RETRY or TD_BUTTON_CANCEL then
      Flags := MB_ABORTRETRYIGNORE;
    if Buttons = TD_BUTTON_YES or TD_BUTTON_NO or TD_BUTTON_CANCEL then
      Flags := MB_YESNOCANCEL;
    if Buttons = TD_BUTTON_YES or TD_BUTTON_NO then
      Flags := MB_YESNO;
    if Buttons = TD_BUTTON_RETRY or TD_BUTTON_CANCEL then
      Flags := MB_RETRYCANCEL;
    case Icon of
      TD_ICON_BLANK:
        ;
      TD_ICON_WARNING, TD_ICON_SHIELD_WARNING:
        Flags := Flags or MB_ICONWARNING;
      TD_ICON_QUESTION, TD_ICON_SHIELD_QUESTION:
        Flags := Flags or MB_ICONQUESTION;
      TD_ICON_ERROR, TD_ICON_SHIELD_ERROR:
        Flags := Flags or MB_ICONERROR;
      TD_ICON_INFORMATION, TD_ICON_SHIELD_OK:
        Flags := Flags or MB_ICONINFORMATION;
    end;
    Result := Windows.MessageBox(AHandle, PChar(AText), PChar(ACaption), Flags);
  end;
end;

end.

