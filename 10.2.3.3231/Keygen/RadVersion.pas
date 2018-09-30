unit RadVersion;

interface
uses Windows,Classes,SysUtils;
type
  TPatchInfo=record
    Crc:DWORD;
    Sha1:string;
    PatchOffset:DWORD;
    FinalizeArrayOffset:DWORD;
  end;

  TRadStudioVersion=record
    Name:string;                          //  Rad Studio 10.2 Tokyo Update2
    Ver:string;                           //  25.0.29039.2004
    BDSVersion:string;                    //  19.0
    LicVerStr:string;                     //  10.2 Tokyo
    LicHostPID:Integer;                   //  8219
    LicHostSKU:Integer;                   //  52
    LicDelphiPID:string;                  //  2025
    LicCBuilderPID:string;                //  4022
    BdsPatchInfo:TPatchInfo;
    LicenseManagerPatchInfo:TPatchInfo;
    mOasisRuntimePatchInfo:TPatchInfo;
    SetupGUID:string;
    ISOUrl:string;
    ISOMd5:string;
  end;
  PRadStudioVersion=^TRadStudioVersion;
var
  RadStudioVersionList:TStringList;
implementation

procedure InitRadStudioVersion(VerList:TStringList);
var
  RadStudioVersion:PRadStudioVersion;
begin
  New(RadStudioVersion);
  with RadStudioVersion^ do
  begin
    Name := 'Rad Studio 10.2.3 Tokyo 3231';
    Ver := '25.0.31059.3231';
    BDSVersion := '19.0';
    LicVerStr := '10.2 Tokyo';
    LicHostPID := 8219;
    LicHostSKU := 52;
    LicDelphiPID := '2025';
    LicCBuilderPID := '4022';
    BdsPatchInfo.Crc := $CE8FA21E;
    BdsPatchInfo.Sha1 := '8daa98dbc558ec81cf582ec8c71233d9ab5fb76a';
    BdsPatchInfo.PatchOffset := $1E95D;
    BdsPatchInfo.FinalizeArrayOffset := $111268;
    LicenseManagerPatchInfo.Crc := $1127F753;
    LicenseManagerPatchInfo.Sha1 := '485dcb165cdefe3f3e50090bf8cfafb8bca5b46f';
    LicenseManagerPatchInfo.PatchOffset := $1E4939;
    LicenseManagerPatchInfo.FinalizeArrayOffset := $607828;
    mOasisRuntimePatchInfo.Sha1 := '30dc7ee5931b2f88904c60b5469144673bc544a8';
    mOasisRuntimePatchInfo.PatchOffset := $166F85;
    SetupGUID := '{15CEC4B7-6F61-4D40-9491-255657E369A2}';
    ISOUrl:='http://altd.embarcadero.com/download/radstudio/10.2/delphicbuilder10_2_3__93231.iso';
    ISOMd5:='40D693B9989F7CCDF07C07EA676D1AB2';
  end;
  VerList.AddObject(RadStudioVersion^.Name, TObject(RadStudioVersion));
end;

procedure FinallyRadStudioVersion(VerList:TStringList);
var
  RadStudioVersion:PRadStudioVersion;
begin
  while VerList.Count>0 do
  begin
    RadStudioVersion:=PRadStudioVersion(VerList.Objects[0]);
    if RadStudioVersion<>nil then Dispose(RadStudioVersion);
    VerList.Delete(0);
  end;
end;  

initialization
  RadStudioVersionList:= TStringList.Create;
  InitRadStudioVersion(RadStudioVersionList);
finalization
  FinallyRadStudioVersion(RadStudioVersionList);
  FreeAndNil(RadStudioVersionList);

end.
