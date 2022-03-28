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
//    BdsPatchInfo:TPatchInfo;
//    LicenseManagerPatchInfo:TPatchInfo;
//    mOasisRuntimePatchInfo:TPatchInfo;
//    SetupGUID:string;
//    ISOUrl:string;
//    ISOMd5:string;
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
    Name := 'Rad Studio 10.3.3 Rio 7899 Architect';
    Ver := '26.0.36039.7899';
    BDSVersion := '20.0';
    LicVerStr := '10.3';
    LicHostPID := 8220;
    LicHostSKU := 53;
    LicDelphiPID := '2026';
    LicCBuilderPID := '4023';
//    BdsPatchInfo.Crc := $C426EC4A;
//    BdsPatchInfo.Sha1 := '43BB879FE9EFD7B8752F2B5D99DF31F7CD948D68';
//    BdsPatchInfo.PatchOffset := $1F724;
//    BdsPatchInfo.FinalizeArrayOffset := $11EF7C;
//    LicenseManagerPatchInfo.Crc := $0D512F70;
//    LicenseManagerPatchInfo.Sha1 := '8D16D4521BCC12D537EB20B33864654E7A5B81C0';
//    LicenseManagerPatchInfo.PatchOffset := $1F002C;
//    LicenseManagerPatchInfo.FinalizeArrayOffset := $6227A4;
//    mOasisRuntimePatchInfo.Sha1 := '101FC6D71A1DDEAF3B079477560DD0307ADE3C80';
//    mOasisRuntimePatchInfo.PatchOffset := $0016CFE9;
//    SetupGUID := '{426A3606-6CB8-4CF8-87A8-44388377C47D}';
//    ISOUrl := 'http://altd.embarcadero.com/download/radstudio/10.3/delphicbuilder10_3_0_94364.iso';
//    ISOMd5 := '0882D58CB53A7D0A828CC45D06C6ECD0';
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
