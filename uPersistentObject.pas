unit uPersistentObject;

interface

uses
  Rtti,StrUtils,Variants,Classes,FireDAC.Comp.Client,
  FireDAC.VCLUI.Wait, FireDAC.DApt, uConnection, uAtrib;

type
  TPersintentObject = class
  private
    FSQL: WideString;
    function GetValue(const ARTP: TRttiProperty; const AFK: Boolean): String;
    procedure SetValue(P: TRttiProperty; S: Variant);
  public
    property CustomSQL: WideString read FSQL write FSQL;
    function Insert: Boolean;
    function Update: Boolean;
    function Delete: Boolean;
    procedure Load(const AValue: Integer); overload; virtual; abstract;
    function Load: Boolean; overload;
  end;

implementation

{ TPersintentObject }

function TPersintentObject.Delete: Boolean;
begin

end;

function TPersintentObject.GetValue(const ARTP: TRttiProperty;
  const AFK: Boolean): String;
begin
  case ARTP.PropertyType.TypeKind of
    tkUnknown, tkInteger,
    tkInt64: Result := ARTP.GetValue(Self).ToString;
    tkEnumeration: Result := IntToStr(Integer(ARTP.GetValue(Self).AsBoolean));
    tkChar, tkString,
    tkWChar, tkLString,
    tkWString, tkUString: Result := QuotedStr(ARTP.GetValue(Self).ToString);
    tkFloat: Result := StringReplace(FormatFloat('0.00',ARTP.GetValue(Self).AsCurrency)
              ,FormatSettings.DecimalSeparator,'.',[rfReplaceAll,rfIgnoreCase]);
  end;

  if (AFK) and (Result = '0') then
    Result := 'null';
end;

function TPersintentObject.Insert: Boolean;
var
  Ctx: TRttiContext;
  RTT: TRttiType;
  RTP: TRttiProperty;
  Att: TCustomAttribute;
  SQL,
  Field,
  Value,
  FieldID,
  NomeTabela,Error: String;
  Qry: TFDQuery;
begin
  Field := '';
  Value := '';
  TConnection.GetInstance.BeginTrans;
  Ctx := TRttiContext.Create;
  try
    try
      RTT := CTX.GetType(ClassType);
      for Att in RTT.GetAttributes do
      begin
        if Att is TableName then
        begin
          SQL := 'INSERT INTO ' + TableName(ATT).Name;
          NomeTabela := TableName(ATT).Name;
        end;
      end;

      for RTP in RTT.GetProperties do
      begin
         for Att in RTP.GetAttributes do
         begin
           if Att is FieldName then
           begin
             if not (FieldName(ATT).AutoInc) then {Auto incremento não pode entrar no insert}
             begin
               Field := Field + FieldName(ATT).Name + ',';
               Value := Value + GetValue(RTP,FieldName(ATT).FK) + ',';
             end
             else
               FieldID := FieldName(ATT).Name;
           end;
         end;
      end;

      Field := Copy(Field,1,Length(Field)-1);
      Value := Copy(Value,1,Length(Value)-1);

      SQL := SQL + ' (' + Field + ') VALUES (' + Value + ')';
      if Trim(CustomSQL) <> '' then
        SQL := CustomSQL;
      Result := TConnection.GetInstance.Execute(SQL,Error);

      SQL := 'SELECT ' + FieldID + ' FROM ' + NomeTabela + ' ORDER BY ' + FieldID + ' DESC';
      Qry := TConnection.GetInstance.ExecuteQuery(SQL);
      //Qry.Next;
      for RTP in RTT.GetProperties do
      begin
         for Att in RTP.GetAttributes do
         begin
           if (Att is FieldName) and (FieldName(ATT).AutoInc) then
           begin
             RTP.SetValue(Self,TValue.FromVariant(qry.Fields[0].AsInteger));
           end;
         end;
      end;
    finally
      CustomSQL := '';
      TConnection.GetInstance.Commit;
      CTX.Free;
    end;
  except
    TConnection.GetInstance.Rollback;
    raise;
  end;
end;

function TPersintentObject.Load: Boolean;
var
  Ctx: TRttiContext;
  RTT: TRttiType;
  RTP: TRttiProperty;
  Att: TCustomAttribute;
  SQL,
  Where: String;
  Reader: TFDQuery;
begin
  Result := True;
  Ctx := TRttiContext.Create;
  try
    RTT := CTX.GetType(ClassType);
    for Att in RTT.GetAttributes do
    begin
      if Att is TableName then
        SQL := 'SELECT * FROM ' + TableName(ATT).Name;
    end;

    for RTP in RTT.GetProperties do
    begin
       for Att in RTP.GetAttributes do
       begin
         if Att is FieldName then
         begin
           if (FieldName(ATT).PK) then
             Where := Where + Ifthen(Trim(where)='','',' AND ') + FieldName(ATT).Name + ' = ' + GetValue(RTP,FieldName(ATT).FK);
         end;
       end;
    end;
    SQL := SQL + ' WHERE ' + Where;

    if Trim(CustomSQL) <> '' then
      SQL := CustomSQL;

    Reader := TConnection.GetInstance.ExecuteQuery(SQL);

    if (Assigned(Reader)) and (Reader.RecordCount > 0) then
    begin
      with Reader do
      begin
        First;
        while not EOF do
        begin
          for RTP in RTT.GetProperties do
          begin
             for Att in RTP.GetAttributes do
             begin
               if Att is FieldName then
               begin
                 if Assigned(FindField(FieldName(ATT).Name)) then
                   SetValue(RTP,FieldByName(FieldName(ATT).Name).Value);
               end;
             end;
          end;
          Next;
        end;
      end;
    end
    else
      Result := False;
  finally
    CustomSQL := '';
    CTX.Free;
  end;
end;

procedure TPersintentObject.SetValue(P: TRttiProperty; S: Variant);
var
  V: TValue;
  w: Word;
begin
  w := VarType(S);
  case w of
    271: v := StrToFloat(S); {smallmoney}
    272: v := StrToDateTime(S); {smalldatetime}
    3: v := StrToInt(S);
    else
    begin
      P.SetValue(Self,TValue.FromVariant(S));
      exit;
    end;
  end;
  p.SetValue(Self,v);
end;

function TPersintentObject.Update: Boolean;
begin

end;

end.
