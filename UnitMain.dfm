object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'TODO List'
  ClientHeight = 593
  ClientWidth = 411
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object pnlAdding: TPanel
    Left = 0
    Top = 0
    Width = 411
    Height = 41
    Align = alTop
    TabOrder = 0
    object lblQuest: TLabel
      Left = 10
      Top = 9
      Width = 48
      Height = 21
      Caption = 'Quest:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtAdd: TEdit
      Left = 68
      Top = 9
      Width = 233
      Height = 23
      TabOrder = 0
      OnKeyPress = edtAddKeyPress
    end
    object btnAdd: TButton
      Left = 316
      Top = 8
      Width = 69
      Height = 25
      Caption = '+ Add'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnAddClick
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 41
    Width = 411
    Height = 448
    Align = alTop
    TabOrder = 1
    object lbxQuests: TListBox
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 399
      Height = 436
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      ItemHeight = 15
      TabOrder = 0
      OnMouseDown = lbxQuestsMouseDown
    end
  end
  object pnlSavingAndLoading: TPanel
    Left = 0
    Top = 489
    Width = 411
    Height = 104
    Align = alClient
    TabOrder = 2
    ExplicitHeight = 47
    object btnSaveToJson: TButton
      Left = 15
      Top = 10
      Width = 127
      Height = 25
      Caption = 'Save to JSON'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnSaveToJsonClick
    end
    object btnLoadFromJson: TButton
      Left = 15
      Top = 50
      Width = 127
      Height = 25
      Caption = 'Load from JSON'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnLoadFromJsonClick
    end
    object RadioGroup1: TRadioGroup
      AlignWithMargins = True
      Left = 213
      Top = 1
      Width = 194
      Height = 97
      Margins.Top = 0
      Margins.Bottom = 5
      Align = alRight
      Caption = 'Filter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      ExplicitLeft = 216
      ExplicitHeight = 102
    end
    object cbxShowAll: TCheckBox
      Left = 232
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Show All'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = cbxShowAllClick
    end
    object cbxShowFinished: TCheckBox
      Left = 232
      Top = 47
      Width = 97
      Height = 17
      Caption = 'Show finished'
      TabOrder = 4
      OnClick = cbxShowFinishedClick
    end
    object cbxShowActive: TCheckBox
      Left = 232
      Top = 70
      Width = 97
      Height = 17
      Caption = 'Show active'
      TabOrder = 5
      OnClick = cbxShowActiveClick
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 320
    Top = 89
    object btnDelete: TMenuItem
      Caption = 'Delete'
      OnClick = btnDeleteClick
    end
    object btnFinish: TMenuItem
      Caption = 'Finish'
      OnClick = btnFinishClick
    end
  end
end
