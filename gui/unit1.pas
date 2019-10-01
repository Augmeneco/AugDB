unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls, ActnList, IdTCPClient, IdIOHandlerStack, IdHTTP, AnchorDockPanel,
  SynHighlighterPython, SynEdit, base64;

type
  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    IdIOHandlerStack1: TIdIOHandlerStack;
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
  tmp: variant;
  out: string;
  i: integer;
  stream: TStringStream;

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
  SynEdit1.Text := '';
end;

procedure TForm1.SynEdit1Change(Sender: TObject);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Text := '';
  StringGrid1.Clean;
  StringGrid1.ColCount:=1000;
  StringGrid1.RowCount:=1000;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  IdTCPClient1.Port:=6089;
  IdTCPClient1.Host:='127.0.0.1';
  IdTCPClient1.Connect;

  IdTCPClient1.Socket.Write(EncodeStringBase64(SynEdit1.Text));
  out := '';
  while true do begin
    tmp := IdTCPClient1.Socket.ReadLn;
    if pos('end',tmp) > 0 then break;
    out := out+tmp;
  end;
  out := DecodeStringBase64(out);
  Memo1.Lines.Append(out);

  IdTCPClient1.Disconnect;

  if pos('<?xml version="1.0" encoding="UTF-8"?>',out) > 0 then begin
    stream := TStringStream.Create(out);
    StringGrid1.LoadFromStream(stream);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  StringGrid1.LoadFromFile('db2');
end;

end.

