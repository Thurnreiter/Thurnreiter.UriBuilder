# Thurnreiter.UriBuilder
This is a wrapper for TUri from namespace System.Net.URLClient.
The Constructor of Implementation has a parameter the initializes a TURI from a string.
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
#### The derived class from TUriBuilder:
```delphi
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
