{ *********************************************************************** }
{                                                                         }
{   工具单元                                                              }
{                                                                         }
{   设计：Lsuper 2013.02.16                                               }
{   备注：                                                                }
{   审核：                                                                }
{                                                                         }
{   Copyright (c) 1998-2014 Super Studio                                  }
{                                                                         }
{ *********************************************************************** }

unit FileUtils;

interface

uses
  SysUtils, Classes;

function  LoadDataFromFile(const AFile: string): AnsiString;
procedure SaveDataToFile(const AFile: string; const ABuffer; ASize: Integer);

implementation

uses
  Windows;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2010.01.19
//功能：加载文件内容
//参数：
////////////////////////////////////////////////////////////////////////////////
function LoadDataFromFile(const AFile: string): AnsiString;
begin
  with TFileStream.Create(AFile, fmOpenRead or fmShareDenyWrite) do
  try
    SetLength(Result, Size);
    ReadBuffer(PAnsiChar(Result)^, Size);
  finally
    Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//设计：Lsuper 2010.01.19
//功能：保存文件内容
//参数：
////////////////////////////////////////////////////////////////////////////////
procedure SaveDataToFile(const AFile: string; const ABuffer;
  ASize: Integer);
var
  F: string;
begin
  F := ExtractFileDir(AFile);
  ForceDirectories(F);
  with TFileStream.Create(AFile, fmCreate or fmShareDenyWrite) do
  try
    Position := 0;
    WriteBuffer(ABuffer, ASize);
  finally
    Free;
  end;
end;

end.
