object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'FloodPipe'
  ClientHeight = 753
  ClientWidth = 1016
  Color = 2036748
  Constraints.MaxHeight = 1024
  Constraints.MaxWidth = 1800
  Constraints.MinHeight = 768
  Constraints.MinWidth = 1024
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = 4366591
  Font.Height = -16
  Font.Name = 'Liberation Sans Narrow'
  Font.Style = [fsBold, fsItalic]
  OldCreateOrder = False
  PopupMode = pmAuto
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 18
  object Label1: TLabel
    Left = 88
    Top = 405
    Width = 6
    Height = 24
    Align = alCustom
    Font.Charset = ANSI_CHARSET
    Font.Color = 14664559
    Font.Height = -21
    Font.Name = 'TR2N'
    Font.Style = []
    ParentFont = False
    Layout = tlBottom
  end
  object MediaPlayer1: TMediaPlayer
    Left = 392
    Top = 405
    Width = 253
    Height = 30
    Visible = False
    TabOrder = 0
  end
  object NewGameButton: TPanel
    Left = 16
    Top = 0
    Width = 169
    Height = 41
    Align = alCustom
    Caption = 'New game'
    Color = 2036748
    Font.Charset = ANSI_CHARSET
    Font.Color = 14664559
    Font.Height = -21
    Font.Name = 'TR2N'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    OnClick = NewGameButtonClick
    OnMouseEnter = NewGameButtonMouseEnter
    OnMouseLeave = NewGameButtonMouseLeave
  end
  object SettingsButton: TPanel
    Left = 16
    Top = 143
    Width = 169
    Height = 41
    Caption = 'Settings'
    Color = 2036748
    Font.Charset = ANSI_CHARSET
    Font.Color = 14664559
    Font.Height = -21
    Font.Name = 'TR2N'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
    OnClick = SettingsButtonClick
    OnMouseEnter = SettingsButtonMouseEnter
    OnMouseLeave = SettingsButtonMouseLeave
  end
  object StatsButton: TPanel
    Left = 16
    Top = 190
    Width = 169
    Height = 41
    Caption = 'Stats'
    Color = 2036748
    Font.Charset = ANSI_CHARSET
    Font.Color = 14664559
    Font.Height = -21
    Font.Name = 'TR2N'
    Font.Style = [fsBold, fsItalic]
    ParentBackground = False
    ParentFont = False
    TabOrder = 4
    OnClick = StatsButtonClick
    OnMouseEnter = StatsButtonMouseEnter
    OnMouseLeave = StatsButtonMouseLeave
  end
  object ExitButton: TPanel
    Left = 16
    Top = 237
    Width = 169
    Height = 41
    Caption = 'Exit'
    Color = 2036748
    Font.Charset = ANSI_CHARSET
    Font.Color = 14664559
    Font.Height = -21
    Font.Name = 'TR2N'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 5
    OnClick = ExitButtonClick
    OnMouseEnter = ExitButtonMouseEnter
    OnMouseLeave = ExitButtonMouseLeave
  end
  object DrawGrid1: TDrawGrid
    Left = 203
    Top = 5
    Width = 1028
    Height = 768
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Color = clMenu
    Constraints.MaxHeight = 1080
    Constraints.MaxWidth = 1800
    Constraints.MinHeight = 768
    Constraints.MinWidth = 1028
    DefaultColWidth = 0
    DefaultRowHeight = 0
    DoubleBuffered = False
    FixedCols = 0
    RowCount = 2
    FixedRows = 0
    ParentDoubleBuffered = False
    ScrollBars = ssNone
    TabOrder = 2
    OnDrawCell = DrawGrid1DrawCell
    OnMouseUp = DrawGrid1MouseUp
  end
  object Panel1: TPanel
    Left = 0
    Top = 712
    Width = 1016
    Height = 41
    Align = alBottom
    BorderStyle = bsSingle
    Color = 2036748
    Font.Charset = ANSI_CHARSET
    Font.Color = 14664559
    Font.Height = -21
    Font.Name = 'TR2N'
    Font.Style = [fsBold, fsItalic]
    ParentBackground = False
    ParentFont = False
    TabOrder = 6
    Visible = False
  end
  object LoadButton: TPanel
    Left = 16
    Top = 47
    Width = 169
    Height = 41
    Caption = 'Load'
    Color = 2036748
    Font.Charset = ANSI_CHARSET
    Font.Color = 14664559
    Font.Height = -21
    Font.Name = 'TR2N'
    Font.Style = [fsBold, fsItalic]
    ParentBackground = False
    ParentFont = False
    TabOrder = 7
    OnClick = LoadButtonClick
    OnMouseEnter = LoadButtonMouseEnter
    OnMouseLeave = LoadButtonMouseLeave
  end
  object SaveButton: TPanel
    Left = 16
    Top = 96
    Width = 169
    Height = 41
    Caption = 'Save'
    Color = 2036748
    Font.Charset = ANSI_CHARSET
    Font.Color = 14664559
    Font.Height = -21
    Font.Name = 'TR2N'
    Font.Style = [fsBold, fsItalic]
    ParentBackground = False
    ParentFont = False
    TabOrder = 8
    OnClick = SaveButtonClick
    OnMouseEnter = SaveButtonMouseEnter
    OnMouseLeave = SaveButtonMouseLeave
  end
  object MusikTimer: TTimer
    Enabled = False
    OnTimer = MusikTimerTimer
    Left = 296
    Top = 408
  end
  object ImageList1: TImageList
    Left = 256
    Top = 408
  end
  object Timer2: TTimer
    Enabled = False
    OnTimer = Timer2Timer
    Left = 336
    Top = 408
  end
end
