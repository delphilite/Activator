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
    Name:string;                          //  Rad Studio 10.1 Berlin Update1
    Ver:string;                           //  24.0.24468.8770
    BDSVersion:string;                   //  18.0
    LicVerStr:string;                        //  10.1 Berlin
    LicHostPID:Integer;                   //  8218
    LicHostSKU:Integer;                   //  53
    LicDelphiPID:string;
    LicCBuilderPID:string;
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
    Name:='Rad Studio 10.2.1 Tokyo';
    Ver:= '25.0.27659.1188';
    BDSVersion:='19.0';
    LicVerStr:= '10.2 Tokyo';
    LicHostPID:= 8219;
    LicHostSKU:= 52;
    LicDelphiPID:='2025';
    LicCBuilderPID:='4022';
    BdsPatchInfo.Crc:=$bc350a66;
    BdsPatchInfo.Sha1:='67a1602a64297743f12758ce74b437f596054e30';
    BdsPatchInfo.PatchOffset:=$1E7D9;
    BdsPatchInfo.FinalizeArrayOffset:=$10BFFC;
    LicenseManagerPatchInfo.Crc:=$0c209f01;
    LicenseManagerPatchInfo.Sha1:='65b07e3d273a3c1ec0f722266ad73375d02e69a0';
    LicenseManagerPatchInfo.PatchOffset:=$001B6FAD;
    LicenseManagerPatchInfo.FinalizeArrayOffset:=$6077D4;
    mOasisRuntimePatchInfo.Sha1:='39ecf2e1a55c62ba56efd861d7bde7dd83f8551f';
    mOasisRuntimePatchInfo.PatchOffset:=$00165FD5;
    SetupGUID:='{157FDBBC-21E6-4B45-A995-CA25BB2864BF}';
    ISOUrl:='http://altd.embarcadero.com/download/radstudio/10.2/delphicbuilder10_2_1.iso';
    ISOMd5:='3f7028be8d3831b098102e9bf5732e3b';
  end;
  VerList.AddObject(RadStudioVersion^.Name,TObject(RadStudioVersion));


  New(RadStudioVersion);
  with RadStudioVersion^ do
  begin
    Name:='Rad Studio 10.2 Tokyo';
    Ver:= '25.0.26309.314';
    BDSVersion:='19.0';
    LicVerStr:= '10.2 Tokyo';
    LicHostPID:= 8219;
    LicHostSKU:= 52;
    LicDelphiPID:='2025';
    LicCBuilderPID:='4022';
    BdsPatchInfo.Crc:=$23d6bbc6;
    BdsPatchInfo.Sha1:='6b61fe60e4f806913fdf103e294200d1341089ba';
    BdsPatchInfo.PatchOffset:=$1E7D5;
    BdsPatchInfo.FinalizeArrayOffset:=$26886C;
    LicenseManagerPatchInfo.Crc:=$34d8a9ba;
    LicenseManagerPatchInfo.Sha1:='a2feb2da6e8b7cc7660ed2b54eec1cad09daeb6c';
    LicenseManagerPatchInfo.PatchOffset:=$001E4209;
    LicenseManagerPatchInfo.FinalizeArrayOffset:=$660B6C;
    mOasisRuntimePatchInfo.Sha1:='39ecf2e1a55c62ba56efd861d7bde7dd83f8551f';
    mOasisRuntimePatchInfo.PatchOffset:=$00165FD5;
    SetupGUID:='{0556178E-2062-46E3-8FE9-E620C40DB02B}';
    ISOUrl:='http://altd.embarcadero.com/download/radstudio/10.2/delphicbuilder10_2.iso';
    ISOMd5:='8855db8d40993c18672f226bf395bfcd';
  end;
  VerList.AddObject(RadStudioVersion^.Name,TObject(RadStudioVersion));


  New(RadStudioVersion);
  with RadStudioVersion^ do
  begin
    Name:='Rad Studio 10.1 Berlin Update2';
    Ver:= '24.0.25048.9432';
    BDSVersion:='18.0';
    LicVerStr:= '10.1 Berlin';
    LicHostPID:= 8218;
    LicHostSKU:= 53;
    LicDelphiPID:='2024';
    LicCBuilderPID:='4021';
    BdsPatchInfo.Crc:=$a1315aab;
    BdsPatchInfo.Sha1:='9627eeef0574f46f4ec9348b806d30c9c37ad3ed';
    BdsPatchInfo.PatchOffset:=$5143D;
    BdsPatchInfo.FinalizeArrayOffset:=$264604;
    LicenseManagerPatchInfo.Crc:=$9189a95c;
    LicenseManagerPatchInfo.Sha1:='493ebece2682544c2d6c2bbbdba5b6da70ca73e1';
    LicenseManagerPatchInfo.PatchOffset:=$1E82E5;
    LicenseManagerPatchInfo.FinalizeArrayOffset:=$671A18;
    mOasisRuntimePatchInfo.Sha1:='39ecf2e1a55c62ba56efd861d7bde7dd83f8551f';
    mOasisRuntimePatchInfo.PatchOffset:=$00165FD5;
    SetupGUID:='{2008E4BD-A356-4759-8A78-18636D2E75C9}';
    ISOUrl:='http://altd.embarcadero.com/download/radstudio/10.1/radstudio10_1_upd2_esd.iso';
    ISOMd5:='920f0acf67122bb04ed55edd7a1c7579';
  end;
  VerList.AddObject(RadStudioVersion^.Name,TObject(RadStudioVersion));
  
  New(RadStudioVersion);
  with RadStudioVersion^ do
  begin
    Name:='Rad Studio 10.1 Berlin Update1';
    Ver:= '24.0.24468.8770';
    BDSVersion:='18.0';
    LicVerStr:= '10.1 Berlin';
    LicHostPID:= 8218;
    LicHostSKU:= 53;
    LicDelphiPID:='2024';
    LicCBuilderPID:='4021';
    BdsPatchInfo.Crc:=$9626A6DC;
    BdsPatchInfo.Sha1:='82d3cd849786f2ece428ab7518ec9ecf47d475e6';
    BdsPatchInfo.PatchOffset:=$51449;
    BdsPatchInfo.FinalizeArrayOffset:=$264584;
    LicenseManagerPatchInfo.Crc:=$3B314A18;
    LicenseManagerPatchInfo.Sha1:='79b342e41f97728e16c6302e08b44f89b0655a9e';
    LicenseManagerPatchInfo.PatchOffset:=$1E8FB5;
    LicenseManagerPatchInfo.FinalizeArrayOffset:=$6729E0;
    mOasisRuntimePatchInfo.Sha1:='7aa466dd1d2c685edd69ee41d1c8ebc1d2b56bb4';
    mOasisRuntimePatchInfo.PatchOffset:=$00162CBD;
    SetupGUID:='{37C118B3-EF7F-4110-BFE5-E866FB456C8E}';
    ISOUrl:='http://altd.embarcadero.com/download/radstudio/10.1/delphicbuilder10_1_upd1.iso';
    ISOMd5:='a85a0fba4f8bab121312184cda85c198';
  end;
  VerList.AddObject(RadStudioVersion^.Name,TObject(RadStudioVersion));

  New(RadStudioVersion);
  with RadStudioVersion^ do
  begin
    Name:='Rad Studio 10.1 Berlin';
    Ver:= '24.0.22858.6822';
    BDSVersion:='18.0';
    LicVerStr:= '10.1 Berlin';
    LicHostPID:= 8218;
    LicHostSKU:= 53;
    LicDelphiPID:='2024';
    LicCBuilderPID:='4021';
    BdsPatchInfo.Crc:=$1BA3E394;
    BdsPatchInfo.Sha1:='a492883335230bced0651338584fbe8c49bd94a8';
    BdsPatchInfo.PatchOffset:=$51449;
    BdsPatchInfo.FinalizeArrayOffset:=$264584;
    LicenseManagerPatchInfo.Crc:=$D2BAA257;
    LicenseManagerPatchInfo.Sha1:='d0d024b97d02608a505fb0e667dd564b53c91b13';
    LicenseManagerPatchInfo.PatchOffset:=$1E9035;
    LicenseManagerPatchInfo.FinalizeArrayOffset:=$6719B8;
    mOasisRuntimePatchInfo.Sha1:='7aa466dd1d2c685edd69ee41d1c8ebc1d2b56bb4';
    mOasisRuntimePatchInfo.PatchOffset:=$00162CBD;
    SetupGUID:='{655CBACE-A23C-42B8-B924-A88E80F352B5}';
    ISOUrl:='http://altd.embarcadero.com/download/radstudio/10.1/delphicbuilder10_1.iso';
    ISOMd5:='466d2db93e5b3b631eabba69d052b28f';
  end;
  VerList.AddObject(RadStudioVersion^.Name,TObject(RadStudioVersion));

  New(RadStudioVersion);
  with RadStudioVersion^ do
  begin
    Name:='Rad Studio 10 Seattle Update1';
    Ver:= '23.0.21418.4207';
    BDSVersion:='17.0';
    LicVerStr:= '10 Seattle';
    LicHostPID:= 8217;
    LicHostSKU:= 53;
    LicDelphiPID:='2023';
    LicCBuilderPID:='4020';
    BdsPatchInfo.Crc:=$b5bd665f;
    BdsPatchInfo.Sha1:='e8cc301efc449f90750d921ab73be31d824c08c6';
    BdsPatchInfo.PatchOffset:=$4fe51;
    BdsPatchInfo.FinalizeArrayOffset:=$225f84;
    LicenseManagerPatchInfo.Crc:=$8395454d;
    LicenseManagerPatchInfo.Sha1:='0ca4640d6c1c2f470ff3182809b881a97e76e534';
    LicenseManagerPatchInfo.PatchOffset:=$1ca696;
    LicenseManagerPatchInfo.FinalizeArrayOffset:=$6306ac;
    mOasisRuntimePatchInfo.Sha1:='7aa466dd1d2c685edd69ee41d1c8ebc1d2b56bb4';
    mOasisRuntimePatchInfo.PatchOffset:=$00162CBD;
    SetupGUID:='{5D50B637-4756-435A-816E-68ABFE86FC69}';
    ISOUrl:='http://altd.embarcadero.com/download/radstudio/10/delphicbuilder10___upd1.iso';
    ISOMd5:='34bf51b0f017541b8521e7efd2b6fbee';
  end;
  VerList.AddObject(RadStudioVersion^.Name,TObject(RadStudioVersion));

  New(RadStudioVersion);
  with RadStudioVersion^ do
  begin
    Name:='Rad Studio 10 Seattle';
    Ver:= '23.0.20618.2753';
    BDSVersion:='17.0';
    LicVerStr:= '10 Seattle';
    LicHostPID:= 8217;
    LicHostSKU:= 53;
    LicDelphiPID:='2023';
    LicCBuilderPID:='4020';
    BdsPatchInfo.Crc:=$59176e2b;
    BdsPatchInfo.Sha1:='0f4255ee60dc860bdcf75c3358d03674757474a5';
    BdsPatchInfo.PatchOffset:=$500ea;
    BdsPatchInfo.FinalizeArrayOffset:=$225ec8;
    LicenseManagerPatchInfo.Crc:=$d06c02b0;
    LicenseManagerPatchInfo.Sha1:='4ff37906e7283448aecab34c73c8dbe3d45f55a6';
    LicenseManagerPatchInfo.PatchOffset:=$1ca98a;
    LicenseManagerPatchInfo.FinalizeArrayOffset:=$630634;
    mOasisRuntimePatchInfo.Sha1:='7aa466dd1d2c685edd69ee41d1c8ebc1d2b56bb4';
    mOasisRuntimePatchInfo.PatchOffset:=$00162CBD;
    SetupGUID:='{09FECC13-2950-4AE6-BB23-05C206979F18}';
    ISOUrl:='http://altd.embarcadero.com/download/radstudio/10/delphicbuilder10.iso';
    ISOMd5:='9d4bac568aced7f1f82d4a44124fb37c';
  end;
  VerList.AddObject(RadStudioVersion^.Name,TObject(RadStudioVersion));

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
