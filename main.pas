unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Grids,
  ExtCtrls, Types;

type

  { TForm1 }

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    bd_main: TTabSheet;
    bd_edit: TTabSheet;
    bd_create: TTabSheet;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    procedure bd_mainContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.bd_mainContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

end.

