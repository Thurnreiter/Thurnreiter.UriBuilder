# Thurnreiter.UriBuilder
This is a wrapper for TUri from namespace System.Net.URLClient.
The Constructor of Implementation has a parameter that initializes the TURI from a string.
The AddParameter method can be controlled by attributes. It is also possible to pass the "Value" by delegate (TFunc<string>).
#### The validator class:
```delphi
  /// <summary>
  ///   Demo how to override the TUriValidator class. Here we reduce the value.
  /// </summary>
  TNathanUriValidator = class(TUriValidator)
  public
    function GetValue(): string; override;
  end;
```
#### An alias class for TUriBuilder with attributes to validate the parameters:
```delphi
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
  [IgnoreEmptyValues]
  TNathanUriBilder = class(TUriBuilder);
```
#### And how to use them:
```delphi
procedure TTestUriBuilder.Test_AddParameter_WithTFunc;
var
  Actual: string;
begin
  //  Arrange...
  FCut := TNathanUriBilder.Create('http://webto.parts.com/loginh.aspx');

  //  Act...
  Actual := FCut
    .AddParameter('nathan', 'chanan')
    .AddParameter('pname',
      function: string
      begin
        Result := 'thu';
      end)
    .ToString;

  //  Assert...
  Assert.AreEqual('http://webto.parts.com/loginh.aspx?nathan=ch&pname=thu', Actual);
end;
```
More examples can be found in the unit tests.
