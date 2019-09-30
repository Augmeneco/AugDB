unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls, IdTCPClient, AnchorDockPanel, SynHighlighterPython, SynEdit;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    IdTCPClient1: TIdTCPClient;
    Memo1: TMemo;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    StringGrid1: TStringGrid;
    SynEdit1: TSynEdit;
    SynPythonSyn1: TSynPythonSyn;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DrawGrid1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SynEdit1Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  tmp,out: variant;
  i: integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.DrawGrid1Click(Sender: TObject);
begin

end;

procedure TForm1.Edit1Change(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  StringGrid1.ColCount:=1000;
  StringGrid1.RowCount:=1000;
  for i:=1 to StringGrid1.RowCount-1 do
  begin
    StringGrid1.Cells[0,i]:=IntToStr(i);
  end;
  SynEdit1.Text := '';
end;

procedure TForm1.SynEdit1Change(Sender: TObject);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  StringGrid1.Clean;
  StringGrid1.ColCount:=1000;
  StringGrid1.RowCount:=1000;
  for i:=1 to StringGrid1.RowCount-1 do
  begin
    StringGrid1.Cells[0,i]:=IntToStr(i);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  IdTCPClient1.Port:=6089;
  IdTCPClient1.Host:='127.0.0.1';
  IdTCPClient1.Connect;
  IdTCPClient1.Socket.WriteLn(SynEdit1.Text);
  if IdTCPClient1.IOHandler.InputBufferIsEmpty=false then begin
    out := IdTCPClient1.Socket.ReadLn;
    Memo1.Text:=out;
  end;
  IdTCPClient1.Disconnect;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  StringGrid1.LoadFromFile('db2');
end;


end.

