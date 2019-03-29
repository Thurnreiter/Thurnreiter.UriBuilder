unit Derived.UriBuilder.Demo;

interface

uses
  System.SysUtils,
  Nathan.UriBuilder,
  Nathan.UriBuilder.Attribute,
  Nathan.UriBuilder.Validator;

{$M+}

type
  {$REGION 'Infos'}
    //  https://sergworks.wordpress.com/2010/01/27/anonimous-methods-in-delphi-the-internals/
    //  https://stackoverflow.com/questions/24975904/why-cant-i-declare-a-generic-anonymous-method-outside-a-method-body
  {$ENDREGION}

  /// <summary>
  ///   Demo how tzo override the TUriValidator class. Here we reduce the value.
  /// </summary>
  TNathanUriValidator = class(TUriValidator)
  public
    function GetValue(): string; override;
  end;

  /// <summary>
  ///   Demo class from TUriBuilder, with attributes to validate the TNameValuePair.
  /// </summary>
  TNathanUriBilder = class(TUriBuilder)
  public
    [UriName('AName1', 1)]
    [UriName('AName2', 2)]
    [UriName('AName3', 3)]
    [UriName('Nathan', 2)]
    [UriName('hello', TUriValidator)]
    [UriName('helloshort', TNathanUriValidator)]
    function AddParameter(const AName, AValue: string): IUriBuilder; override;
  end;

{$M-}

implementation

{ **************************************************************************** }

{ TNathanUriValidator }

function TNathanUriValidator.GetValue: string;
begin
  Result := inherited.Substring(0, 2);
end;

{ **************************************************************************** }

{ TNathanUriBilder }

function TNathanUriBilder.AddParameter(const AName, AValue: string): IUriBuilder;
begin
  Result := inherited;
end;

end.

