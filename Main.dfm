object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Main'
  ClientHeight = 387
  ClientWidth = 774
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 27
    Width = 27
    Height = 13
    Caption = 'Nome'
  end
  object Label2: TLabel
    Left = 8
    Top = 51
    Width = 19
    Height = 13
    Caption = 'CPF'
  end
  object Label3: TLabel
    Left = 8
    Top = 81
    Width = 45
    Height = 13
    Caption = 'Endere'#231'o'
  end
  object Label4: TLabel
    Left = 8
    Top = 108
    Width = 19
    Height = 13
    Caption = 'Cep'
  end
  object Label5: TLabel
    Left = 315
    Top = 103
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object edtNome: TEdit
    Left = 59
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object edtCpf: TEdit
    Left = 59
    Top = 51
    Width = 110
    Height = 21
    TabOrder = 1
  end
  object edtEndereco: TEdit
    Left = 59
    Top = 78
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object edtCEP: TEdit
    Left = 59
    Top = 105
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object Button1: TButton
    Left = 59
    Top = 132
    Width = 75
    Height = 25
    Caption = 'Inserir'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 398
    Top = 127
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 5
    OnClick = Button2Click
  end
  object edtID: TEdit
    Left = 352
    Top = 100
    Width = 121
    Height = 21
    TabOrder = 6
  end
  object Update: TButton
    Left = 140
    Top = 132
    Width = 75
    Height = 25
    Caption = 'Update'
    TabOrder = 7
    OnClick = UpdateClick
  end
end
