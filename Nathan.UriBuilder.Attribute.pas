unit Nathan.UriBuilder.Attribute;

interface

uses
  Nathan.UriBuilder.Validator;

{$M+}

type
  UriName = class(TCustomAttribute)
  strict private
    FFieldLength: Integer;
    FName: string;
    FValidator: TUriValidatorClass;
  public
    constructor Create(const AName: string); overload;
    constructor Create(const AName: string; AFieldLength: Integer); overload;
    constructor Create(const AName: string; Validator: TUriValidatorClass); overload;

    property Name: string read FName;
    property FieldLength: Integer read FFieldLength;
    property Validator: TUriValidatorClass read FValidator;
  end;

  IgnoreEmptyValues = class(TCustomAttribute)
  end;

{$M-}

implementation

constructor UriName.Create(const AName: string);
begin
  Create(AName, 0);
end;

constructor UriName.Create(const AName: string; AFieldLength: Integer);
begin
  inherited Create;
  FFieldLength := AFieldLength;
  FName := AName;
  FValidator := nil;
end;

constructor UriName.Create(const AName: string; Validator: TUriValidatorClass);
begin
  Create(AName, 0);
  FValidator := Validator;
end;

end.
