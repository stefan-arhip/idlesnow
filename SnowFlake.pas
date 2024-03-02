unit SnowFlake;

interface

uses
  Math, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls;

Type
  TSnowFlakeForm = class(TForm)
    Timer1: TTimer;
    Image1: TImage;
    Procedure FormCreate(Sender: TObject);
    Procedure Timer1Timer(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  Protected
    Rect1: TRect;
    MonIndex: Integer;
    Procedure CreateParams (Var Params: TCreateParams); Override;
  Public
    DestroyAfter: Integer;
    Class Procedure Execute(AOwner : TComponent);
  End;

implementation

{$R *.dfm}

Uses Main;

Class Procedure TSnowFlakeForm.Execute(AOwner : TComponent);
Begin
  //Main Form is the Owner - will free this form when the app terminates;
  TSnowFlakeForm.Create(AOwner).Show;
End;

procedure TSnowFlakeForm.FormCreate(Sender: TObject);
begin
  If FileExists(SnowFlakeFile) Then
    Image1.Picture.LoadFromFile(SnowFlakeFile);
  ClientWidth:= Image1.Width;
  ClientHeight:= Image1.Height;
  //  Width:= 16;
  //  Height:= 16;

  MonIndex:= RandomRange(0, Screen.MonitorCount);
  Rect1:= Screen.Monitors[MonIndex].BoundsRect;
  DestroyAfter := RandomRange(0, DestroyAfter* 1000 Div Timer1.Interval);
  Inc(SnowFlakesCreated);


  FormStyle := fsStayOnTop;
  Timer1.Enabled := True;
end;

procedure TSnowFlakeForm.Timer1Timer(Sender: TObject);
Const MaxDelta = 10;
      mxy : Array[0..1] Of Integer = (-1, 1);
Var   dx, mx : Integer;
begin
{$Region '    Melt snowflakes   '}
  If SnowFlakesCreated> SnowFlakesCount Then
    Begin
      If DestroyAfter<= 0 Then
        Begin
          Dec(SnowFlakesCreated);
          Destroy;
        End
      Else
        Dec(DestroyAfter);
    End;
{$EndRegion}

{$Region '    Move snowflake    '}
  dx := RandomRange(1, MaxDelta);
  mx := RandomFrom(mxy);
  Left := Left + mx * dx;
  Top := Top + 10;
{$EndRegion}

{$Region '    Don''t move of the monitor''s rect  '}
  If Left < Rect1.Left Then
    Left := Rect1.Right- Width
  Else If Left > Rect1.Right- Width Then
    Left := Rect1.Left;

  If Top > Rect1.Bottom- Height Then
    Top := Rect1.Top;
{$EndRegion}
end;

procedure TSnowFlakeForm.FormDestroy(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TSnowFlakeForm.FormShow(Sender: TObject);
begin
  Left := RandomRange(Rect1.Left, Rect1.Right);
  Top := RandomRange(Rect1.Top, Rect1.Bottom);
end;

procedure TSnowFlakeForm.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams(Params);
{$Region '   Stay on top + Hide taskbar button + Transparent + No title bar   }
  With Params Do
    Begin
      WndParent := GetDesktopWindow;
      Style := Style And Not WS_Caption;
      ExStyle := ExStyle Or WS_EX_TopMost Or WS_EX_ToolWindow Or WS_EX_Transparent;
    End;
{$EndRegion}
end;

end.
