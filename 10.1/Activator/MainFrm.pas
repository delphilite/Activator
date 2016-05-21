{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit MainFrm;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, KOL {$IF Defined(KOL_MCK)}{$ELSE}, mirror, Classes, Controls, mckCtrls, mckObjs, Graphics {$IFEND (place your units here->)};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, mirror;
{$ENDIF}

type
  {$IF Defined(KOL_MCK)}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} {$I TMainFormclass.inc} {$ELSE OBJECTS} PMainForm = ^TMainForm; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TMainForm.inc}{$ELSE} TMainForm = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TMainForm = class(TForm)
  {$IFEND KOL_MCK}
    btnAbout: TKOLButton;
    btnActive: TKOLButton;
    btnExit: TKOLButton;
    btnReset: TKOLButton;
    btnRunX10: TKOLButton;
    kolActivator: TKOLProject;
    kolMainForm: TKOLForm;
    procedure btnAboutClick(Sender: PObj);
    procedure btnActiveClick(Sender: PObj);
    procedure btnExitClick(Sender: PObj);
    procedure btnResetClick(Sender: PObj);
    procedure btnRunX10Click(Sender: PObj);
    procedure kolMainFormDestroy(Sender: PObj);
    procedure kolMainFormFormCreate(Sender: PObj);
    function  kolMainFormMessage(var Msg: TMsg; var Rslt: Integer): Boolean;
    procedure kolMainFormShow(Sender: PObj);
  private
    FAppPath,
    FBdsPath: string;
    FCurFileBuild: Integer;
    FSerialNumber,
    FRegCode,
    FInformation: string;
  private
    function  FindBdsPath: Boolean;

    function  GetSystemHostsFile: string;

    procedure BeginCursor;
    procedure EndCursor;

    procedure BuildGenuineCglmFile(const ASerialNumber: string = '');
    procedure BuildGenuineSlipFile;

    procedure BuildTrialCglmFile;
    procedure BuildTrialSlipFile;

    procedure DeleteFiles(const AFileMask: string);

    procedure GenerateRegistrationCode;
    procedure GenerateKeyGenLicense;

    procedure PatchLicenseHostsFile;
    procedure RestoreLicenseHostsFile;

    procedure PatchBdsFile;
    procedure RestoreBdsFile;

    procedure DeleteTrialFiles;
    procedure DeleteTrialRegKeys;

    procedure DoActive;
    procedure DoReset;
    procedure DoRunX10;

    procedure ShowAboutMessage;

    procedure Execute;
  end;

var
  MainForm {$IFDEF KOL_MCK} : PMainForm {$ELSE} : TMainForm {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewMainForm( var Result: PMainForm; AParent: PControl );
{$ENDIF}

implementation

{.$DEFINE DEBUGMODE}

uses
  SysUtils, ShellAPI, Registry, FileUtils, PatchData, WinUtils, RadKeygen;

{$IF Defined(KOL_MCK)}{$ELSE}{$R *.DFM}{$IFEND}

{$IFDEF KOL_MCK}
{$I MainFrm_1.inc}
{$ENDIF}

{$IFDEF DEBUGMODE}
  {$R WindowsXP.res}
{$ELSE}
  {$R 'Admin.res'} { 管理员运行 }
{$ENDIF}

const
  CSIDL_APPDATA         = $001A; // Application Data, new for NT4, <user name>\Application Data
  CSIDL_COMMON_APPDATA  = $0023; // All Users\Application Data

  UM_SHOWABOUT          = 100;

const
  defAppMessage         = 'Based on the hard work of unis, x-force, cjack. 3x ;>';
  defAppVersion         = '13.0';

  defAppHelperFileName  = 'SHFolder.dll';

  defBdsVersion         = '18.0';
  defBdsdLicenseManager = '"%s" -reg -skey 8218_21 -loadKey 2024 -a';

  defBdsPatchFileName   = defAppHelperFileName;

  defLicenseHosts: array[0..10] of string = (
    '127.0.0.1 comapi.embarcadero.com',
    '127.0.0.1 license.embarcadero.com',
    '127.0.0.1 track.embarcadero.com',
    '127.0.0.1 external.ws.sanctx.embarcadero.com',
    '127.0.0.1 object.ws.sanctx.embarcadero.com',
    '127.0.0.1 license.codegear.com',
    '127.0.0.1 license-stage.codegear.com',
    '127.0.0.1 services.server.v8.srs.sanctuary.codegear.com',
    '127.0.0.1 LicenseRenewalServicesImpl.services.server.v8.srs.sanctuary.codegear.com',
    '127.0.0.1 LicenseUsageServicesImpl.services.server.v8.srs.sanctuary.codegear.com',
    '127.0.0.1 RegistrationServicesImpl.services.server.v8.srs.sanctuary.codegear.com'
  );

{ TMainForm }

procedure TMainForm.BeginCursor;
begin
  SetCursor(LoadCursor(0, IDC_WAIT));
end;

procedure TMainForm.btnAboutClick(Sender: PObj);
begin
  ShowAboutMessage;
end;

procedure TMainForm.btnActiveClick(Sender: PObj);
begin
  BeginCursor;
  try
    DoActive;
  finally
    EndCursor;
  end;
end;

procedure TMainForm.btnExitClick(Sender: PObj);
begin
  Self.Form.Close;
end;

procedure TMainForm.btnResetClick(Sender: PObj);
begin
  BeginCursor;
  try
    DoReset;
  finally
    EndCursor;
  end;
end;

procedure TMainForm.btnRunX10Click(Sender: PObj);
begin
  BeginCursor;
  try
    DoRunX10;
  finally
    EndCursor;
  end;
end;

procedure TMainForm.BuildGenuineCglmFile(const ASerialNumber: string);
var
  F: AnsiString;
  S: string;
begin
  SetLength(F, Length(defCglmFileDatas));
  Move(defCglmFileDatas, Pointer(F)^, Length(defCglmFileDatas));
  if ASerialNumber <> '' then
    F := AnsiString(StringReplace(string(F), defCglmSerialNumber, ASerialNumber, [rfReplaceAll]));
  S := FBdsPath + 'Bin\cglm.ini';
  SaveDataToFile(S, Pointer(F)^, Length(F));
  S := GetShellFolderPath(CSIDL_COMMON_APPDATA) + 'Embarcadero\Studio\' + defBdsVersion + '\cglm.ini';
  SaveDataToFile(S, Pointer(F)^, Length(F));
end;

procedure TMainForm.BuildGenuineSlipFile;
var
  S: string;
begin
  S := FBdsPath + 'License\*.slip';
  DeleteFiles(S);
  S := FBdsPath + 'License\RADStudio10.slip';
  SaveDataToFile(S, defGenuineLicFileDatas, Length(defGenuineLicFileDatas));
end;

procedure TMainForm.BuildTrialCglmFile;
var
  S: string;
begin
  S := FBdsPath + 'Bin\cglm.ini';
  SaveDataToFile(S, defCglmFileDatas, Length(defCglmFileDatas));
end;

procedure TMainForm.BuildTrialSlipFile;
var
  S: string;
begin
  S := FBdsPath + 'License\*.slip';
  DeleteFiles(S);
  S := FBdsPath + 'License\RADStudio10.slip';
  SaveDataToFile(S, defTrialLicFileDatas, Length(defTrialLicFileDatas));
end;

procedure TMainForm.DeleteFiles(const AFileMask: string);
  ////////////////////////////////////////////////////////////////////////////////
  //设计: Lsuper 2005.09.21
  //功能: 判断特殊文件
  //参数：
  ////////////////////////////////////////////////////////////////////////////////
  function IsDirNotation(const AName: string): Boolean;
  begin
    Result := (AName = '.') or (AName = '..');
  end;
var
  cSearchRec: TSearchRec;
  strFilePath: string;
begin
  strFilePath := ExtractFilePath(AFileMask);
  if FindFirst(AFileMask, faAnyFile, cSearchRec) = 0 then
  repeat
    if (cSearchRec.Name <> '') and not IsDirNotation(cSearchRec.Name) then
    begin
      SysUtils.DeleteFile(strFilePath + cSearchRec.Name);
    end;
  until FindNext(cSearchRec) <> 0;
  SysUtils.FindClose(cSearchRec);
end;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2011.01.05
//功能：清理授权信息
//参数：
////////////////////////////////////////////////////////////////////////////////
procedure TMainForm.DeleteTrialFiles;
var
  AllUsersPath, UserPath: string;
begin
  AllUsersPath := GetShellFolderPath(CSIDL_COMMON_APPDATA) + 'Embarcadero\';
  UserPath := GetShellFolderPath(CSIDL_APPDATA) + 'Embarcadero\';

  DeleteFile(UserPath + '.cgb_license');
  DeleteFile(AllUsersPath + '.cgb_license');

  DeleteFile(UserPath + '.licenses\.cg_license');
  DeleteFile(AllUsersPath + '.licenses\.cg_license');

  DeleteFile(AllUsersPath + 'RAD Studio Activation.slip');

  DeleteFiles(AllUsersPath + '.82*.slip');
end;

procedure TMainForm.DeleteTrialRegKeys;
begin
end;

procedure TMainForm.DoActive;
var
  S: string;
  nBuild: Integer;
begin
  if not FindBdsPath then
  begin
    ShowError('No BDS find!');
    Exit;
  end;
  S := FBdsPath + 'Bin\bds.exe';
  nBuild := GetFileBuildVersion(S);
  if nBuild <> FCurFileBuild then
  begin
    ShowError('BDS version not support!');
    Exit;
  end;
  BuildTrialCglmFile;
  BuildTrialSlipFile;
  RestoreBdsFile;
  GenerateRegistrationCode;
  GenerateKeyGenLicense;
  BuildGenuineCglmFile;
  BuildGenuineSlipFile;
  PatchBdsFile;
  PatchLicenseHostsFile;
  ShowMessage('Active', 'OK! Code: ' + FRegCode + ', Serial: ' + FSerialNumber);
end;

procedure TMainForm.DoReset;
begin
  if not FindBdsPath then
  begin
    ShowError('No BDS find!');
    Exit;
  end;
  DeleteTrialFiles;
  DeleteTrialRegKeys;
  BuildTrialCglmFile;
  BuildTrialSlipFile;
  RestoreBdsFile;
  RestoreLicenseHostsFile;
  ShowMessage('Reset', 'OK!');
end;

procedure TMainForm.DoRunX10;
var
  BdsExe: string;
begin
  if not FindBdsPath then
  begin
    ShowError('No BDS find!');
    Exit;
  end;
  FBdsPath := FBdsPath + 'Bin';
  BdsExe := FBdsPath + '\bds.exe';
  ShellExecute(0, 'open', PChar(BdsExe), '-pDelphi', PChar(FBdsPath), SW_NORMAL);
  Delay(20);
end;

procedure TMainForm.EndCursor;
begin
  SetCursor(LoadCursor(0, IDC_ARROW));
end;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2011.09.20
//功能：直接执行 Lite 的安装任务
//参数：
////////////////////////////////////////////////////////////////////////////////
procedure TMainForm.Execute;
var
  S: string;
  nBuild: Integer;
begin
  if not FindBdsPath then
  begin
    LogMessage('No BDS find!');
    Exit;
  end;
  S := FBdsPath + 'Bin\bds.exe';
  nBuild := GetFileBuildVersion(S);
  if nBuild <> FCurFileBuild then
  begin
    LogMessage('BDS version not support!');
    Exit;
  end;

  GenerateRegistrationCode;
  GenerateKeyGenLicense;
  BuildGenuineCglmFile;
  BuildGenuineSlipFile;
  PatchBdsFile;
  PatchLicenseHostsFile;

  LogMessage('Done. Code: ' + FRegCode + ', Serial: ' + FSerialNumber);
end;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2013.02.15
//功能：查找 Delphi
//参数：
////////////////////////////////////////////////////////////////////////////////
function TMainForm.FindBdsPath: Boolean;
begin
  Result := False;
  with TRegistry.Create do
  try
    Access := KEY_READ;
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKeyReadOnly('SOFTWARE\Embarcadero\BDS\' + defBdsVersion) then
    begin
      FBdsPath := ReadString('RootDir');
      CloseKey;
    end;
  finally
    Free;
  end;
  if FBdsPath <> '' then
  begin
    FBdsPath := IncludeTrailingPathDelimiter(FBdsPath);
    Result := FileExists(FBdsPath + 'Bin\bds.exe');
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2013.05.01
//功能：
//参数：
//注意：设置环境变量，用于 IPC 通知、通讯
////////////////////////////////////////////////////////////////////////////////
procedure TMainForm.GenerateKeyGenLicense;
begin
  FSerialNumber := RadKeygen.GenerateSerialNumber;
  FRegCode := RadKeygen.GetRegistrationCode;
  RadKeygen.GenerateActiveFile(FSerialNumber, FRegCode, FInformation);
end;

////////////////////////////////////////////////////////////////////////////////
//设计: Lsuper 2006.09.19
//功能: 注入启动
//参数：
//注意：设置环境变量，用于 IPC 通知、通讯
////////////////////////////////////////////////////////////////////////////////
procedure TMainForm.GenerateRegistrationCode;
var
  si: TStartupInfo;
  pi: TProcessInformation;
  nExitCode: LongWord;
  strHelper, strCommandLine, strWorkDir: string;
begin
  strHelper := FAppPath + defAppHelperFileName;
  if not FileExists(strHelper) then
    SaveDataToFile(strHelper, defHelperDatas, Length(defHelperDatas));
  strWorkDir := FBdsPath + 'Bin';
  strCommandLine := Format('%s\LicenseManager.exe', [strWorkDir]);
  if not FileExists(strCommandLine) then
    raise Exception.CreateFmt('File %s not exists!', [strCommandLine]);
  strCommandLine := Format(defBdsdLicenseManager, [strCommandLine]);
  FillChar(si, SizeOf(TStartupInfo), 0);
  with si do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW + STARTF_FORCEONFEEDBACK;
    wShowWindow := SW_HIDE;
  end;
  if CreateProcessEx(nil, PChar(strCommandLine), nil, nil, False, 0, nil, PChar(strWorkDir), si, pi, AnsiString(strHelper)) then
  try
    WaitForSingleObject(pi.hProcess, INFINITE);
    GetExitCodeProcess(pi.hProcess, nExitCode);
    if nExitCode = 0 then
      raise Exception.Create('BdsReg error!');
  finally
    CloseHandle(pi.hThread);
    CloseHandle(pi.hProcess);
  end
  else RaiseLastOSError;
end;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2009.01.30
//功能：取Windows系统目录
//参数：
////////////////////////////////////////////////////////////////////////////////
function TMainForm.GetSystemHostsFile: string;
const
  defHostsFilePath      = 'drivers\etc\hosts';
var
  nRet: LongWord;
begin
  SetLength(Result, MAX_PATH);
  nRet := GetSystemDirectory(PChar(Result), MAX_PATH);
  if nRet = 0 then
    Result := ''
  else begin
    SetLength(Result, nRet);
    Result := IncludeTrailingPathDelimiter(Result) + defHostsFilePath;
  end;
end;

procedure TMainForm.kolMainFormDestroy(Sender: PObj);
begin
  LogMessage('Destroy');
{$IFNDEF DEBUGMODE}
  DeleteFiles(FAppPath + '*.*');
  RemoveDirectory(PChar(FAppPath));
{$ENDIF}
end;

procedure TMainForm.kolMainFormFormCreate(Sender: PObj);
var
  S: string;
begin
  LogMessage('Create');

  FAppPath := GetShellFolderPath(CSIDL_APPDATA);
  FAppPath := IncludeTrailingPathDelimiter(FAppPath) + 'Activator\' + defAppVersion + '\';
  ForceDirectories(FAppPath);
  S := GetModuleName(HInstance);
  FCurFileBuild := GetFileBuildVersion(S);

  SetEnvironmentVariable('SESSIONNAME', 'Conso1e');

  if ParamStr(1) = '-process' then
  begin
    Execute;
    Halt(1);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2003.09.21
//功能：处理系统菜单
//参数：
////////////////////////////////////////////////////////////////////////////////
function TMainForm.kolMainFormMessage(var Msg: TMsg;
  var Rslt: Integer): Boolean;
begin
  if (Msg.message = WM_SYSCOMMAND) and (Msg.WParam = UM_SHOWABOUT) then
    ShowAboutMessage;
  Result := False;
end;

procedure TMainForm.kolMainFormShow(Sender: PObj);
var
  hMain : HMENU;
begin
  LogMessage('Show');

  hMain := GetSystemMenu(Self.Form.Handle, False);
  AppendMenu(hMain, MF_SEPARATOR, 0, nil);
  AppendMenu(hMain, MF_STRING{ or MF_CHECKED}, UM_SHOWABOUT, 'About ...');
  SetMainFormHandle(Self.Form.Handle);
end;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2011.09.21
//功能：修改 BDS.exe 文件
//参数：
////////////////////////////////////////////////////////////////////////////////
procedure TMainForm.PatchBdsFile;
var
  S: string;
begin
  S := FBdsPath + 'Bin\' + defBdsPatchFileName;
  SaveDataToFile(S, defBdsPatchDllDatas, SizeOf(defBdsPatchDllDatas));
end;

procedure TMainForm.PatchLicenseHostsFile;
var
  F, S: string;
  nIndex, I: Integer;
  pList, pHosts: PStrListEx;
begin
  F := GetSystemHostsFile;
  pHosts := NewStrListEx;
  with pHosts^ do
  try
    if FileExists(F) then
      LoadFromFile(F);
    pList := NewStrListEx;
    for S in defLicenseHosts do
      pList.Add(S);
    for I := 0 to Count - 1 do
    begin
      S := Trim(Items[I]);
      nIndex := pList.IndexOf(S);
      if nIndex >= 0 then
        pList.Delete(nIndex);
    end;
    if pList.Count > 0 then
    try
      AddStrings(pList);
      FileSetReadOnly(F, False);
      SaveToFile(F);
    except
      on E: Exception do
        LogMessage('Disable Hosts Error: ' + E.Message);
    end;
    pList.Free;
  finally
    Free;
  end;
end;

procedure TMainForm.RestoreBdsFile;
var
  S: string;
begin
  S := FBdsPath + 'Bin\' + defBdsPatchFileName;
  SysUtils.DeleteFile(S);;
end;

procedure TMainForm.RestoreLicenseHostsFile;
var
  F, S: string;
  nIndex, nRet, I: Integer;
  pList, pHosts: PStrListEx;
begin
  F := GetSystemHostsFile;
  if not FileExists(F) then
    Exit;
  pHosts := NewStrListEx;
  with pHosts^ do
  try
    LoadFromFile(F);
    pList := NewStrListEx;
    for S in defLicenseHosts do
      pList.Add(S);
    nRet := 0;
    for I := Count - 1 downto 0 do
    begin
      S := Trim(Items[I]);
      nIndex := pList.IndexOf(S);
      if nIndex < 0 then
        Continue;
      pHosts.Delete(I);
      Inc(nRet);
    end;
    if nRet > 0 then
    try
      FileSetReadOnly(F, False);
      SaveToFile(F);
    except
      on E: Exception do
        LogMessage('Disable Hosts Error: ' + E.Message);
    end;
    pList.Free;
  finally
    Free;
  end;
end;

procedure TMainForm.ShowAboutMessage;
begin
  with Self.Form^ do
    ShellAbout(Handle, PChar(string(Caption) + ', Lsuper'), PAnsiChar(AnsiString(defAppMessage)), Icon);
end;

end.
