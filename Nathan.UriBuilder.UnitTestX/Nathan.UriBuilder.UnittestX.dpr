program Nathan.UriBuilder.UnittestX;

{$IFNDEF TESTINSIGHT}
  {$APPTYPE CONSOLE}
{$ENDIF}

uses
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  System.SysUtils,
  System.IOUtils,
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  Test.UriBuilder in 'Test.UriBuilder.pas',
  Nathan.UriBuilder in '..\Nathan.UriBuilder.pas',
  Nathan.UriBuilder.Attribute in '..\Nathan.UriBuilder.Attribute.pas',
  Nathan.UriBuilder.Validator in '..\Nathan.UriBuilder.Validator.pas',
  Derived.UriBuilder.Demo in 'Derived.UriBuilder.Demo.pas',
  Test.Validator in 'Test.Validator.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;
  Logger: ITestLogger;
  NUnitLogger: ITestLogger;

begin
  {$WARN SYMBOL_PLATFORM OFF}ReportMemoryLeaksOnShutdown := (DebugHook > 0);{$WARN SYMBOL_PLATFORM ON}

  {$IFDEF TESTINSIGHT}
    //  With TestInsight PlugIn...
    if {$WARN SYMBOL_PLATFORM OFF}(DebugHook > 0){$WARN SYMBOL_PLATFORM ON} then
    begin
      TestInsight.DUnitX.RunRegisteredTests;
      Exit;
    end;
  {$ENDIF}

  try
    //  Check command line options, will exit if invalid. With option -O=... it was invalid.
    //  TDUnitX.CheckCommandLine;

    //  Create the test runner.
    Runner := TDUnitX.CreateRunner;

    //  Tell the runner to use RTTI to find Fixtures.
    Runner.UseRTTI := True;

    //  TDUnitXIoC.DefaultContainer.RegisterType<IStackTraceProvider,TYourProvider>;

    //  Tell the runner how we will log things Log to the console window.
    //  Add a console logger, pass in true to specify quiet mode as we don't need detailed console output.
    Logger := TDUnitXConsoleLogger.Create(True);
    Runner.AddLogger(Logger);

    //  Logger := TGUIXTestRunner.Create(True);
    //  Runner.AddLogger(Logger);

    //  Add an nunit xml loggeer. Generate an NUnit compatible XML File.
    TDUnitX.Options.XMLOutputFile := ChangeFileExt(ParamStr(0), '_Result.xml');
    if TFile.Exists(TDUnitX.Options.XMLOutputFile) then
      TFile.Delete(TDUnitX.Options.XMLOutputFile);

    NUnitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    Runner.AddLogger(NUnitLogger);
    Runner.FailsOnNoAsserts := False; //  When true, Assertions must be made during tests;

    //  Run tests...
    Results := Runner.Execute;

    //  Let the CI Server know that something failed...
    if (not Results.AllPassed) then
      System.ExitCode := EXIT_ERRORS;

    //  ExitCode := FTestResult.ErrorCount + FTestResult.FailureCount;

    //  We don't want this happening when running under CI.
    if ({$WARN SYMBOL_PLATFORM OFF}(DebugHook > 0){$WARN SYMBOL_PLATFORM ON}
    and (TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause)) then
    begin
      System.WriteLn('Done.. press <Enter> key to quit.');
      System.WriteLn('');
      System.WriteLn('HomePath: ' + TPath.GetHomePath);
      System.WriteLn('Running '
        + IntToStr(Results.PassCount)
        + ' of '
        + IntToStr(Results.TestCount)
        + ' test cases');  // + IntToStr(Results.MemoryLeakCount)
      System.Readln;
    end;
  except
    on E: Exception do
    begin
      System.Writeln(E.ClassName, ': ', E.Message);
      System.ExitCode := 2; //  System.ExitCode := 1; Old style like EXIT_ERRORS...
    end;
  end;
end.
