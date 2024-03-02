object MainForm: TMainForm
  Left = 407
  Top = 394
  Caption = 'MainSnowFlake'
  ClientHeight = 84
  ClientWidth = 183
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PopupMenu1: TPopupMenu
    Left = 36
    Top = 20
    object createdbyStefanArhip1: TMenuItem
      Caption = 'created by Stefan Arhip'
      Enabled = False
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Exit1: TMenuItem
      Caption = 'E&xit'
      OnClick = Exit1Click
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 120
    Top = 24
  end
end
