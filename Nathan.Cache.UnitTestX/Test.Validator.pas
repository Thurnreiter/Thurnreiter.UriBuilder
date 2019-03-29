unit Test.Validator;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Nathan.UriBuilder.Validator;

type
  [TestFixture]
  TTestUriBuilderValidator = class
  strict private
    FCut: TUriValidator;
  public
    [Setup]
    procedure Setup();

    [TearDown]
    procedure TearDown();

    [Test]
    procedure Test_HasCorrectlyInOutValue;
  end;

{$M-}

implementation

procedure TTestUriBuilderValidator.Setup();
begin
  FCut := nil;
end;

procedure TTestUriBuilderValidator.TearDown();
begin
  FCut.Free;
end;

procedure TTestUriBuilderValidator.Test_HasCorrectlyInOutValue;
var
  Actual: string;
begin
  //  Arrange...
  FCut := TUriValidator.Create('chanan');

  //  Act...
  Actual := FCut.GetValue;

  //  Assert...
  Assert.AreEqual('chanan', Actual);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestUriBuilderValidator, 'Validator');

end.
