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
  ///   Demo how to override the TUriValidator class. Here we reduce the value.
  /// </summary>
  TNathanUriValidator = class(TUriValidator)
  public
    function GetValue(): string; override;
  end;

  /// <summary>
  ///   Demo how to override the TUriValidator class with and exception.
  /// </summary>
  TNathanUriValidatorEx = class(TUriValidator)
  public
    function GetValue(): string; override;
  end;

  /// <summary>
  ///   Is actually only an alias for "TUriBuilder", extended by attributes.
  /// </summary>
  [UriName('Name4711', 4711)]
  [UriName('Name1', 1)]
  [UriName('Name2', 2)]
  [UriName('Name3', 3)]
  [UriName('Nathan', 2)]
  [UriName('hello', TUriValidator)]
  [UriName('helloshort', TNathanUriValidator)]
  TNathanUriBilder = class(TUriBuilder);

  [IgnoreEmptyValues]
  [UriName('helloexception', TNathanUriValidatorEx)]
  [UriName('Nathan', 2)]
  TNathanUriBilderEx = class(TUriBuilder);

{$M-}

implementation

{ **************************************************************************** }

{ TNathanUriValidator }

function TNathanUriValidator.GetValue: string;
begin
  Result := inherited.Substring(0, 2);
end;

{ **************************************************************************** }

{ TNathanUriValidatorEx }

function TNathanUriValidatorEx.GetValue: string;
begin
  raise EInvalidUriValidatorValue.Create('Invalid value for the parameter.');
end;

end.

