unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus, JSON, IOUtils;

type
  TfrmMain = class(TForm)
    pnlAdding: TPanel;
    pnlMain: TPanel;
    pnlSavingAndLoading: TPanel;
    edtAdd: TEdit;
    lblQuest: TLabel;
    btnAdd: TButton;
    lbxQuests: TListBox;
    btnSaveToJson: TButton;
    PopupMenu1: TPopupMenu;
    btnDelete: TMenuItem;
    btnFinish: TMenuItem;
    btnLoadFromJson: TButton;
    RadioGroup1: TRadioGroup;
    cbxShowAll: TCheckBox;
    cbxShowFinished: TCheckBox;
    cbxShowActive: TCheckBox;
    procedure btnAddClick(Sender: TObject);
    procedure lbxQuestsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnFinishClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnSaveToJsonClick(Sender: TObject);
    procedure btnLoadFromJsonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbxShowAllClick(Sender: TObject);
    procedure cbxShowFinishedClick(Sender: TObject);
    procedure cbxShowActiveClick(Sender: TObject);
    procedure edtAddKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    fFil: Integer;
    slAll: TStringList;
    isChanged: Boolean;
    procedure parsujJson(aSL: TStringList; withIFilter: Boolean = True);
    procedure checkFilter(iFilter: Integer);
    procedure changeFilter;
    procedure tempSave;
    function isFinished(text: String): Boolean;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

CONST
  NAME_OF_FILE = '\quests.json';
  SIGN_FINISHED = '*** Finished.';

implementation

{$R *.dfm}

procedure TfrmMain.btnAddClick(Sender: TObject);
begin
  if edtAdd.Text <> '' then begin
    lbxQuests.Items.Add(edtAdd.Text);
    edtAdd.Text := '';
    isChanged := True;
  end;
  //
  tempSave;
end;

procedure TfrmMain.tempSave;
var
  jsQuests, jsQ: TJSONObject;
  jaQ: TJSONArray;
  i: integer;
begin
  jsQuests := TJSONObject.Create;
  jaQ := TJSONArray.Create;
  jsQuests.AddPair('numberOfQuests', lbxQuests.Items.Count);
  if cbxShowAll.Checked then
    jsQuests.AddPair('filter', 1)
  else if cbxShowFinished.Checked then
    jsQuests.AddPair('filter', 2)
  else
    jsQuests.AddPair('filter', 3);
  try
    for i := 0 to lbxQuests.Items.Count - 1 do begin
      jsQ := TJSONObject.Create;
      jsQ.AddPair('Q', lbxQuests.Items[i]);
      jaQ.Add(jsQ);
    end;
    //
    jsQuests.AddPair('Quests', jaQ);
    slAll.Clear;
    slAll.Add(jsQuests.ToJSON);
  finally
    FreeAndNil(jsQuests);
    isChanged := True;
  end;
end;

procedure TfrmMain.btnSaveToJsonClick(Sender: TObject);
var
  jsQuests, jsQ, jsObj: TJSONObject;
  jaQ, jaA: TJSONArray;
  jsVal: TJSONValue;
  i: integer;
  sl:TStringList;
begin
  if lbxQuests.Items.IsEmpty then begin
    ShowMessage('You do not have any quests.');
    exit;
  end;
  sl := TStringList.Create;
  jsQuests := TJSONObject.Create;
  jaQ := TJSONArray.Create;
  jsQuests.AddPair('numberOfQuests', lbxQuests.Items.Count);
  if cbxShowAll.Checked then
    fFil := 1
  else if cbxShowFinished.Checked then
    fFil := 2
  else
    fFil := 3;
  jsQuests.AddPair('filter', fFIl);
  try
    if fFil = 1 then
      for i := 0 to lbxQuests.Items.Count - 1 do begin
        jsQ := TJSONObject.Create;
        jsQ.AddPair('Q', lbxQuests.Items[i]);
        jaQ.Add(jsQ);
      end
    else begin
      jsVal := TJSONObject.ParseJSONValue(slAll.Strings[0]);  // whole JSON is in one row
      jsObj := jsVal as TJSONObject;
      jaA := jsObj.GetValue<TJSONArray>('Quests');
      for i  := 0 to jaA.Count - 1 do begin
        jsQ := TJSONObject.Create;
        jsObj := jaA.Items[i] as TJSONObject;
        jsQ.AddPair('Q', jsObj.GetValue<String>('Q'));
        jaQ.Add(jsQ);
      end;
    end;
    jsQuests.AddPair('Quests', jaQ);
    // saving with constant name - for now
    sl.Add(jsQuests.ToJSON);
    sl.SaveToFile(TPath.GetDocumentsPath + NAME_OF_FILE);
  finally
    FreeAndNil(sl);
    FreeAndNil(jsQuests);
//    if jsObj <> nil then  // sometimes is null
//      FreeAndNil(jsObj);
    isChanged := False;
  end;
end;

procedure TfrmMain.cbxShowActiveClick(Sender: TObject);
begin
  cbxShowActive.Checked := True;
  fFil := 3;
  parsujJson(slAll, false);
end;

procedure TfrmMain.cbxShowAllClick(Sender: TObject);
begin
  cbxShowAll.Checked := True;
  fFil := 1;
  parsujJson(slAll, false);
end;

procedure TfrmMain.cbxShowFinishedClick(Sender: TObject);
begin
  cbxShowFinished.Checked := True;
  fFil := 2;
  parsujJson(slAll, false);
end;

procedure TfrmMain.changeFilter;
begin
  if cbxShowAll.Checked then begin
    btnAdd.Enabled := True;
    edtAdd.Enabled := True;
  end
  else begin
    btnAdd.Enabled := False;
    edtAdd.Enabled := False;
  end;
end;

procedure TfrmMain.checkFilter(iFilter: Integer);
begin
  cbxShowAll.OnClick := nil;
  cbxShowFinished.OnClick := nil;
  cbxShowActive.OnClick := nil;
  //
  case iFilter of
    1: begin
      cbxShowFinished.Checked := False;
      cbxShowActive.Checked := False;
    end;
    2: begin
      cbxShowAll.Checked := False;
      cbxShowActive.Checked := False;
    end;
    3: begin
      cbxShowFinished.Checked := False;
      cbxShowAll.Checked := False;
    end;
  end;
  //
  cbxShowAll.OnClick := cbxShowAllClick;
  cbxShowFinished.OnClick := cbxShowFinishedClick;
  cbxShowActive.OnClick := cbxShowActiveClick;
  changeFilter;
end;

procedure TfrmMain.edtAddKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_RETURN then begin
    btnAddClick(nil);
  end;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if isChanged then begin
  if MessageDlg( 'Do you want to exit the program? You have some unsaved changes.',
    mtConfirmation, [mbYes, mbCancel], 0) = mrCancel then CanClose := false;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  slAll := TStringList.Create;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  selectedFile: String;
  sl: TStringList;
begin
  sl  := TStringList.Create;
  selectedFile := TPath.GetDocumentsPath + NAME_OF_FILE;
  try
    if FileExists(selectedFile) then begin
      sl.LoadFromFile(selectedFile);
      slAll.LoadFromFile(selectedFile);
      parsujJson(sl);
    end;
  finally
    FreeAndNil(sl);
    isChanged := False;
  end;
end;

procedure TfrmMain.btnLoadFromJsonClick(Sender: TObject);
var
  selectedFile: string;
  dlg: TOpenDialog;
  sl: TStringList;
begin
  sl  := TStringList.Create;
  selectedFile := '';
  dlg := TOpenDialog.Create(nil);
  try
    dlg.InitialDir := TPath.GetDocumentsPath;
    dlg.Filter := 'JSon files (*.json)|*.json';
    if dlg.Execute(Handle) then
      selectedFile := dlg.FileName;
  finally
    dlg.Free;
  end;
  //
  if selectedFile <> '' then begin
    try
      sl.LoadFromFile(selectedFile);
      parsujJson(sl);
    finally
      FreeAndNil(sl);
      isChanged := False;
    end;
  end;
end;

procedure TfrmMain.parsujJson(aSL: TStringList; withIFilter: Boolean = True);
var
  jv: TJSONValue;
  jo: TJSONObject;
  ja: TJSONArray;
  i, iFilter: Integer;
  pomString: String;
begin
  jv := TJSONObject.ParseJSONValue(aSL.Strings[0]);  // whole JSON is in one row
  jo := jv as TJSONObject;
  iFilter := jo.GetValue<Integer>('filter');
  if NOT withIFilter then
    iFilter := fFil;
  ja := jo.GetValue<TJSONArray>('Quests');
//  for i := 0 to lbxQuests.Items.Count - 1 do  // old way to clear items from listbox
//    lbxQuests.Items.Delete(i);
  lbxQuests.Clear;
  //
  cbxShowAll.OnClick := nil;
  cbxShowFinished.OnClick := nil;
  cbxShowActive.OnClick := nil;
  case iFilter of
    1: begin
      cbxShowAll.Checked := True;
      for i := 0 to ja.Count - 1 do begin
        jo := ja.Items[i] as TJSONObject;
        lbxQuests.Items.Add(jo.GetValue<String>('Q'));
      end;
    end;
    2: begin
      cbxShowFinished.Checked := True;
      for i := 0 to ja.Count - 1 do begin
        jo := ja.Items[i] as TJSONObject;
        pomString := jo.GetValue<String>('Q');
        if pomString.Contains(SIGN_FINISHED) then
          lbxQuests.Items.Add(jo.GetValue<String>('Q'));
      end;
    end;
    3: begin
      cbxShowActive.Checked := True;
      for i := 0 to ja.Count - 1 do begin
        jo := ja.Items[i] as TJSONObject;
        pomString := jo.GetValue<String>('Q');
        if NOT pomString.Contains(SIGN_FINISHED) then
          lbxQuests.Items.Add(jo.GetValue<String>('Q'));
      end;
    end;
  end;
  cbxShowAll.OnClick := cbxShowAllClick;
  cbxShowFinished.OnClick := cbxShowFinishedClick;
  cbxShowActive.OnClick := cbxShowActiveClick;
  checkFilter(iFilter);
end;

procedure TfrmMain.lbxQuestsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = TMouseButton.mbRight then
    if lbxQuests.Focused then begin
      if isFinished(lbxQuests.Items[lbxQuests.ItemIndex]) then
        btnFinish.Caption := 'Unfinish'
      else
        btnFinish.Caption := 'Finish';
      PopupMenu1.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    end;
end;

function TfrmMain.isFinished(text: String): Boolean;
begin
  if text.Contains(SIGN_FINISHED) then result := True
  else result := False;
end;

procedure TfrmMain.btnFinishClick(Sender: TObject);
var
  s: String;
begin
  if isFinished(lbxQuests.Items[lbxQuests.ItemIndex]) then begin
    s := lbxQuests.Items[lbxQuests.ItemIndex];
    SetLength(s, lbxQuests.Items[lbxQuests.ItemIndex].Length - 13);
    lbxQuests.Items[lbxQuests.ItemIndex] := s;
  end
  else
    lbxQuests.Items[lbxQuests.ItemIndex] := lbxQuests.Items[lbxQuests.ItemIndex] + SIGN_FINISHED;

  tempSave;
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
begin
  lbxQuests.Items.Delete(lbxQuests.ItemIndex);
  tempSave;
end;


end.
