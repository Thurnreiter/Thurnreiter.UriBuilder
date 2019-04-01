unit Nathan.UriBuilder;

interface

uses
  System.SysUtils,
  System.Net.URLClient,
  Nathan.UriBuilder.Attribute,
  Nathan.UriBuilder.Validator;

{$M+}

type
  /// <summary>
  ///   This is a wrapper for TUri from namespace System.Net.URLClient.
  ///   The Constructor of Implementation has a parameter the initializes a TURI from a string.
  ///  <br>
  ///   https://nathan:thurnreiter@www.example.com:8080/index.html?p1=A&p2=B#ressource
  ///   \___/   \____/ \_________/ \_____________/ \__/\_________/ \_______/ \_______/
  ///     |       |         |           |            |      |          |         |
  ///   Schema   User    Kennwort      Host        Port    Pfad      Query    Fragment
  /// </summary>
  IUriBuilder = interface
    ['{83DD3E74-13EF-4A9F-862E-E1AC660B6DDF}']

    /// <summary>Adds a Parameter to the URI</summary>
    function AddParameter(const AName, AValue: string): IUriBuilder; overload;
    function AddParameter(const AName: string; AFuncValue: TFunc<string>): IUriBuilder; overload;

    /// <summary>Removes a Parameter from the URI</summary>
    function DeleteParameter(const AName: string): IUriBuilder;

    function Scheme: string; overload;
    function Scheme(const value: string): IUriBuilder; overload;

    function Username: string; overload;
    function Username(const value: string): IUriBuilder; overload;

    function Password: string; overload;
    function Password(const value: string): IUriBuilder; overload;

    function Host: string; overload;
    function Host(const value: string): IUriBuilder; overload;

    function Port: Integer; overload;
    function Port(value: Integer): IUriBuilder; overload;

    function Path: string; overload;
    function Path(const value: string): IUriBuilder; overload;

    function Query: string; overload;
    function Query(const value: string): IUriBuilder; overload;

    function Fragment: string; overload;
    function Fragment(const value: string): IUriBuilder; overload;

    /// <summary>Generate a urlencoded string from the URI parts</summary>
    /// <returns>A string representing the URI</returns>
    function ToString(): string;
  end;

  TUriBuilder = class(TInterfacedObject, IUriBuilder)
  strict private
    FUri: TURI;
    FUriParameters: TURIParameters;
  strict private
    function FindNameValuePair(const NameOfPair: string): Integer;
    function GetInnerAttributes(AClass: TClass): TArray<TCustomAttribute>;
    function CreateValidatorClassAndGetValue(AUriValidatorClass: TUriValidatorClass; const AInput: string): string;
    procedure DeleteAllEmptyValues;

    function Validate: Boolean;
  public
    constructor Create(const AUriInitString: string);

    function AddParameter(const AName, AValue: string): IUriBuilder; overload; virtual;
    function AddParameter(const AName: string; AFuncValue: TFunc<string>): IUriBuilder; overload; virtual;

    function DeleteParameter(const AName: string): IUriBuilder;

    function Scheme: string; overload;
    function Scheme(const value: string): IUriBuilder; overload;

    function Username: string; overload;
    function Username(const value: string): IUriBuilder; overload;

    function Password: string; overload;
    function Password(const value: string): IUriBuilder; overload;

    function Host: string; overload;
    function Host(const value: string): IUriBuilder; overload;

    function Port: Integer; overload;
    function Port(value: Integer): IUriBuilder; overload;

    function Path: string; overload;
    function Path(const value: string): IUriBuilder; overload;

    function Query: string; overload;
    function Query(const value: string): IUriBuilder; overload;

    function Fragment: string; overload;
    function Fragment(const value: string): IUriBuilder; overload;

    function ToString(): string; override;
  end;

{$M-}

implementation

uses
  System.Rtti,
  System.TypInfo;

{ **************************************************************************** }

{ TUriBuilder }

constructor TUriBuilder.Create(const AUriInitString: string);
begin
  inherited Create;
  FUriParameters := Default(TURIParameters);
  FUri := TURI.Create(AUriInitString);
end;

function TUriBuilder.Scheme(const value: string): IUriBuilder;
begin
  FUri.Scheme := value;
  Result := Self;
end;

function TUriBuilder.Scheme: string;
begin
  Result := FUri.Scheme;
end;

function TUriBuilder.Username(const value: string): IUriBuilder;
begin
  FUri.Username := value;
  Result := Self;
end;

function TUriBuilder.Username: string;
begin
  Result := FUri.Username;
end;

function TUriBuilder.Password: string;
begin
  Result := FUri.Password;
end;

function TUriBuilder.Password(const value: string): IUriBuilder;
begin
  FUri.Password := value;
  Result := Self;
end;

function TUriBuilder.Host(const value: string): IUriBuilder;
begin
  FUri.Host := value;
  Result := Self;
end;

function TUriBuilder.Host: string;
begin
  Result := FUri.Host;
end;

function TUriBuilder.Port(value: Integer): IUriBuilder;
begin
  FUri.Port := Value;
  Result := Self;
end;

function TUriBuilder.Port: Integer;
begin
  Result := FUri.Port;
end;

function TUriBuilder.Path(const value: string): IUriBuilder;
begin
  FUri.Path := value;
  Result := Self;
end;

function TUriBuilder.Path: string;
begin
  Result := FUri.Path;
end;

function TUriBuilder.Query: string;
begin
  Result := FUri.Query;
end;

function TUriBuilder.Query(const value: string): IUriBuilder;
begin
  FUri.Query := value;
  Result := Self;
end;

function TUriBuilder.Fragment: string;
begin
  Result := FUri.Fragment;
end;

function TUriBuilder.Fragment(const value: string): IUriBuilder;
begin
  FUri.Fragment := value;
  Result := Self;
end;

function TUriBuilder.AddParameter(const AName, AValue: string): IUriBuilder;
begin
  SetLength(FUriParameters, Length(FUriParameters) + 1);
  FUriParameters[High(FUriParameters)].Create(AName, AValue);
  Result := Self;
end;

function TUriBuilder.AddParameter(const AName: string; AFuncValue: TFunc<string>): IUriBuilder;
begin
  SetLength(FUriParameters, Length(FUriParameters) + 1);
  FUriParameters[High(FUriParameters)].Create(AName, AFuncValue);
  Result := Self;
end;

procedure TUriBuilder.DeleteAllEmptyValues;
var
  Idx: Integer;
begin
  Idx := Low(FUriParameters);
  while Idx <= High(FUriParameters) do
  begin
    if FUriParameters[Idx].Value.IsEmpty then
      DeleteParameter(FUriParameters[Idx].Name)
    else
      Inc(Idx);
  end;
end;

function TUriBuilder.DeleteParameter(const AName: string): IUriBuilder;
var
  Idx: Integer;
begin
  //  FUri.DeleteParameter(AName);
  for Idx := Low(FUriParameters) to High(FUriParameters) do
  begin
    if FUriParameters[Idx].Name.ToLower.Contains(AName.ToLower) then
    begin
      Finalize(FUriParameters[Idx]);
      System.Move(FUriParameters[Idx + 1], FUriParameters[Idx], (Length(FUriParameters) - Idx - 1) * SizeOf(TURIParameter));
      FillChar(FUriParameters[High(FUriParameters)], SizeOf(TURIParameter), 0);
      SetLength(FUriParameters, Length(FUriParameters) - 1);
      Break;
    end;
  end;

  Result := Self;
end;

function TUriBuilder.FindNameValuePair(const NameOfPair: string): Integer;
var
  Idx: Integer;
begin
  for Idx := Low(FUriParameters) to High(FUriParameters) do
    if FUriParameters[Idx].Name.ToLower.Contains(NameOfPair.ToLower) then
      Exit(Idx);

  Result := -1;
end;

function TUriBuilder.GetInnerAttributes(AClass: TClass): TArray<TCustomAttribute>;
var
  RCtx: TRttiContext;
  RType: TRttiType;
begin
  RCtx := TRttiContext.Create();
  RType := RCtx.GetType(Self.ClassType);
  if (not Assigned(RType)) then
    Exit;

  Result := RType.GetAttributes;
end;

function TUriBuilder.CreateValidatorClassAndGetValue(AUriValidatorClass: TUriValidatorClass; const AInput: string): string;
var
  UriValidator: TUriValidator;
begin
  UriValidator := AUriValidatorClass.Create(AInput);
  try
    Result := UriValidator.GetValue;
  finally
    UriValidator.Free;
  end;
end;

function TUriBuilder.Validate: Boolean;
var
  RAttribute: TCustomAttribute;
  UriValidatorClass: TUriValidatorClass;
  Index: Integer;
begin
  Result := False;
  for RAttribute in GetInnerAttributes(Self.ClassType) do
  begin
    if (not Result) then
      Result := (RAttribute is IgnoreEmptyValues);

    if RAttribute is UriName then
    begin
      Index := FindNameValuePair(UriName(RAttribute).Name);
      if (Index = -1) then
        Continue;

      UriValidatorClass := UriName(RAttribute).Validator;
      if Assigned(UriValidatorClass) then
        FUriParameters[Index].Value := CreateValidatorClassAndGetValue(UriValidatorClass, FUriParameters[Index].Value)
      else
      if ((not FUriParameters[Index].Name.IsEmpty) and (UriName(RAttribute).FieldLength > 0)) then
        FUriParameters[Index].Value := FUriParameters[Index].Value.Substring(0, UriName(RAttribute).FieldLength);
    end;
  end;
end;

function TUriBuilder.ToString: string;
var
  Idx: Integer;
begin
  if Validate then
    DeleteAllEmptyValues;

  for Idx := Low(FUriParameters) to High(FUriParameters) do
    FUri.AddParameter(FUriParameters[Idx]);

  Result := FUri.ToString;
end;

end.
