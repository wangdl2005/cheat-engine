unit Changeoffsetunit;

{$MODE Delphi}

interface

uses
  LCLIntf, Messages, SysUtils, classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, LResources,symbolhandler;

type
  TChangeOffset = class(TForm)
    TabControl1: TTabControl;
    Change: TButton;
    Button2: TButton;
    cbHexadecimal: TCheckBox;
    Edit1: TEdit;
    procedure ChangeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure TabControl1Change(Sender: TObject);
    procedure cbHexadecimalClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    offset: Integer;
    FromAddress: ptrUint;
    toAddress: ptrUint;
    error: integer;
  end;

var
  ChangeOffset: TChangeOffset;

implementation

resourcestring
  rsThisIsNotAnValidValue = 'This is not an valid value';


procedure TChangeOffset.ChangeClick(Sender: TObject);
var temp: ptruint;
  s: string;
begin
  if tabcontrol1.TabIndex=0 then
  begin
    if cbHexadecimal.checked then
    begin
      s:=trim(edit1.text);

      if length(s)>1 then
      begin
        if s[1]='-' then
        begin
          val('-$'+copy(s,2,length(s)),offset,error);
        end
        else
          val('$'+s,offset,error);
      end
      else
        val('$'+s,offset,error);


    end
    else
      val(edit1.Text,offset,error);
  end
  else
  begin
    try
      temp:=symhandler.getAddressFromName(edit1.text);
      offset:=temp-fromaddress;
    except
      error:=1;
    end;
  end;
end;

procedure TChangeOffset.FormShow(Sender: TObject);
begin
  if tabcontrol1.TabIndex=0 then
  begin
    if cbHexadecimal.Checked then edit1.Text:=IntToHex(toaddress-fromaddress,8) else
                              edit1.Text:=IntToStr(integer(toaddress-fromaddress));
  end
  else
  begin
    edit1.Text:=IntToHex(toaddress,8);
  end;
end;

procedure TChangeOffset.TabControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
var controle: integer;
begin
  if tabcontrol1.TabIndex=0 then
  begin
    if cbHexadecimal.checked then val('$'+edit1.Text,offset,controle) else
                              val(edit1.text,offset,controle);
  end else
  begin
    val('$'+edit1.text,toaddress,controle);
  end;

  if controle=0 then allowchange:=true else
  begin
    allowchange:=false;
    raise exception.Create(rsThisIsNotAnValidValue);
  end;

end;

procedure TChangeOffset.TabControl1Change(Sender: TObject);
begin
  if tabcontrol1.TabIndex=0 then
  begin
    cbHexadecimal.Visible:=true;
    if cbHexadecimal.Checked then edit1.Text:=IntToHex(toaddress-fromaddress,8) else
                              edit1.Text:=IntToStr(integer(toaddress-fromaddress));
  end
  else
  begin
    cbHexadecimal.visible:=false;
    edit1.Text:=IntToHex(toaddress,8);
  end;
end;

procedure TChangeOffset.cbHexadecimalClick(Sender: TObject);
begin
  if tabcontrol1.TabIndex=0 then
  begin
    if cbHexadecimal.Checked then edit1.Text:=IntToHex(toaddress-fromaddress,8) else
                              edit1.Text:=IntToStr(integer(toaddress-fromaddress));
  end;
end;                        

initialization
  {$i Changeoffsetunit.lrs}

end.
