unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, ExtCtrls, StdCtrls, ComCtrls, DBCtrls, Menus;

type
  TForm4 = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    UpDown1: TUpDown;
    Edit1: TEdit;
    Button4: TButton;
    DBLookupComboBox1: TDBLookupComboBox;
    Button5: TButton;
    Label2: TLabel;
    DBGrid2: TDBGrid;
    Label3: TLabel;
    Label4: TLabel;
    DateTimePicker1: TDateTimePicker;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Edit2: TEdit;
    Label5: TLabel;
    Button6: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  ch_number: string;
  vartist, ch_sum: double;
implementation

uses Unit2, Unit1, DB, Unit3, Unit5, Unit6, Unit7;

{$R *.dfm}

procedure TForm4.FormShow(Sender: TObject);
begin
  DateTimePicker1.Date:= Now;

  DataModule2.ADOQTovari.Close;
  DataModule2.ADOQTovari.SQL.Text:= 'SELECT ���������.���_���������, ���������.�����, ���������.ֳ��, ��������.�����_��������, [ATC �����].�����_�����'
  +' FROM ���������, ��������, [ATC �����] WHERE ([ATC �����].���_����� = ���������.���_����� AND ��������.���_�������� = ���������.���_��������)';
  DataModule2.ADOQTovari.Open;

end;

procedure TForm4.Button4Click(Sender: TObject);
begin
  if DBLookupComboBox1.KeyValue = null then
    ShowMessage('������ ���������� ���')
  else
  begin
  DBLookupComboBox1.Enabled:= false;
  Panel1.Visible:= true;
  Button4.Enabled:= false;

  end;
end;

procedure TForm4.Button1Click(Sender: TObject);
begin

  DBGrid2.Visible:= true;
  Button2.Enabled:= true;
  Button3.Enabled:= true;
  Button5.Enabled:= true;
  Button6.Enabled:= true;

  DataModule2.ADOQWork.Close;
  DataModule2.ADOQWork.SQL.Text:= 'INSERT INTO ��� ([����], [����]) Values (:dt, 0)';
  DataModule2.ADOQWork.Parameters.ParamByName('dt').Value:=FormatDateTime('dd.mm.yyyy', DateTimePicker1.Date);
  DataModule2.ADOQWork.ExecSQL;

  DataModule2.ADOQWork.Close;
  DataModule2.ADOQWork.SQL.Text:= 'SELECT * FROM ��� ';
  DataModule2.ADOQWork.Open;

  DataModule2.ADOQWork.Last;
  ch_number:= DataModule2.ADOQWork.Fields[0].AsString;
  Label2.Caption:='��� �'+ ch_number;

    DataModule2.ADOQSales.Close;
    DataModule2.ADOQSales.SQL.Text:= 'SELECT ������.���_������, ���������.�����, ���������.ֳ��, ������.ʳ������, ������.�������, �����������.ϲ�, ������.���_����'
    +' FROM ��������� INNER JOIN (����������� INNER JOIN ������ ON �����������.[���_�����������] = ������.[���_�����������]) ON ���������.[���_���������] = ������.[���_���������] WHERE (������.���_���� = '+ch_number+')';
    DataModule2.ADOQSales.Open;

  FormShow(Sender);
  Button1.Enabled:= false;

end;



procedure TForm4.Button5Click(Sender: TObject);
begin
   vartist:= DBGrid1.Fields[2].AsFloat * StrToFloat(Edit1.Text);
   
   DataModule2.ADOQWork.Close;
   DataModule2.ADOQWork.SQL.Text:='INSERT INTO ������ ([���_�����������], [���_���������], [ʳ������], [�������], [���_����]) '
   + ' values ('+IntToStr(DBLookupComboBox1.KeyValue)+','+DBGrid1.Fields[0].AsString+','+Edit1.text+',"'+FloatToStr(vartist)+'", '+ch_number+') ';
   DataModule2.ADOQWork.ExecSQL;

    DataModule2.ADOQSales.Close;
    DataModule2.ADOQSales.SQL.Text:= 'SELECT ������.���_������, ���������.�����, ���������.ֳ��, ������.ʳ������, ������.�������, �����������.ϲ�, ������.���_����'
    +' FROM ��������� INNER JOIN (����������� INNER JOIN ������ ON �����������.[���_�����������] = ������.[���_�����������]) ON ���������.[���_���������] = ������.[���_���������] WHERE (������.���_���� = '+ch_number+')';
    DataModule2.ADOQSales.Open;

    ch_sum:= ch_sum + vartist;
    Label5.Caption:= '���� ����: ' + FloatToStr(ch_sum);

    DataModule2.ADOQWork.Close;
    DataModule2.ADOQWork.SQL.Text:= 'UPDATE ��� SET ���.���� = "'+FloatToStr(ch_sum)+'" WHERE ((���.���_����) = '+ch_number+')';
    DataModule2.ADOQWork.ExecSQL;
end;

procedure TForm4.N1Click(Sender: TObject);
begin
  Form1.Show();
end;

procedure TForm4.Edit2Change(Sender: TObject);
begin
  DataModule2.ADOQTovari.Close;
  DataModule2.ADOQTovari.SQL.Text:='SELECT ���������.���_���������, ���������.�����, ���������.ֳ��, ��������.�����_��������, [ATC �����].�����_����� '
  + ' FROM [ATC �����] INNER JOIN ��������� ON [ATC �����].���_����� = ���������.���_�����, �������� WHERE(���������.����� LIKE "%'+Edit2.Text+'%" AND ��������.���_�������� = ���������.���_��������)';;
  DataModule2.ADOQTovari.Open;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  Label2.Caption:= '��� �';
  Label5.Caption:= '���� ����:';
  Button1.Enabled:= true;
  Button2.Enabled:= false;
  Button3.Enabled:= false;
  Button5.Enabled:= false;
  Button6.Enabled:= false;
  DBGrid2.Visible:= false;


end;

procedure TForm4.Button6Click(Sender: TObject);
begin
    DataModule2.ADOQWork.Close;
    DataModule2.ADOQWork.SQL.Text:= 'DELETE * FROM ������ WHERE (������.���_������ = '+DBGrid2.Fields[0].AsString+')';
    Datamodule2.ADOQWork.ExecSQL;

    DataModule2.ADOQSales.Close;
    DataModule2.ADOQSales.SQL.Text:= 'SELECT ������.���_������, ���������.�����, ���������.ֳ��, ������.ʳ������, ������.�������, �����������.ϲ�, ������.���_����'
    +' FROM ��������� INNER JOIN (����������� INNER JOIN ������ ON �����������.[���_�����������] = ������.[���_�����������]) ON ���������.[���_���������] = ������.[���_���������] WHERE (������.���_���� = '+ch_number+')';
    DataModule2.ADOQSales.Open;

    ch_sum:= ch_sum - vartist;
    Label5.Caption:= '���� ����: ' + FloatToStr(ch_sum);

    DataModule2.ADOQWork.Close;
    DataModule2.ADOQWork.SQL.Text:= 'UPDATE ��� SET ���.���� = "'+FloatToStr(ch_sum)+'" WHERE ((���.���_����) = '+ch_number+')';
    DataModule2.ADOQWork.ExecSQL;
end;






procedure TForm4.N2Click(Sender: TObject);
begin
  Label2.Caption:= '��� �';
  Label5.Caption:= '���� ����:';
  Panel1.Visible:=False;
  DBGrid2.Visible:=false;
  Button4.Enabled:= true;
  DBLookupComboBox1.Enabled:= true;
end;

procedure TForm4.Button3Click(Sender: TObject);
begin
  DataModule2.ADOQCheck_Rep.Close;
  DataModule2.ADOQCheck_Rep.SQL.Text:= 'SELECT ���.���_����, ���.����, ���������.�����, ���������.ֳ��, ������.ʳ������, ������.�������, ���.����'
  + ' FROM ��������� INNER JOIN (��� INNER JOIN ������ ON ���.[���_����] = ������.[���_����]) ON ���������.[���_���������] = ������.[���_���������] WHERE(������.���_���� = '+ch_number+')';
  DataModule2.ADOQCheck_Rep.Open;

  Form6.QRLabel1.Caption:= '��� � ' + ch_number;
  Form6.QRLabel2.Caption:= '����:' + DateToStr(DateTimePicker1.Date);
  Form6.QRLabel3.Caption:= '���������:' + DBLookupComboBox1.Text;
  Form6.QRLabel10.Caption:= '���� �� ����, ���:' + FloatToStr(ch_sum);

  Form6.QuickRep1.PreviewModal;



end;

procedure TForm4.N3Click(Sender: TObject);
begin
  Form7.Show();
end;

end.
