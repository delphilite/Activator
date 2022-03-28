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
    btnRunBds: TKOLButton;
    kolActivator: TKOLProject;
    kolMainForm: TKOLForm;
    procedure btnAboutClick(Sender: PObj);
    procedure btnActiveClick(Sender: PObj);
    procedure btnExitClick(Sender: PObj);
    procedure btnResetClick(Sender: PObj);
    procedure btnRunBdsClick(Sender: PObj);
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

    procedure CopyFile(const ASrcFile, ADestFile: string);

    procedure DeleteFile(const AFile: string);
    procedure DeleteFiles(const AFileMask: string);
  private
    procedure BuildNormalCglmFile;
    procedure BuildNormalSlipFile;

    procedure GenerateRegistrationCode;
    procedure GenerateKeyGenLicense;

    procedure PatchLicenseHostsFile;
    procedure RestoreLicenseHostsFile;

    procedure PatchBdsFile;
    procedure RestoreBdsFile;

    procedure DeleteTrialFiles;
    procedure DeleteTrialRegKeys;
  private
    procedure DoActive;
    procedure DoReset;
    procedure DoRunBds;

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
  SysUtils, ShellAPI, Registry, FileUtils, PatchData, WinUtils, RadKeygen, RadVersion;

{$IF Defined(KOL_MCK)}{$ELSE}{$R *.DFM}{$IFEND}

{$IFDEF KOL_MCK}
{$I MainFrm_1.inc}
{$ENDIF}

const
  CSIDL_APPDATA         = $001A; // Application Data, new for NT4, <user name>\Application Data
  CSIDL_COMMON_APPDATA  = $0023; // All Users\Application Data

  UM_SHOWABOUT          = 100;

const
  defAppMessage         = 'Many thanks to elseif, tonzi, freecat, unis, x-force, cjack and others who worked for this keygen!';
  defAppVersion         = '15.3';

  defAppHelperFileName  = 'SHFolder.dll';

  defBdsVersion         = '20.0';

  defBdsLicenseFile     = 'RADStudio10_2.slip';
  defBdsLicenseManager  = '"%s" -reg -skey 8220_21 -loadKey 2026 -a';

  defBdsPatchFileName   = 'SHFolder.dll';

  defLicenseHosts: array[0..17] of string = (
    '127.0.0.1 appanalytics.embarcadero.com',
    '127.0.0.1 comapi.embarcadero.com',
    '127.0.0.1 embt.usertility.com',
    '127.0.0.1 external.ws.sanctx.embarcadero.com',
    '127.0.0.1 getit.embarcadero.com',
    '127.0.0.1 installers.codegear.com',
    '127.0.0.1 installers.embarcadero.com',
    '127.0.0.1 license-stage.codegear.com',
    '127.0.0.1 license.codegear.com',
    '127.0.0.1 license.embarcadero.com',
    '127.0.0.1 object.ws.sanctx.embarcadero.com',
    '127.0.0.1 services.server.v8.srs.sanctuary.codegear.com',
    '127.0.0.1 themindelectric.com',
    '127.0.0.1 track.embarcadero.com',
    '127.0.0.1 www.themindelectric.com',

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
{$IFDEF DEBUGMODE}
  LogMessage('About');
{$ENDIF}
  ShowAboutMessage;
end;

procedure TMainForm.btnActiveClick(Sender: PObj);
begin
{$IFDEF DEBUGMODE}
  LogMessage('Active');
{$ENDIF}
  BeginCursor;
  try
    DoActive;
  finally
    EndCursor;
  end;
end;

procedure TMainForm.btnExitClick(Sender: PObj);
begin
{$IFDEF DEBUGMODE}
  LogMessage('Exit');
{$ENDIF}
  Self.Form.Close;
end;

procedure TMainForm.btnResetClick(Sender: PObj);
begin
{$IFDEF DEBUGMODE}
  LogMessage('Reset');
{$ENDIF}
  BeginCursor;
  try
    DoReset;
  finally
    EndCursor;
  end;
end;

procedure TMainForm.btnRunBdsClick(Sender: PObj);
begin
{$IFDEF DEBUGMODE}
  LogMessage('Run');
{$ENDIF}
  BeginCursor;
  try
    DoRunBds;
  finally
    EndCursor;
  end;
end;

procedure TMainForm.BuildNormalCglmFile;
var
  S: string;
begin
  S := FBdsPath + 'Bin\cglm.ini';
  SaveDataToFile(S, defCglmFileDatas, Length(defCglmFileDatas));
  S := GetShellFolderPath(CSIDL_COMMON_APPDATA) + 'Embarcadero\Studio\' + defBdsVersion + '\cglm.ini';
  SaveDataToFile(S, defCglmFileDatas, Length(defCglmFileDatas));
end;

procedure TMainForm.BuildNormalSlipFile;
var
  S: string;
begin
  S := FBdsPath + 'License\*.slip';
  DeleteFiles(S);
  S := FBdsPath + 'License\' + defBdsLicenseFile;
  SaveDataToFile(S, defSlipFileDatas, Length(defSlipFileDatas));
end;

procedure TMainForm.CopyFile(const ASrcFile, ADestFile: string);
{$IFDEF DEBUGMODE}
var
  bRet: Boolean;
{$ENDIF}
begin
{$IFDEF DEBUGMODE}
  bRet := Windows.CopyFile(PChar(ASrcFile), PChar(ADestFile), False);
  if bRet then
    LogMessage('CopyFile.OK: ' + ADestFile)
  else LogMessage('CopyFile.Error: ' + ADestFile + ', ' + SysErrorMessage(GetLastError));
{$ELSE}
  Windows.CopyFile(PChar(ASrcFile), PChar(ADestFile), False);
{$ENDIF}
end;

procedure TMainForm.DeleteFile(const AFile: string);
{$IFDEF DEBUGMODE}
var
  bRet: Boolean;
{$ENDIF}
begin
{$IFDEF DEBUGMODE}
  LogMessage('DeleteFile: ' + AFile + ' ...');
  bRet := Windows.DeleteFile(PChar(AFile));
  if bRet then
    LogMessage('DeleteFile.OK: ' + AFile)
  else LogMessage('DeleteFile.Error: ' + AFile + ', ' + SysErrorMessage(GetLastError));
{$ELSE}
  Windows.DeleteFile(PChar(AFile));
{$ENDIF}
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
{$IFDEF DEBUGMODE}
  LogMessage('DeleteFiles: ' + AFileMask + ' ...');
{$ENDIF}
  strFilePath := ExtractFilePath(AFileMask);
  if FindFirst(AFileMask, faAnyFile, cSearchRec) = 0 then
  repeat
    if (cSearchRec.Name <> '') and not IsDirNotation(cSearchRec.Name) then
    begin
{$IFDEF DEBUGMODE}
      LogMessage('DeleteFiles, File: ' + strFilePath + cSearchRec.Name);
{$ENDIF}
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
{$IFDEF DEBUGMODE}
  LogMessage('DeleteTrialFiles');
{$ENDIF}
  AllUsersPath := GetShellFolderPath(CSIDL_COMMON_APPDATA) + 'Embarcadero\';
  UserPath := GetShellFolderPath(CSIDL_APPDATA) + 'Embarcadero\';

{$IFDEF DEBUGMODE}
  LogMessage('DeleteTrialFiles.AllUsersPath: ' + AllUsersPath);
  LogMessage('DeleteTrialFiles.UserPath: ' + UserPath);
{$ENDIF}

  DeleteFile(UserPath + '.cgb_license');
  DeleteFile(AllUsersPath + '.cgb_license');

  DeleteFile(UserPath + '.licenses\.cg_license');
  DeleteFile(AllUsersPath + '.licenses\.cg_license');

  DeleteFile(AllUsersPath + 'RAD Studio Activation.slip');

  DeleteFiles(AllUsersPath + '.82*.slip');
end;

procedure TMainForm.DeleteTrialRegKeys;
begin
{$IFDEF DEBUGMODE}
  LogMessage('DeleteTrialRegKeys');
{$ENDIF}
end;

procedure TMainForm.DoActive;
var
  S: string;
  nBuild: Integer;
begin
{$IFDEF DEBUGMODE}
  LogMessage('DoActive');
{$ENDIF}
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
  BuildNormalCglmFile;
  BuildNormalSlipFile;
  RestoreBdsFile;

  GenerateRegistrationCode;
  GenerateKeyGenLicense;
  PatchBdsFile;
  PatchLicenseHostsFile;
{
  ShowMessage('Active', 'OK!');
}
  ShowMessage('Active', 'OK! Code: ' + FRegCode + ', Serial: ' + FSerialNumber);
end;

procedure TMainForm.DoReset;
begin
{$IFDEF DEBUGMODE}
  LogMessage('DoReset');
{$ENDIF}
  if not FindBdsPath then
  begin
    ShowError('No BDS find!');
    Exit;
  end;
  DeleteTrialFiles;
  DeleteTrialRegKeys;
  BuildNormalCglmFile;
  BuildNormalSlipFile;
  RestoreBdsFile;
  RestoreLicenseHostsFile;
  ShowMessage('Reset', 'OK!');
end;

procedure TMainForm.DoRunBds;
var
  BdsExe: string;
begin
{$IFDEF DEBUGMODE}
  LogMessage('DoRunBds');
{$ENDIF}
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
  BuildNormalCglmFile;
  BuildNormalSlipFile;
  PatchBdsFile;
  PatchLicenseHostsFile;
{
  LogMessage('Done.');
}
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

  function CurrentRadStudioVersion: PRadStudioVersion; inline;
  begin
    Assert(RadStudioVersionList.Count > 0);
    Result := PRadStudioVersion(RadStudioVersionList.Objects[0]);
  end;
begin
{$IFDEF DEBUGMODE}
  LogMessage('GenerateKeyGenLicense');
{$ENDIF}
  FSerialNumber := RadKeygen.GenerateSerialNumber;
  FRegCode := RadKeygen.GetRegistrationCode;
  RadKeygen.GenerateLicenseFile(FSerialNumber, FRegCode, CurrentRadStudioVersion, FInformation);
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
{$IFDEF DEBUGMODE}
  LogMessage('GenerateRegistrationCode');
{$ENDIF}
  strHelper := FAppPath + defAppHelperFileName;
  if not FileExists(strHelper) then
    SaveDataToFile(strHelper, defHelperDatas, Length(defHelperDatas));
  strWorkDir := FBdsPath + 'Bin';
  strCommandLine := Format('%s\LicenseManager.exe', [strWorkDir]);
  if not FileExists(strCommandLine) then
    raise Exception.CreateFmt('File %s not exists!', [strCommandLine]);
  strCommandLine := Format(defBdsLicenseManager, [strCommandLine]);
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
    if nExitCode <> 0 then
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
{$IFDEF DEBUGMODE}
  LogMessage('PatchBdsFile');
{$ENDIF}
  S := FBdsPath + 'Bin\' + defBdsPatchFileName;
{$IFDEF DEBUGMODE}
  LogMessage('Patch: ' + S);
{$ENDIF}
  SaveDataToFile(S, defBdsPatchDllDatas, SizeOf(defBdsPatchDllDatas));
end;

procedure TMainForm.PatchLicenseHostsFile;
var
  F, S: string;
  nIndex, I: Integer;
  pList, pHosts: PStrListEx;
begin
{$IFDEF DEBUGMODE}
  LogMessage('PatchLicenseHostsFile');
{$ENDIF}
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
{$IFDEF DEBUGMODE}
      LogMessage('PatchLicenseHostsFile, SaveToFile: ' + F);
{$ENDIF}
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
{$IFDEF DEBUGMODE}
  LogMessage('RestoreBdsFile');
{$ENDIF}
  S := FBdsPath + 'Bin\' + defBdsPatchFileName;
{$IFDEF DEBUGMODE}
  LogMessage('Restore: ' + S);
{$ENDIF}
  Self.DeleteFile(S);;
end;

procedure TMainForm.RestoreLicenseHostsFile;
var
  F, S: string;
  nIndex, nRet, I: Integer;
  pList, pHosts: PStrListEx;
begin
{$IFDEF DEBUGMODE}
  LogMessage('RestoreLicenseHostsFile');
{$ENDIF}
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
{$IFDEF DEBUGMODE}
      LogMessage('RestoreLicenseHostsFile, SaveToFile: ' + F);
{$ENDIF}
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
