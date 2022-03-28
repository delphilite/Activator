{ KOL MCK } // Do not remove this line!

procedure NewMainForm( var Result: PMainForm; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PMainForm.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Delphi 10.3.3 Activator' ).SetPosition( 8, 8 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Style := Result.Form.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
    Result.Form.SetClientSize( 534, 122 );
      Result.Form.OnMessage := Result.kolMainFormMessage;
      Result.Form.OnShow := Result.kolMainFormShow;
      Result.Form.OnDestroy := Result.kolMainFormDestroy;
    Result.btnAbout := NewButton( Result.Form, '&About' ).SetPosition( 325, 16 ).SetSize( 90, 90 );
    {$IFDEF USE_MHTOOLTIP}
    Result.btnAbout.Hint.Text := 'About';
    {$ENDIF USE_MHTOOLTIP}
    Result.btnReset := NewButton( Result.Form, 'Re&set' ).SetPosition( 222, 16 ).SetSize( 90, 90 );
    {$IFDEF USE_MHTOOLTIP}
    Result.btnReset.Hint.Text := 'Reset Delphi 10.3.2';
    {$ENDIF USE_MHTOOLTIP}
    Result.btnExit := NewButton( Result.Form, '&Exit' ).SetPosition( 428, 16 ).SetSize( 90, 90 );
    {$IFDEF USE_MHTOOLTIP}
    Result.btnExit.Hint.Text := 'Exit';
    {$ENDIF USE_MHTOOLTIP}
    Result.btnRunBds := NewButton( Result.Form, '&Run' ).SetPosition( 119, 16 ).SetSize( 90, 90 );
    {$IFDEF USE_MHTOOLTIP}
    Result.btnRunBds.Hint.Text := 'Run Delphi 10.3.2';
    {$ENDIF USE_MHTOOLTIP}
    Result.btnActive := NewButton( Result.Form, '&Active' ).SetPosition( 16, 16 ).SetSize( 90, 90 );
    {$IFDEF USE_MHTOOLTIP}
    Result.btnActive.Hint.Text := 'Active Delphi 10.3.2';
    {$ENDIF USE_MHTOOLTIP}
      Result.btnAbout.OnClick := Result.btnAboutClick;
      Result.btnReset.OnClick := Result.btnResetClick;
      Result.btnExit.OnClick := Result.btnExitClick;
      Result.btnRunBds.OnClick := Result.btnRunBdsClick;
      Result.btnActive.OnClick := Result.btnActiveClick;
    Result.Form.CenterOnParent.CanResize := False;
    Result.Form.Perform( WM_INITMENU, 0, 0 );
    Result.kolMainFormFormCreate( Result );

end;

