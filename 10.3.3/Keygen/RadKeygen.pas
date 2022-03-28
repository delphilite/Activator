unit RadKeygen;

interface

uses
  SysUtils, Classes, Windows, Registry, SHFolder, Sha1, FGInt, RadVersion, RadLicense;

  function GenerateSerialNumber():string;
  function GetRegistrationCode():string;
  function GenerateLicenseFile(SerialNumber,RegistrationCode:string;RadStudioVersion:PRadStudioVersion;var FileName:string):Boolean;

implementation

function GetAppDataPath():string;
var
  Path:array [0..MAX_PATH-1] of Char;
begin
  if Succeeded(SHGetFolderPath(0, CSIDL_COMMON_APPDATA, 0, 0, @Path[0])) then
    Result:=string(Path)
  else
    Result:='';
end;

function GenerateSerialNumber():string;
const
  StrMap:string='ABC2DE34FGHJKLM5NPQRST6U7VWX8YZ9';
  ByteMap:array[0..255] of Byte=($00, $07, $0E, $09, $1C, $1B, $12, $15, $38, $3F,
                                $36, $31, $24, $23, $2A, $2D, $70, $77, $7E, $79,
                                $6C, $6B, $62, $65, $48, $4F, $46, $41, $54, $53,
                                $5A, $5D, $E0, $E7, $EE, $E9, $FC, $FB, $F2, $F5,
                                $D8, $DF, $D6, $D1, $C4, $C3, $CA, $CD, $90, $97,
                                $9E, $99, $8C, $8B, $82, $85, $A8, $AF, $A6, $A1,
                                $B4, $B3, $BA, $BD, $C7, $C0, $C9, $CE, $DB, $DC,
                                $D5, $D2, $FF, $F8, $F1, $F6, $E3, $E4, $ED, $EA,
                                $B7, $B0, $B9, $BE, $AB, $AC, $A5, $A2, $8F, $88,
                                $81, $86, $93, $94, $9D, $9A, $27, $20, $29, $2E,
                                $3B, $3C, $35, $32, $1F, $18, $11, $16, $03, $04,
                                $0D, $0A, $57, $50, $59, $5E, $4B, $4C, $45, $42,
                                $6F, $68, $61, $66, $73, $74, $7D, $7A, $89, $8E,
                                $87, $80, $95, $92, $9B, $9C, $B1, $B6, $BF, $B8,
                                $AD, $AA, $A3, $A4, $F9, $FE, $F7, $F0, $E5, $E2,
                                $EB, $EC, $C1, $C6, $CF, $C8, $DD, $DA, $D3, $D4,
                                $69, $6E, $67, $60, $75, $72, $7B, $7C, $51, $56,
                                $5F, $58, $4D, $4A, $43, $44, $19, $1E, $17, $10,
                                $05, $02, $0B, $0C, $21, $26, $2F, $28, $3D, $3A,
                                $33, $34, $4E, $49, $40, $47, $52, $55, $5C, $5B,
                                $76, $71, $78, $7F, $6A, $6D, $64, $63, $3E, $39,
                                $30, $37, $22, $25, $2C, $2B, $06, $01, $08, $0F,
                                $1A, $1D, $14, $13, $AE, $A9, $A0, $A7, $B2, $B5,
                                $BC, $BB, $96, $91, $98, $9F, $8A, $8D, $84, $83,
                                $DE, $D9, $D0, $D7, $C2, $C5, $CC, $CB, $E6, $E1,
                                $E8, $EF, $FA, $FD, $F4, $F3);
var
  i,v1,v2,v3,v4,v5,v6,v7,v8,v9:Integer;
  SumValue:string;
  ByteArray:array[0..19] of Byte;
begin
  Randomize();
  v1:=0;
  v2:=0;
  v3:=0;
  v4:=0;
  v5:=1;
  v6:=8217;
  v7:=53;
  v8:= Random(32) shl 8;
  v8:=v8 xor Random(32);
  v8:= v8 mod $10000;
  SumValue:=Format('%d',[v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8]);
  v9:=0;

  for i := 0 to Length(SumValue)-1 do
  begin
    v9:=v9 xor ByteMap[Ord(SumValue[i+1])];
  end;
  ByteArray[0] := ((v8 shr 1) and 8) or ((v8 shr 5) and 4) or (2 * v5 and 2);
  ByteArray[1] := ((v7 shr 1) and 16) or ((v7 shr 4) and 8) or ((v6 shr 5) and 2) or ((v6 shr 8) and 1);
  ByteArray[2] := (2 * v7 and 16) or (8 * v8 and 8) or ((v5 shr 1) and 4) or ((v6 shr 4) and 2) or (v3 and 1);
  ByteArray[3] := (4 * v5 and 16);
  ByteArray[4] := (4 * v9 and 16) or ((v6 shr 4) and 8);
  ByteArray[5] := (8 * v4 and 8) or ((v8 shr 1) and 4) or ((v8 shr 12) and 2);
  ByteArray[6] := ((v9 shr 3) and 8) or ((v8 shr 4) and 4) or (2 * v1 and 2);
  ByteArray[7] := ((v8 shr 11) and 16) or ((v8 shr 7) and 8) or (4 * v6 and 4) or ((v5 shr 3) and 2);
  ByteArray[8] := ((v8 shr 7) and 16) or ((v6 shr 1) and 1);
  ByteArray[9] := (4 * v6 and 16) or (v9 and 8) or (v8 and 4);
  ByteArray[10] := ((v8 shr 9) and 8);
  ByteArray[11] := (4 * v9 and 8) or (4 * v9 and 4) or (v8 and 2) or ((v8 shr 5) and 1);
  ByteArray[12] := ((v8 shr 8) and 1);
  ByteArray[13] := ((v6 shr 7) and 16) or ((v9 shr 7) and 1);
  ByteArray[14] := (2 * v7 and 2) or ((v7 shr 1) and 1);
  ByteArray[15] := (v6 and 8) or ((v6 shr 2) and 4) or ((v8 shr 9) and 1);
  ByteArray[16] := (16 * v2 and 16) or (2 * v7 and 8) or ((v5 shr 1) and 1);
  ByteArray[17] := ((v9 shr 3) and 2);
  ByteArray[18] := (v7 and 16) or ((v6 shr 6) and 8) or ((v6 shr 8) and 4) or ((v8 shr 13) and 2) or ((v9 shr 5) and 1);
  ByteArray[19] := ((v6 shr 9) and 16) or ((v7 shr 3) and 8) or ((v6 shr 11) and 2);

  Result:='';
  for i := 0 to Length(ByteArray)-1 do
  begin
    if (i=4) or (i=10) or (i=16) then  Result:=Result+'-';
    Result:=Result+StrMap[ByteArray[i]+1];
  end;
end;

function GetRegistrationCode():string;

  function GetKey():DWORD;
  const
    KeyMap:string='ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890X';
  var
    ComputerName:array[0..MAX_PATH-1] of Char;
    Key:string;
    nSize:Cardinal;
    i,j:Integer;
  begin
    Result:=$ED864640;
    if (GetComputerName(@ComputerName[0],nSize)=False) then
      Key:='localhost'
    else
      Key:=string(ComputerName);

    Key:=UpperCase(Key);
    for i := 0 to Length(Key)-1 do
    begin
      for j := 0 to Length(KeyMap)-1 do
      begin
        if (Key[i+1]=KeyMap[j+1]) then  Break;
      end;
      if j>=Length(KeyMap) then
        Result:=Result+16*88
      else
        Result:=Result+16*Ord(KeyMap[36-j]);
    end;
  end;

var
  FileName:string;
  MemoryStream:TMemoryStream;
  dwVerify,dwSize:DWORD;
  pBuf,p:PByte;
  i,j,eax,ebx,esi:Cardinal;

begin
  Result:='';
  MemoryStream:=TMemoryStream.Create;
  try
    if GetAppDataPath<>'' then
    begin
      FileName:=GetAppDataPath+'\Embarcadero\.licenses\.cg_license';
      if FileExists(FileName) then
      begin
        MemoryStream.LoadFromFile(FileName);
      end
      else
      begin
        FileName:=GetAppDataPath+'\Embarcadero\.cg_license';
        if FileExists(FileName) then
        begin
          MemoryStream.LoadFromFile(FileName);
        end;
      end;
    end;
    if MemoryStream.Size>8 then
    begin
      MemoryStream.Position:=0;
      MemoryStream.Read(dwVerify,SizeOf(dwVerify));
      MemoryStream.Read(dwSize,SizeOf(dwSize));
      dwVerify:=(Swap(loWord(dwVerify)) shl 16) or Swap(HiWord(dwVerify));
      dwSize:=(Swap(loWord(dwSize)) shl 16) or Swap(HiWord(dwSize));
      pBuf:=AllocMem(dwSize);
      MemoryStream.Read(pBuf^,dwSize);
      p:=pBuf;
      eax:=GetKey();
      for i := 0 to dwSize-1 do
      begin
        esi:=p^;
        if (esi and $80)=$80 then esi:=esi or $ffffff00;
        ebx:=(eax shr 24) and $FF;
        p^:=p^ xor ebx;
        inc(p);
        eax:=eax xor esi;
        ebx:=eax shl 8;
        eax:=eax xor ebx;
        ebx:=eax shl 16;
        eax:= eax xor ebx;
        ebx:=eax shl 24;
        eax:=eax xor ebx;
      end;
      eax:=eax and $7FFFFFFF;
      if eax=dwVerify then
      begin
        for i := 0 to dwSize-1 do
        begin
          if PByte(Cardinal(pBuf)+i)^=36 then Break; //$
        end;
        Inc(i);
        j:=0;
        while (i<dwSize) and (PByte(Cardinal(pBuf)+i)^<>13) and (j<10) do
        begin
          Result:=Result+Chr(PByte(Cardinal(pBuf)+i)^);
          Inc(i);
          inc(j);
        end;
      end;
      FreeMem(pBuf,dwSize);
    end;
  finally
    MemoryStream.Free;
  end;
end;

function GenerateLicenseFile(SerialNumber,RegistrationCode:string;RadStudioVersion:PRadStudioVersion;var FileName:string):Boolean;
const
  ModStr:string='8EBD9E688D7106E57BCF63D41BADCE133FEB4CDB718F48F7BF39F6A26EB60BAE'+
                '0E930DC984FDED2537750C9DCFBB87D7AC7F3AA4D65D9E35C2D277BCB0ECDCA0'+
                '2D7DAE739AC8BCAE86914F6E77C17A82C77438421FC315DC38F09C7E840AF41E'+
                '663C5562222E661ED22578A234B58481F862CEABF477C89AE70F15134F83BC7E'+
                'C2EF57E7274EB74353DE22283113485D9803D4050EF46DB1467EE9D066B104EB'+
                '385D3C36BD29B58E237E22C0BE66D450BDFCED524481B6DCE3F83BBEC547F926'+
                'AD23057504DEDB9723EBFD26218167AAC79485FF608F8881D9A6AF5C57BE9A2F'+
                'B52047ABA92F806955580517F6D147BA1FD5DB3EEF1CEE4CA250D1C0FA824CD9';
  ExpStr:string='7E8325B1791B628766F2EB82057E4895DB234C1D7B4B09DB3B8BBE433D68F075'+
                '36C9B38096F51088D9DC4E7058BBD7AC9A60B1B383A3BA23E026F6A53112DE80'+
                'C191115BB9268DC509D424D8BE1FA7DBDDB7EE5CFD15C57C48A349B1008B4CCE'+
                'DCC240D31784945260E3814612FD871242FA203F5C1006A6F47FF3A807E3B4DE'+
                '39535FB5523ABED7B4337606E69245EC13BF9B553FD6F45B0FD290D7CBBEB8C8'+
                'DF2252DE7EB6A83A679873CC9842B52A093ED00742F11CD23CB5278873253E79'+
                '0E30B16AC72B7ACF9824B568ED971D768B95CA9D4C9A40C884542B8696AADF58'+
                '184CE6376E51451EF8D266ECA691ECAB25E15AA8E527312755A55C2B7D390AD9';
var
  Slip,Tmp:AnsiString;
  Len,v2,v5:Cardinal;
  FGInt,exp,modb,res:TFGInt;
  i:Integer;
  Stream:TMemoryStream;
  SearchRec:TSearchRec; 
begin
  Result:=False;
  if (Trim(SerialNumber)='') or (Trim(RegistrationCode)='') or
      (TryStrToInt(Trim(RegistrationCode),i)=False) then Exit;

  Slip:=AnsiString(CreateLicenseText(SerialNumber,RegistrationCode,RadStudioVersion));

  Len:= Length(Slip);
  Len:=(Swap(loWord(Len)) shl 16) or Swap(HiWord(Len));
  Tmp:=PChar(@Len)^+(PChar(@Len)+1)^+(PChar(@Len)+2)^+(PChar(@Len)+3)^+Slip;
  Tmp:='01'+StringOfChar('F',66)+'00'+UpperCase(SHA1Print(SHA1String(Tmp)));

  ConvertHexStringToBase256String(Tmp,Tmp);
  Base256StringToFGInt(Tmp,FGInt);

  ConvertHexStringToBase256String(ExpStr,Tmp);
  Base256StringToFGInt(Tmp,exp);

  ConvertHexStringToBase256String(ModStr,Tmp);
  Base256StringToFGInt(Tmp,modb);

  FGIntModExp(FGInt,exp,modb,res);
  FGIntToBase256String(res,Tmp);
  PGPConvertBase256to64(Tmp,Tmp);

  FGIntDestroy(FGInt);
  FGIntDestroy(exp);
  FGIntDestroy(modb);
  FGIntDestroy(res);

  Slip:=StringReplace(Slip,'e.sign'#10'0'#10,'e.sign'#10'CgeEeu66fCgQJBaqKQwwyiqyHYb22nc2VZRmQVasSDnZAtB/QTLt0CYdgdN16XCz/Nt032fMwTsytchG0l2UeA=='#10,[rfReplaceAll]);
  Slip:=StringReplace(Slip,'e.sign2'#10'0'#10,'e.sign2'#10'JWKzOwTKBL+zOP5wrouG5ta/mH+Fvsgb7hb8oJTzu4r3gK/6sh95zKAWKiydqsgvV9pxPXTAlkxv9wAecqJKTQ=='#10,[rfReplaceAll]);
  Slip:=StringReplace(Slip,'e.sign3'#10'0'#10,'e.sign3'#10+Tmp+#10,[rfReplaceAll]);

  v2:=$E7F931C2;
  for i := 0 to Length(Slip) - 1 do
  begin
    Slip[i+1]:= AnsiChar(Chr(Ord(Slip[i+1]) xor ((v2 shr 24) and $FF)));
    v5:=Ord(Slip[i+1]);
    if (v5 and $80)=$80 then v5:=v5 or $ffffff00;
    v5:= v5 xor v2;
    v5:=(v5 shl 8) xor v5;
    v5:=(v5 shl 16) xor v5;
    v5:=(v5 shl 24) xor v5;
    v2:=v5;
  end;

  v2:=(Swap(loWord(v2)) shl 16) or Swap(HiWord(v2));
  Len:=Length(Slip);
  Len:=(Swap(loWord(Len)) shl 16) or Swap(HiWord(Len));

  Stream:=TMemoryStream.Create;
  try
    Stream.Write(v2,4);
    Stream.Write(Len,4);
    Stream.Write(Slip[1],Length(Slip));
    if (FileName='') or (not DirectoryExists(ExtractFilePath(FileName))) then
    begin
      if DirectoryExists(GetAppDataPath+'\Embarcadero') then
      begin
        Tmp:=Format('%s\Embarcadero\.%d_%d.19*.slip',[GetAppDataPath,RadStudioVersion^.LicHostPID,RadStudioVersion^.LicHostSKU]);
{
        if (FindFirst(Tmp,faAnyFile,SearchRec)=0) and
          (MessageBox(0,PAnsiChar(Format('Do you want to Delete the old slip file int %s folder',[GetAppDataPath])), 'Rad Studio Keygen',MB_YESNO + MB_ICONQUESTION) = IDYES) then
}
        if (FindFirst(Tmp,faAnyFile,SearchRec)=0) then
        begin
          DeleteFile(PAnsiChar(Format('%s\Embarcadero\%s',[GetAppDataPath,SearchRec.Name])));
          while FindNext(SearchRec)=0 do
          begin
            DeleteFile(PAnsiChar(Format('%s\Embarcadero\%s',[GetAppDataPath,SearchRec.Name])));
          end;
        end;  
        SysUtils.FindClose(SearchRec);
        FileName:=Format('%s\Embarcadero\.%d_%d.19%d%d%d%d%d%d%d%d%d%d%d.slip',[GetAppDataPath,RadStudioVersion^.LicHostPID,RadStudioVersion^.LicHostSKU,
          Random(10),Random(10),Random(10),Random(10),Random(10),
          Random(10),Random(10),Random(10),Random(10),Random(10),Random(10)]);
      end
      else
        FileName:=ExtractFileDir(ParamStr(0))+'\RAD Studio Activation.slip';
    end;
    Stream.SaveToFile(FileName);
{
    PatchmOasisRuntime(RadStudioVersion);
}
    Result:=True;
  finally
    Stream.Free;
  end;
end;

end.
