unit RadLicense;

interface

uses RadVersion,SysUtils;

function CreateLicenseText(SerialNumber,ActiveCode:string;RadStudioVersion:PRadStudioVersion):string;

implementation

function CreateLicenseText(SerialNumber,ActiveCode:string;RadStudioVersion:PRadStudioVersion):string;
var
  pid,skuid:string;
begin
  pid:=IntToStr(RadStudioVersion^.LicHostPID);
  skuid:=IntToStr(RadStudioVersion^.LicHostSKU);

  Result:='11'#10;
  Result:=Result+'e.pkg'#10'Embarcadero RAD Studio '+ RadStudioVersion^.LicVerStr +' Architect'#10;
  Result:=Result+'e.pt'#10'10'#10;
  Result:=Result+'e.sign'#10'0'#10;
  Result:=Result+'e.sign2'#10'0'#10;
  Result:=Result+'e.sign3'#10'0'#10;
  Result:=Result+'export.allowed'#10'0'#10;
  Result:=Result+'import.allowed'#10'1'#10;
  Result:=Result+'import.silent'#10'1'#10;
  Result:=Result+'licensed.serialno'#10+SerialNumber+#10;
  Result:=Result+'nodelock.node'#10'0'#10;
  Result:=Result+'nodelock.session'#10+ActiveCode+#10;

  Result:=Result+'4'#10;

  Result:=Result+'26'#10;
  Result:=Result+'active'#10'T'#10;
  Result:=Result+'beta'#10'0'#10;
  Result:=Result+'exportable'#10'0'#10;
  Result:=Result+'hostpid'#10+pid+#10;
  Result:=Result+'hostskuid'#10+skuid+#10;
  Result:=Result+'internaluse'#10'0'#10;
  Result:=Result+'naggy'#10'0'#10;
  Result:=Result+'noncommercial'#10'0'#10;
  Result:=Result+'noncommercial_label'#10'No'#10;
  Result:=Result+'platform'#10'1'#10;
  Result:=Result+'platform_label'#10'Windows'#10;
  Result:=Result+'product'#10'2000'#10;
  Result:=Result+'productid'#10+ RadStudioVersion^.LicDelphiPID +#10;
  Result:=Result+'productid_label'#10'Delphi '+ RadStudioVersion^.LicVerStr +#10;
  Result:=Result+'productsku'#10+skuid+#10;
  Result:=Result+'productsku_label'#10'Architect'#10;               
  Result:=Result+'rndkey'#10'20264023'#10;
  Result:=Result+'serialno'#10+SerialNumber+#10;
  Result:=Result+'sku'#10+skuid+#10;
  Result:=Result+'templicense'#10'0'#10;
  Result:=Result+'termtype'#10'0'#10;
  Result:=Result+'termtype_label'#10'Unlimited'#10;
  Result:=Result+'title'#10'Delphi '+ RadStudioVersion^.LicVerStr +' Architect'#10;
  Result:=Result+'trial'#10'0'#10;
  Result:=Result+'upgrade'#10'0'#10;
  Result:=Result+'version'#10'26'#10;
  Result:=Result+'27'#10;
  Result:=Result+'Android'#10'T'#10;
  Result:=Result+'DESIGNDIAGRAMS'#10'TRUE'#10;
  Result:=Result+'DESIGNPROJECTS'#10'TRUE'#10;
  Result:=Result+'Desktop'#10'T'#10;
  Result:=Result+'FULLQA'#10'TRUE'#10;
  Result:=Result+'FulliOS'#10'T'#10;
  Result:=Result+'Linux64'#10'T'#10;
  Result:=Result+'MODELLING'#10'TRUE'#10;
  Result:=Result+'Mobile'#10'T'#10;
  Result:=Result+'OSX32'#10'T'#10;
  Result:=Result+'OSX64'#10'T'#10;
  Result:=Result+'Win32'#10'T'#10;
  Result:=Result+'Win64'#10'T'#10;
  Result:=Result+'a100'#10'MakeThingsHappen'#10;
  Result:=Result+'a1000'#10'PrintMoreMoney'#10;
  Result:=Result+'a101'#10'ImGivinItAllShesGot'#10;
  Result:=Result+'a200'#10'StampIt'#10;
  Result:=Result+'a250'#10'ItsToolTimeBaby'#10;
  Result:=Result+'a300'#10'TheMalteseFalcon'#10;
  Result:=Result+'a301'#10'GlueSolvent'#10;
  Result:=Result+'hostsuite'#10+pid+#10;
  Result:=Result+'iOSDevice'#10'T'#10;
  Result:=Result+'iOSDevice32'#10'T'#10;
  Result:=Result+'iOSDevice64'#10'T'#10;
  Result:=Result+'iOSSimulator'#10'T'#10;
  Result:=Result+'updatelevel'#10'0.0'#10;
  Result:=Result+'updates'#10'1'#10;

  Result:=Result+'26'#10;
  Result:=Result+'active'#10'T'#10;
  Result:=Result+'beta'#10'0'#10;
  Result:=Result+'exportable'#10'0'#10;
  Result:=Result+'hostpid'#10+pid+#10;
  Result:=Result+'hostskuid'#10+skuid+#10;
  Result:=Result+'internaluse'#10'0'#10;
  Result:=Result+'naggy'#10'0'#10;
  Result:=Result+'noncommercial'#10'0'#10;
  Result:=Result+'noncommercial_label'#10'No'#10;
  Result:=Result+'platform'#10'1'#10;
  Result:=Result+'platform_label'#10'Windows'#10;
  Result:=Result+'product'#10'4000'#10;
  Result:=Result+'productid'#10+ RadStudioVersion^.LicCBuilderPID +#10;
  Result:=Result+'productid_label'#10'C++Builder '+ RadStudioVersion^.LicVerStr +#10;
  Result:=Result+'productsku'#10+skuid+#10;
  Result:=Result+'productsku_label'#10'Architect'#10;               //Architect
  Result:=Result+'rndkey'#10'20264023'#10;
  Result:=Result+'serialno'#10+SerialNumber+#10;
  Result:=Result+'sku'#10+skuid+#10;
  Result:=Result+'templicense'#10'0'#10;
  Result:=Result+'termtype'#10'0'#10;
  Result:=Result+'termtype_label'#10'Unlimited'#10;
  Result:=Result+'title'#10'C++Builder '+ RadStudioVersion^.LicVerStr +' Architect'#10;
  Result:=Result+'trial'#10'0'#10;
  Result:=Result+'upgrade'#10'0'#10;
  Result:=Result+'version'#10'20'#10;
  Result:=Result+'26'#10;
  Result:=Result+'Android'#10'T'#10;
  Result:=Result+'DESIGNDIAGRAMS'#10'TRUE'#10;
  Result:=Result+'DESIGNPROJECTS'#10'TRUE'#10;
  Result:=Result+'Desktop'#10'T'#10;
  Result:=Result+'FULLQA'#10'TRUE'#10;
  Result:=Result+'FulliOS'#10'T'#10;
  Result:=Result+'MODELLING'#10'TRUE'#10;
  Result:=Result+'Mobile'#10'T'#10;
  Result:=Result+'OSX32'#10'T'#10;
  Result:=Result+'OSX64'#10'T'#10;
  Result:=Result+'Win32'#10'T'#10;
  Result:=Result+'Win64'#10'T'#10;
  Result:=Result+'a100'#10'MakeThingsHappen'#10;
  Result:=Result+'a1000'#10'PrintMoreMoney'#10;
  Result:=Result+'a101'#10'ImGivinItAllShesGot'#10;
  Result:=Result+'a200'#10'StampIt'#10;
  Result:=Result+'a250'#10'ItsToolTimeBaby'#10;
  Result:=Result+'a300'#10'TheMalteseFalcon'#10;
  Result:=Result+'a301'#10'GlueSolvent'#10;
  Result:=Result+'hostsuite'#10+pid+#10;
  Result:=Result+'iOSDevice'#10'T'#10;
  Result:=Result+'iOSDevice32'#10'T'#10;
  Result:=Result+'iOSDevice64'#10'T'#10;
  Result:=Result+'iOSSimulator'#10'T'#10;
  Result:=Result+'updatelevel'#10'0.0'#10;
  Result:=Result+'updates'#10'1'#10;

  Result:=Result+'26'#10;
  Result:=Result+'active'#10'T'#10;
  Result:=Result+'beta'#10'0'#10;
  Result:=Result+'exportable'#10'0'#10;
  Result:=Result+'hostpid'#10+pid+#10;
  Result:=Result+'hostskuid'#10+skuid+#10;
  Result:=Result+'internaluse'#10'0'#10;
  Result:=Result+'naggy'#10'0'#10;
  Result:=Result+'noncommercial'#10'0'#10;
  Result:=Result+'noncommercial_label'#10'No'#10;
  Result:=Result+'platform'#10'0'#10;
  Result:=Result+'platform_label'#10'Cross Platform'#10;
  Result:=Result+'product'#10'7000'#10;
  Result:=Result+'productid'#10'7113'#10;
  Result:=Result+'productid_label'#10'InterBase 2020'#10;        //InterBase 2020
  Result:=Result+'productsku'#10'0'#10;
  Result:=Result+'productsku_label'#10'Server'#10;               //Server
  Result:=Result+'rndkey'#10'20264023'#10;
  Result:=Result+'serialno'#10+SerialNumber+#10;
  Result:=Result+'sku'#10'0'#10;
  Result:=Result+'templicense'#10'0'#10;
  Result:=Result+'termtype'#10'0'#10;
  Result:=Result+'termtype_label'#10'Unlimited'#10;
  Result:=Result+'title'#10'InterBase 2020 Server'#10;      //InterBase 2020 Server
  Result:=Result+'trial'#10'0'#10;
  Result:=Result+'upgrade'#10'0'#10;
  Result:=Result+'version'#10'8'#10;
  Result:=Result+'21'#10;
  Result:=Result+'changeView'#10'1'#10;
  Result:=Result+'connectionMonitoring'#10'1'#10;
  Result:=Result+'connectionsPerUser'#10'200'#10;
  Result:=Result+'customVarId'#10' '#10;
  Result:=Result+'databaseAccess'#10'1'#10;
  Result:=Result+'dbEncryption'#10'1'#10;
  Result:=Result+'ddlOperations'#10'1'#10;
  Result:=Result+'devLicense'#10'1'#10;
  Result:=Result+'externalFileAccess'#10'1'#10;
  Result:=Result+'internetAccess'#10'1'#10;
  Result:=Result+'languages'#10'ALL'#10;
  Result:=Result+'licensedCpus'#10'32'#10;
  Result:=Result+'licensedUsers'#10'5000'#10;
  Result:=Result+'nodeID'#10' '#10;
  Result:=Result+'otwEncryption'#10'1'#10;
  Result:=Result+'remoteAccess'#10'1'#10;
  Result:=Result+'serverAccess'#10'1'#10;
  Result:=Result+'togoAccess'#10'0'#10;
  Result:=Result+'updatelevel'#10'0.0'#10;
  Result:=Result+'useAddons'#10'0'#10;
  Result:=Result+'version'#10'14.0'#10;

  Result:=Result+'26'#10;
  Result:=Result+'active'#10'T'#10;
  Result:=Result+'beta'#10'0'#10;
  Result:=Result+'exportable'#10'0'#10;
  Result:=Result+'hostpid'#10+pid+#10;
  Result:=Result+'hostskuid'#10+skuid+#10;
  Result:=Result+'internaluse'#10'0'#10;
  Result:=Result+'naggy'#10'0'#10;
  Result:=Result+'noncommercial'#10'0'#10;
  Result:=Result+'noncommercial_label'#10'No'#10;
  Result:=Result+'platform'#10'0'#10;
  Result:=Result+'platform_label'#10'All'#10;
  Result:=Result+'product'#10'7000'#10;
  Result:=Result+'productid'#10'7113'#10;
  Result:=Result+'productid_label'#10'InterBase 2020'#10;        //InterBase 2020
  Result:=Result+'productsku'#10'16'#10;
  Result:=Result+'productsku_label'#10'ToGo Edition'#10;               //ToGo Edition
  Result:=Result+'rndkey'#10'20264023'#10;
  Result:=Result+'serialno'#10+SerialNumber+#10;
  Result:=Result+'sku'#10'16'#10;
  Result:=Result+'templicense'#10'0'#10;
  Result:=Result+'termtype'#10'0'#10;
  Result:=Result+'termtype_label'#10'Unlimited'#10;
  Result:=Result+'title'#10'InterBase 2020 ToGo Edition'#10;      //InterBase 2020 ToGo Edition
  Result:=Result+'trial'#10'0'#10;
  Result:=Result+'upgrade'#10'0'#10;
  Result:=Result+'version'#10'8'#10;
  Result:=Result+'21'#10;
  Result:=Result+'changeView'#10'1'#10;
  Result:=Result+'connectionMonitoring'#10'1'#10;
  Result:=Result+'connectionsPerUser'#10'200'#10;
  Result:=Result+'customVarId'#10' '#10;
  Result:=Result+'databaseAccess'#10'1'#10;
  Result:=Result+'dbEncryption'#10'1'#10;
  Result:=Result+'ddlOperations'#10'1'#10;
  Result:=Result+'devLicense'#10'1'#10;
  Result:=Result+'externalFileAccess'#10'1'#10;
  Result:=Result+'internetAccess'#10'1'#10;
  Result:=Result+'languages'#10'ALL'#10;
  Result:=Result+'licensedCpus'#10'32'#10;
  Result:=Result+'licensedUsers'#10'5000'#10;
  Result:=Result+'nodeID'#10' '#10;
  Result:=Result+'otwEncryption'#10'1'#10;
  Result:=Result+'remoteAccess'#10'1'#10;
  Result:=Result+'serverAccess'#10'1'#10;
  Result:=Result+'togoAccess'#10'1'#10;
  Result:=Result+'updatelevel'#10'0.0'#10;
  Result:=Result+'useAddons'#10'0'#10;
  Result:=Result+'version'#10'14.0'#10;

  Result:=Result+'1'#10;
  Result:=Result+'updatelevel'#10'0.0'#10;
end;

end.
