unit main;

interface

uses
  SnowFlake, Shellapi, Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Menus, ExtCtrls, Math, IniFiles;

Const WM_IconTray = WM_User + 2006; //dummy value


Type TMainForm = Class(TForm)
    PopupMenu1: TPopupMenu;
    Exit1: TMenuItem;
       Timer1: TTimer;
    N1: TMenuItem;
    createdbyStefanArhip1: TMenuItem;
       Procedure FormCreate(Sender: TObject);
       Procedure FormDestroy(Sender: TObject);
       Procedure Exit1Click(Sender: TObject);
       Procedure Timer1Timer(Sender: TObject);
     Private
       TrayIconData: TNotifyIconData;
       Procedure TrayMessage(Var Msg: TMessage); Message WM_IconTray;
     Public
       { Public declarations }
     End;

     PLastInputInfo = ^TLastInputInfo;

     {$ExternalSym TagLastInputInfo}
     TagLastInputInfo = Record
                          cbSize: Integer;   // The size of the structure, in bytes. This member must be set to sizeof(LastInputInfo)
                          dwTime: Cardinal;  // The tick count when the last input event was received.
                        End;
     TLastInputInfo = TagLastInputInfo;

     {$ExternalSym GetLastInputInfo}
     Function GetLastInputInfo(Var ALastInputInfo: TLastInputInfo): Integer; StdCall;

Var MainForm : TMainForm;
    vIdleTime : Cardinal;
    SnowFlakesCount, SnowFlakesCreated: Integer;
    SnowFlakesMax, IdleSeconds, DestroyAfter, TreeAnimation: Integer;
    ChristmasTreeFile, SnowFlakeFile: String;

implementation

uses ChristmasTree;

{$R *.dfm}

Function GetLastInputInfo; StdCall; External 'user32.dll';

Function GetUserIdleDuration: Cardinal;
Var vLastInput: TLastInputInfo;
Begin
  vLastInput.cbSize := SizeOf(TLastInputInfo);

  If GetLastInputInfo(vLastInput)<> 0 Then
    Result := GetTickCount - vLastInput.dwTime
  Else
    Result := 0;
End;

procedure TMainForm.FormCreate(Sender: TObject);
Var IniFile: TIniFile;
begin
{$Region '    Read settings   '}
  SnowflakesMax:= 50;
  IdleSeconds:= 5;
  DestroyAfter:= 3;
  TreeAnimation:= 0;
  ChristmasTreeFile:= '';
  SnowFlakeFile:= '';
  IniFile:= TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  Try
    SnowflakesMax:= IniFile.ReadInteger('Snowflakes', 'Max', SnowflakesMax);
    IdleSeconds:= IniFile.ReadInteger('Snowflakes', 'Idle', IdleSeconds);
    DestroyAfter:= IniFile.ReadInteger('Snowflakes', 'Destroy', DestroyAfter);
    TreeAnimation:= IniFile.ReadInteger('Snowflakes', 'Animation', TreeAnimation);
    ChristmasTreeFile:= IniFile.ReadString('Snowflakes', 'Tree', ChristmasTreeFile);
    SnowFlakeFile:= IniFile.ReadString('Snowflakes', 'Snowflake', SnowFlakeFile);
  Finally
    IniFile.Free;
  End;
{$EndRegion}

{$Region '    Display tray icon   '}
  With TrayIconData Do
    Begin
      cbSize := SizeOf(TrayIconData);
      Wnd := Handle;
      uID := 0;
      uFlags := Nif_Message + Nif_Icon + Nif_Tip;
      uCallbackMessage := WM_IconTray;
      hIcon := Application.Icon.Handle;
      StrPCopy(szTip, Application.Title);
    End;

  Shell_NotifyIcon(Nim_Add, @TrayIconData);
{$EndRegion}

{$Region  '    Hide application from taskbar   '}
  ShowWindow(Application.Handle, SW_Hide);
  SetWindowLong(Application.Handle, GWL_ExStyle, GetWindowLong(Application.Handle, GWL_ExStyle) or WS_EX_ToolWindow);
  ShowWindow(Application.Handle, SW_Show);
{$EndRegion}
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Shell_NotifyIcon(Nim_Delete, @TrayIconData);
end;

Procedure TMainForm.Timer1Timer(Sender: TObject);
Var vLastInput: TLastInputInfo;
begin
{$Region '    Detect idle   '}
  vLastInput.cbSize := SizeOf(TLastInputInfo);
  vLastInput.dwTime := 0;

  If GetLastInputInfo(vLastInput) <> 0 Then
    vIdleTime := GetTickCount - vLastInput.dwTime
  Else
    vIdleTime := 0;
{$EndRegion}

{$Region '    Create snowflakes   '}
  If vIdleTime Div 1000> IdleSeconds Then
    Begin
      If Not ChristmasTreeForm.IsVisible Then
        Begin
          ChristmasTreeForm.Rise:= True;
          ChristmasTreeForm.Show;
          ChristmasTreeForm.IsVisible:= True;
          ChristmasTreeForm.Timer1.Enabled:= True;
        End;
      SnowFlakesCount:= SnowFlakesMax* Screen.MonitorCount;
      While SnowFlakesCreated< SnowFlakesCount Do
        TSnowFlakeForm.Execute(Self);
    End
{$EndRegion}

{$Region '    Melt snowflakes   '}
  Else
    Begin
      SnowFlakesCount:= 0;
      If ChristmasTreeForm.IsVisible Then
        Begin
          ChristmasTreeForm.Rise:= False;
          ChristmasTreeForm.Timer1.Enabled:= True;
        End;
    End;
{$EndRegion}
End;

procedure TMainForm.TrayMessage(var Msg: TMessage);
Var p : TPoint;
begin
  Case Msg.lParam Of
    WM_LButtonDown:
      Begin
        SetForegroundWindow(Handle);
        GetCursorPos(p);
        PopupMenu1.Popup(p.x, p.y);
        PostMessage(Handle, WM_Null, 0, 0);
      End;
  End;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

Initialization
  Randomize;
  SnowFlakesCount:= 0;
  SnowFlakesCreated:= 0;

Finalization

end.
