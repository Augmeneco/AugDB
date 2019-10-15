unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Grids,
  ExtCtrls, StdCtrls, Menus, ActnList, SynCompletion, SynEdit, Types,
  jsonparser, fpjson;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    edit_col_name: TEdit;
    select_table: TComboBox;
    menu_close: TMenuItem;
    menu_load: TMenuItem;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PageControl1: TPageControl;
    bd_main: TTabSheet;
    bd_edit: TTabSheet;
    bd_create: TTabSheet;
    Panel1: TPanel;
    menu_save: TMenuItem;
    SaveDialog1: TSaveDialog;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure menu_saveClick(Sender: TObject);
    procedure select_tableChange(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  basedata: array of array of string;
  gridslist: array of TStringGrid;
  gridsnames: array of string;
  jsonobj: TJSONObject;
  col,row: integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure savebd();
var
  bd_id: integer;
  json1,json2: TJSONObject;
  json3: TJSONArray;
begin
  Form1.SaveDialog1.Title:='Сохранение базы данных';
  Form1.SaveDialog1.InitialDir := GetCurrentDir;
  Form1.SaveDialog1.Filter := 'json|*.json|AugDB|*.augdb|DataBase|*.db';
  Form1.SaveDialog1.DefaultExt := 'augdb';
  Form1.SaveDialog1.FilterIndex := 1;
  if not Form1.SaveDialog1.Execute then Exit;

  json1:= TJSONObject.Create;

  for bd_id:=0 to Form1.select_table.Items.Count-1 do
  begin
    json2 := TJSONObject.Create;
    for col:=1 to gridslist[bd_id].ColCount-1 do
    begin
      json3 := TJSONArray.Create;
      for row:=1 to gridslist[bd_id].RowCount-1 do
      begin
        json3.Add(gridslist[bd_id].Cells[col,row]);
      end;
      json2.Add(gridslist[bd_id].Cells[col,0],json3);
    end;
    json1.Objects[gridsnames[bd_id]] := json2;
  end;
  writeln(json1.FormatJSON);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  select_table.Items.Add('таблица'+inttostr(select_table.Items.Count));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  StringGrid1.ColCount:=StringGrid1.ColCount+1;
  StringGrid1.Cells[StringGrid1.ColCount-1,0] := edit_col_name.Caption;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  StringGrid1.ColCount:=StringGrid1.ColCount-1;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Text:='';
  StringGrid1.ColCount:=1;
  StringGrid1.RowCount:=2;
  SetLength(gridslist,1);
  SetLength(gridsnames,1);
  gridslist[0] := StringGrid1;
  gridsnames[0] := 'таблица1';
  select_table.Items.Add('таблица1');
  select_table.ItemIndex:=0;
end;

procedure TForm1.menu_saveClick(Sender: TObject);
begin
  savebd();
end;

procedure TForm1.select_tableChange(Sender: TObject);
begin
  ShowMessage(inttostr(select_table.ItemIndex));
end;

end.

