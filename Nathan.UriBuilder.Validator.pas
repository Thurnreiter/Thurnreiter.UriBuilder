unit Nathan.UriBuilder.Validator;

interface

{$M+}

type
  TUriValidator = class
  strict protected
    FValue: string;
  public
    constructor Create(const AValue: string);

    function GetValue(): string; virtual;
  end;

  TUriValidatorClass = class of TUriValidator;

{$M-}

implementation

constructor TUriValidator.Create(const AValue: string);
begin
  inherited Create;
  FValue := AValue;
end;

function TUriValidator.GetValue: string;
begin
  Result := FValue;
end;

end.
