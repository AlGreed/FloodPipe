object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Settings'
  ClientHeight = 335
  ClientWidth = 550
  Color = 2036748
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 534
    Height = 97
    Caption = '  Dimension  '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = 14664559
    Font.Height = -11
    Font.Name = 'Liberation Sans Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 28
      Height = 12
      Caption = 'Rows:'
    end
    object Label2: TLabel
      Left = 280
      Top = 24
      Width = 44
      Height = 12
      Caption = 'Columns:'
    end
    object Label3: TLabel
      Left = 50
      Top = 24
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 14664559
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 330
      Top = 25
      Width = 3
      Height = 12
    end
    object RowTrackBar: TTrackBar
      Left = 17
      Top = 42
      Width = 241
      Height = 54
      ParentCustomHint = False
      Ctl3D = True
      DoubleBuffered = False
      Min = 2
      ParentCtl3D = False
      ParentDoubleBuffered = False
      ParentShowHint = False
      Position = 2
      ShowHint = False
      ShowSelRange = False
      TabOrder = 0
      OnChange = RowTrackBarChange
    end
    object ColTrackBar: TTrackBar
      Left = 277
      Top = 42
      Width = 241
      Height = 45
      Min = 2
      Position = 2
      ShowSelRange = False
      TabOrder = 1
      OnChange = ColTrackBarChange
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 262
    Width = 257
    Height = 58
    Caption = '  Overflow  '
    Color = 2036748
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = 14664559
    Font.Height = -11
    Font.Name = 'Liberation Sans Narrow'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    object overflowCheckBox: TCheckBox
      Left = 16
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Activated'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = 14664559
      Font.Height = -11
      Font.Name = 'Liberation Sans Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = overflowCheckBoxClick
    end
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 110
    Width = 257
    Height = 146
    Caption = '  Color  '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = 14664559
    Font.Height = -11
    Font.Name = 'Liberation Sans Narrow'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object RadioButton1: TRadioButton
    Left = 17
    Top = 128
    Width = 113
    Height = 17
    Caption = 'Background'
    Checked = True
    Color = 2036748
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 14664559
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 3
    TabStop = True
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 17
    Top = 151
    Width = 113
    Height = 17
    Caption = 'empty Pipe'
    Color = 2036748
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = 14664559
    Font.Height = -11
    Font.Name = 'Liberation Sans Narrow'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 4
    OnClick = RadioButton2Click
  end
  object RadioButton3: TRadioButton
    Left = 17
    Top = 174
    Width = 113
    Height = 17
    BiDiMode = bdLeftToRight
    Caption = 'full Pipe'
    Color = 2036748
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = 14664559
    Font.Height = -11
    Font.Name = 'Liberation Sans Narrow'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentColor = False
    ParentFont = False
    TabOrder = 5
    OnClick = RadioButton3Click
  end
  object RadioButton4: TRadioButton
    Left = 17
    Top = 197
    Width = 113
    Height = 17
    BiDiMode = bdLeftToRight
    Caption = 'Spring'
    Color = 2036748
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBiDiMode = False
    ParentColor = False
    ParentFont = False
    TabOrder = 6
    OnClick = RadioButton4Click
  end
  object RadioButton5: TRadioButton
    Left = 17
    Top = 220
    Width = 113
    Height = 17
    Caption = 'Wall'
    Font.Charset = ANSI_CHARSET
    Font.Color = 14664559
    Font.Height = -11
    Font.Name = 'Liberation Sans Narrow'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = RadioButton5Click
  end
  object Panel1: TPanel
    Left = 136
    Top = 129
    Width = 25
    Height = 25
    BorderStyle = bsSingle
    Constraints.MaxHeight = 25
    Constraints.MaxWidth = 25
    Constraints.MinHeight = 25
    Constraints.MinWidth = 25
    ParentBackground = False
    TabOrder = 8
  end
  object ColorButton: TPanel
    Left = 167
    Top = 129
    Width = 75
    Height = 25
    Caption = 'Change'
    Color = 2036748
    Constraints.MaxHeight = 25
    Constraints.MaxWidth = 75
    Constraints.MinHeight = 25
    Constraints.MinWidth = 75
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 14664559
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 9
    OnClick = ColorButtonClick
  end
  object TronCheckBox: TCheckBox
    Left = 167
    Top = 219
    Width = 75
    Height = 17
    Caption = 'Tron Theme'
    Color = 2036748
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 14664559
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 10
    OnClick = TronCheckBoxClick
  end
  object GroupBox2: TGroupBox
    Left = 450
    Top = 111
    Width = 92
    Height = 213
    Caption = 'Wall: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 14664559
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    object WandTrackBar: TTrackBar
      Left = 20
      Top = 18
      Width = 50
      Height = 181
      Max = 100
      Min = 8
      Orientation = trVertical
      Frequency = 4
      Position = 8
      TabOrder = 0
      TickMarks = tmBoth
      OnChange = WandTrackBarChange
    end
  end
  object ApplyButton: TPanel
    Left = 285
    Top = 175
    Width = 149
    Height = 41
    Caption = 'Apply'
    Color = 2036748
    Font.Charset = ANSI_CHARSET
    Font.Color = 14664559
    Font.Height = -16
    Font.Name = 'TR2N'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 12
    OnClick = ApplyButtonClick
    OnMouseEnter = ApplyButtonMouseEnter
    OnMouseLeave = ApplyButtonMouseLeave
  end
  object AbortButton: TPanel
    Left = 285
    Top = 238
    Width = 149
    Height = 41
    Caption = 'Abort'
    Color = 2036748
    Font.Charset = ANSI_CHARSET
    Font.Color = 14664559
    Font.Height = -16
    Font.Name = 'TR2N'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 13
    OnClick = AbortButtonClick
    OnMouseEnter = AbortButtonMouseEnter
    OnMouseLeave = AbortButtonMouseLeave
  end
  object ColorDialog1: TColorDialog
    Left = 232
    Top = 312
  end
end
