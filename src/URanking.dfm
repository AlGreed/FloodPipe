object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Ranking'
  ClientHeight = 463
  ClientWidth = 790
  Color = 2036748
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 16
    Top = 8
    Width = 361
    Height = 190
    Caption = ' mittlere Anzahl von Klicks pro Zelle im '#220'berlaufmodus '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 14664559
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object ListView1: TListView
      Left = 3
      Top = 16
      Width = 350
      Height = 171
      Columns = <>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ReadOnly = True
      ParentFont = False
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 408
    Top = 8
    Width = 361
    Height = 190
    Caption = ' mittlere Zeit pro Zelle im '#220'berlaufmodus '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 14664559
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object ListView2: TListView
      Left = 8
      Top = 16
      Width = 350
      Height = 171
      Columns = <>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object GroupBox4: TGroupBox
    Left = 408
    Top = 234
    Width = 361
    Height = 190
    Caption = ' mittlere Zeit pro Zelle im einfachen Modus '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 14664559
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object ListView4: TListView
      Left = 8
      Top = 16
      Width = 350
      Height = 171
      Columns = <>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 16
    Top = 234
    Width = 361
    Height = 190
    Caption = ' mittlere Anzahl von Klicks pro Zelle im einfachen Modus '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 14664559
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object ListView3: TListView
      Left = 3
      Top = 16
      Width = 350
      Height = 171
      Columns = <>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
end
