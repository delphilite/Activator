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
    Name := 'Rad Studio 10.2.3 Tokyo 2631';
    Ver := '25.0.29899.2631';
    BDSVersion := '19.0';
    LicVerStr := '10.2 Tokyo';
    LicHostPID := 8219;
    LicHostSKU := 52;
    LicDelphiPID := '2025';
    LicCBuilderPID := '4022';
    BdsPatchInfo.Crc := $3D387FC1;
    BdsPatchInfo.Sha1 := '111eeb9c9061b1e125318799d1b6de83ce9d2499';
    BdsPatchInfo.PatchOffset := $1E92D;
    BdsPatchInfo.FinalizeArrayOffset := $10E100;
    LicenseManagerPatchInfo.Crc := $9F380FEB;
    LicenseManagerPatchInfo.Sha1 := '9e8ad67357cbd2e2a4cc851fc2d582f7f89882ea';
    LicenseManagerPatchInfo.PatchOffset := $1E4939;
    LicenseManagerPatchInfo.FinalizeArrayOffset := $607828;
    mOasisRuntimePatchInfo.Sha1 := '30dc7ee5931b2f88904c60b5469144673bc544a8';
    mOasisRuntimePatchInfo.PatchOffset := $166F85;
    SetupGUID := '{426F14E1-A160-430C-A48D-E84ED4F49171}';
    ISOUrl := 'http://altd.embarcadero.com/download/radstudio/10.2/delphicbuilder10_2_3_2631.iso';
    ISOMd5 := '1bd28e95596ffed061e57e28e155666d';
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
