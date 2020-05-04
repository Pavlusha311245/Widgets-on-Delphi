object CalcForm: TCalcForm
  Left = 1135
  Top = 401
  BorderStyle = bsNone
  Caption = 'CalcForm'
  ClientHeight = 180
  ClientWidth = 120
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TButton
    Left = 0
    Top = 64
    Width = 25
    Height = 25
    Caption = '1'
    TabOrder = 0
  end
  object btn2: TButton
    Left = 24
    Top = 64
    Width = 25
    Height = 25
    Caption = '2'
    TabOrder = 1
  end
  object btn3: TButton
    Left = 48
    Top = 64
    Width = 25
    Height = 25
    Caption = '3'
    TabOrder = 2
  end
  object btn4: TButton
    Left = 0
    Top = 88
    Width = 25
    Height = 25
    Caption = '4'
    TabOrder = 3
  end
  object btn5: TButton
    Left = 24
    Top = 88
    Width = 25
    Height = 25
    Caption = '5'
    TabOrder = 4
  end
  object btn6: TButton
    Left = 48
    Top = 88
    Width = 25
    Height = 25
    Caption = '6'
    TabOrder = 5
  end
  object btn7: TButton
    Left = 0
    Top = 112
    Width = 25
    Height = 25
    Caption = '7'
    TabOrder = 6
  end
  object edt1: TEdit
    Left = 0
    Top = 0
    Width = 120
    Height = 21
    TabOrder = 7
  end
  object btn8: TButton
    Left = 24
    Top = 112
    Width = 25
    Height = 25
    Caption = '8'
    TabOrder = 8
  end
  object btn9: TButton
    Left = 48
    Top = 112
    Width = 25
    Height = 25
    Caption = '9'
    TabOrder = 9
  end
  object btn0: TButton
    Left = 0
    Top = 136
    Width = 25
    Height = 25
    Caption = '0'
    TabOrder = 10
  end
  object btnplus: TButton
    Left = 80
    Top = 64
    Width = 25
    Height = 25
    Caption = '+'
    TabOrder = 11
  end
  object btnminus: TButton
    Left = 80
    Top = 88
    Width = 25
    Height = 25
    Caption = '-'
    TabOrder = 12
  end
  object btnmul: TButton
    Left = 80
    Top = 112
    Width = 25
    Height = 25
    Caption = 'X'
    TabOrder = 13
  end
  object btndiv: TButton
    Left = 80
    Top = 136
    Width = 25
    Height = 25
    Caption = '/'
    TabOrder = 14
  end
  object PopupMenu: TPopupMenu
    object W1: TMenuItem
      Caption = 'Widgets'
    end
    object N1: TMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1080#1076#1078#1077#1090
    end
    object N2: TMenuItem
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1080#1076#1078#1077#1090
      object N3: TMenuItem
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      end
      object N4: TMenuItem
        Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      end
    end
  end
end
