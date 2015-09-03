unit uConnection;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, Data.DB, FireDAC.Comp.Client, Dialogs,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, uCFG,SysUtils;

type
  TConnection = class
  strict private
    class var FInstance: TConnection;
    constructor CreatePrivate;
  private
    FConnection: TFDConnection;
  public
    constructor Create;
    class function GetInstance: TConnection;
    property Conexao: TFDConnection read FConnection write FConnection;
    function Execute(const ACmd: String; var Error: String): Boolean;
    function ExecuteQuery(const ACmd: String): TFDQuery;
    procedure BeginTrans;
    procedure Rollback;
    procedure Commit;
    function Conectar(var Error: String): Boolean;
  end;
implementation

{ TConnection }

procedure TConnection.BeginTrans;
begin
  FConnection.StartTransaction;
end;

procedure TConnection.Commit;
begin
  FConnection.Commit;
end;

function TConnection.Conectar(var Error: String): Boolean;
begin
  Result := False;
  try
    FConnection.Connected := False;
    with FConnection.Params do
    begin
      if (CFG.Instance <> '') and (UpperCase(CFG.Instance) <> 'DEFAULT') then
        Values['Server'] := CFG.HostName + '\' + CFG.Instance
      else
        Values['Server'] := CFG.HostName;
      Values['Database'] := CFG.DataBase;
      Values['User_Name'] := CFG.Login;
      Values['Password'] := CFG.Password;
    end;
    FConnection.Connected := True;
    Result := FConnection.Connected;
  except
    on E:Exception do
    begin
      Result := False;
      Error := 'Houve um problema ao conectar ao banco: ' + E.Message;
    end;
  end;
end;

constructor TConnection.Create;
begin
  raise Exception.Create('Object Singleton');
end;

constructor TConnection.CreatePrivate;
var
  Error: String;
begin
  inherited Create;
  FConnection := TFDConnection.Create(nil);
  FConnection.DriverName := 'MSSQL';
  if not (Conectar(Error)) then
    raise Exception.Create(Error);
end;

function TConnection.Execute(const ACmd: String; var Error: String): Boolean;
begin
  Result := True;
  try
    FConnection.ExecSQL(ACmd);
  except
    on E: Exception do
    begin
      Error := E.Message;
      Result := False;
    end;
  end;
end;

function TConnection.ExecuteQuery(const ACmd: String): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  try
    with Result do
    begin
      Connection := FConnection;
      Close;
      SQL.Clear;
      SQL.Add(ACmd);
      Open;
    end;
  except
    Result := nil;
  end;
end;

class function TConnection.GetInstance: TConnection;
begin
  if not Assigned(FInstance) then
    FInstance := TConnection.CreatePrivate;
  Result := FInstance;
end;

procedure TConnection.Rollback;
begin
  FConnection.Rollback;
end;

end.
