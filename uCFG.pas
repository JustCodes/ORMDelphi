unit uCFG;

interface

uses SysUtils,IniFiles,Forms;

type
  TCfg = class(TIniFile)
  private
    function GetDatabase: String;
    function GetHostname: String;
    function GetInstance: String;
    function GetLogin: String;
    function GetPassword: String;
    procedure SetDatabase(const Value: String);
    procedure SetHostname(const Value: String);
    procedure SetInstance(const Value: String);
    procedure SetLogin(const Value: String);
    procedure SetPassword(const Value: String);
  public
    property Instance: String read GetInstance write SetInstance;
    property Hostname: String read GetHostname write SetHostname;
    property Login: String read GetLogin write SetLogin;
    property Password: String read GetPassword write SetPassword;
    property Database: String read GetDatabase write SetDatabase;
  end;

var
  CFG: TCfg;

implementation

{ TCfg }

function TCfg.GetDatabase: String;
begin
  Result := ReadString('CFG','DATABASE','');
end;

function TCfg.GetHostname: String;
begin
  Result := ReadString('CFG','HOSTNAME','');
end;

function TCfg.GetInstance: String;
begin
  Result := ReadString('CFG','INSTANCE','');
end;

function TCfg.GetLogin: String;
begin
  Result := ReadString('CFG','LOGIN','');
end;

function TCfg.GetPassword: String;
begin
  Result := ReadString('CFG','PASSWORD','');
end;

procedure TCfg.SetDatabase(const Value: String);
begin
  WriteString('CFG','DATABASE',Value);
end;

procedure TCfg.SetHostname(const Value: String);
begin
  WriteString('CFG','HOSTNAME','');
end;

procedure TCfg.SetInstance(const Value: String);
begin
  WriteString('CFG','INSTANCE','');
end;

procedure TCfg.SetLogin(const Value: String);
begin
  WriteString('CFG','LOGIN','');
end;

procedure TCfg.SetPassword(const Value: String);
begin
  WriteString('CFG','PASSWORD','');
end;

initialization
  CFG := TCfg.Create(ExtractFilePath(Application.ExeName) + 'Cfg.ini');
finalization
  FreeAndNil(CFG);

end.
