unit ChristmasTree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Jpeg;

type
  TChristmasTreeForm = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Rise: Boolean;
    IsVisible: Boolean;
  protected
    procedure CreateParams (Var Params: TCreateParams); Override;
  end;

Var ChristmasTreeForm: TChristmasTreeForm;

implementation

uses main;

{$R *.dfm}

procedure TChristmasTreeForm.FormCreate(Sender: TObject);
begin
  If FileExists(ChristmasTreeFile) Then
    ChristmasTreeForm.Image1.Picture.LoadFromFile(ChristmasTreeFile);
  Rise:= True;
  IsVisible:= False;
  ChristmasTreeForm.ClientWidth:= Image1.Width;
  ChristmasTreeForm.ClientHeight:= Image1.Height;
  Case TreeAnimation Of
    0:
      Begin
        ChristmasTreeForm.AlphaBlend:= False;
        ChristmasTreeForm.AlphaBlendValue:= 255;
        ChristmasTreeForm.Left:= (Screen.Width- ChristmasTreeForm.Width) Div 2;
        ChristmasTreeForm.Top:= Screen.Height;
      End;
    1:
      Begin
        ChristmasTreeForm.AlphaBlend:= True;
        ChristmasTreeForm.AlphaBlendValue:= 0;
        ChristmasTreeForm.Left:= (Screen.Width- ChristmasTreeForm.Width) Div 2;
        ChristmasTreeForm.Top:= Screen.Height- Height;
      End;
  End;
end;

procedure TChristmasTreeForm.Timer1Timer(Sender: TObject);
begin
{$Region '    Show christmas tree   '}
  If Rise Then
    Case TreeAnimation Of
      0:
        Begin
          ChristmasTreeForm.Top:= ChristmasTreeForm.Top- 10;
          Refresh;
          If ChristmasTreeForm.Top<= Screen.Height- ChristmasTreeForm.Height Then
            Timer1.Enabled:= False;
        End;
      1:
        Begin
          If Not ChristmasTreeForm.IsVisible Then
            Begin
              ChristmasTreeForm.AlphaBlendValue:= 0;
              ChristmasTreeForm.Show;
              ChristmasTreeForm.IsVisible:= True;
            End;
          ChristmasTreeForm.AlphaBlendValue:= ChristmasTreeForm.AlphaBlendValue+ 5;
          Refresh;
          If ChristmasTreeForm.AlphaBlendValue>= 255 Then
            Timer1.Enabled:= False;
        End;
    End
{$EndRegion}
{$Region '    Hide christmas tree   '}
  Else
    Case TreeAnimation Of
      0:
        Begin
          ChristmasTreeForm.Top:= ChristmasTreeForm.Top+ 10;
          Refresh;
          If ChristmasTreeForm.Top> Screen.Height Then
            Begin
              Timer1.Enabled:= False;
              IsVisible:= False;
              Close;
            End;
        End;
      1:
        Begin
          ChristmasTreeForm.AlphaBlendValue:= ChristmasTreeForm.AlphaBlendValue- 5;
          Refresh;
          If ChristmasTreeForm.AlphaBlendValue<= 0 Then
            Begin
              ChristmasTreeForm.IsVisible:= False;
              Timer1.Enabled:= False;
              ChristmasTreeForm.Close;
            End;
        End;
    End;
{$EndRegion}
end;

procedure TChristmasTreeForm.CreateParams(var Params: TCreateParams);
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
