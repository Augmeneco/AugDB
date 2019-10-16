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
    add_col: TButton;
    new_table_make_bt: TButton;
    new_table_close_bt: TButton;
    delete_last: TButton;
    add_table: TButton;
    delete_table: TButton;
    Label3: TLabel;
    new_table_rows_count: TEdit;
    new_table_name: TEdit;
    new_table_cols_name: TEdit;
    edit_col_name: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    table_create_opt: TPanel;
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
    procedure add_tableClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure add_colClick(Sender: TObject);
    procedure delete_lastClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure menu_saveClick(Sender: TObject);
    procedure new_table_close_btClick(Sender: TObject);
    procedure new_table_make_btClick(Sender: TObject);
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
  filename: TFileStream;
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
    for col:=1 to Form1.StringGrid1.ColCount-1 do
    begin
      json3 := TJSONArray.Create;
      for row:=1 to Form1.StringGrid1.RowCount-1 do
      begin
        json3.Add(Form1.StringGrid1.Cells[col,row]);
      end;
      json2.Add(Form1.StringGrid1.Cells[col,0],json3);
    end;
    json1.Objects[gridsnames[bd_id]] := json2;
  end;
  filename := TFileStream.Create(Form1.SaveDialog1.FileName,fmOpenWrite or fmCreate);
  filename.Write(json1.FormatJSON[1],Length(json1.AsString));
  filename.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  select_table.Items.Add('таблица'+inttostr(select_table.Items.Count));
end;

procedure TForm1.add_tableClick(Sender: TObject);
begin
  table_create_opt.Show;

end;

procedure TForm1.add_colClick(Sender: TObject);
begin
  StringGrid1.ColCount:=StringGrid1.ColCount+1;
  StringGrid1.Cells[StringGrid1.ColCount-1,0] := edit_col_name.Caption;
end;

procedure TForm1.delete_lastClick(Sender: TObject);
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
  gridsnames[0] := 'таблица1';
  select_table.Items.Add('таблица1');
  select_table.ItemIndex:=0;
  table_create_opt.Width:=210;
  table_create_opt.Height:=192;
  table_create_opt.Left:=0;
  table_create_opt.Top:=96;
  table_create_opt.Hide;
end;

procedure TForm1.menu_saveClick(Sender: TObject);
begin
  savebd();
end;

procedure TForm1.new_table_close_btClick(Sender: TObject);
begin
  table_create_opt.Hide;
end;

procedure TForm1.new_table_make_btClick(Sender: TObject);
var
  colname: string;
  i: integer;
begin
  SetLength(gridsnames,Length(gridsnames)+1);
  gridsnames[Length(gridsnames)] := new_table_name.Text;
  select_table.Items.Add(new_table_name.Text);
  select_table.ItemIndex:=select_table.Items.Count-1;
  colname := new_table_cols_name.Text.split([',']);
  for i:=1 to Length(colname) do
  begin
    StringGrid1.Cells[i,0] := colname[i+1];
  end;
  table_create_opt.Hide;
end;

procedure TForm1.select_tableChange(Sender: TObject);
begin
  ShowMessage(inttostr(select_table.ItemIndex));
end;

end.

