unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, ComCtrls, StdCtrls, ExtCtrls, DBCtrls, DB;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet6: TTabSheet;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    Edit3: TEdit;
    Edit4: TEdit;
    Label6: TLabel;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button13: TButton;
    Button12: TButton;
    Button14: TButton;
    Button15: TButton;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    DBGrid5: TDBGrid;
    DBGrid6: TDBGrid;
    Edit5: TEdit;
    Label7: TLabel;
    DateTimePicker1: TDateTimePicker;
    Button16: TButton;
    Button17: TButton;
    Label8: TLabel;
    Edit6: TEdit;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2, Unit3, Unit4, Unit5;

{$R *.dfm}






procedure TForm1.FormShow(Sender: TObject);
begin
  DataModule2.ADOQTovari.Close;
  DataModule2.ADOQTovari.SQL.Text:= 'SELECT Препарати.Код_препарату, Препарати.Назва, Препарати.Ціна, Упаковки.назва_упаковки, [ATC класи].Назва_класу'
  +' FROM Препарати, Упаковки, [ATC класи] WHERE ([ATC класи].Код_класу = Препарати.код_класу AND Упаковки.Код_упаковки = Препарати.код_упаковки)';
  DataModule2.ADOQTovari.Open;

  DataModule2.ADOQSales.Close;
  DataModule2.ADOQSales.SQL.Text:= 'SELECT Продажі.Код_продажі, Продажі.Кількість, Препарати.Ціна, Продажі.Вартість, Препарати.Назва, Співробітники.ПІБ, Чек.Код_чека'
  + ' FROM Препарати INNER JOIN (Чек INNER JOIN (Співробітники INNER JOIN Продажі ON Співробітники.[Код_співробітника] = Продажі.[код_співробітника]) ON Чек.[Код_чека] = Продажі.[код_чека]) ON Препарати.[Код_препарату] = Продажі.[код_препарату];';
  DataModule2.ADOQSales.Open;

  DataModule2.ADOQCheck.Close;
  DataModule2.ADOQCheck.SQL.Text:= 'SELECT Чек.Код_чека, Чек.Дата, Чек.Сума FROM Чек';
  DataModule2.ADOQCheck.Open;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Edit1.Text:= '';
  DBLookupComboBox1.KeyValue := 1;
  DBLookupComboBox2.KeyValue := 1;
  Edit2.Text:= '0';

  Button5.Visible:= true;
  Button6.Visible:= false;
  Panel2.Visible := true;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Edit1.Text:= DBGrid4.Fields[1].AsString;
  DBLookupComboBox1.KeyValue:= 1;
  DBLookupComboBox2.KeyValue:= 1;
  Edit2.Text:= DBGrid4.Fields[2].AsString;

  DataModule2.ADOATC.Locate('Назва_класу', DBGrid4.Fields[4].AsString,[loCaseInsensitive,loPartialKey]);
  DBLookupComboBox1.KeyValue:= StrToInt(DataModule2.DataSATC.DataSet.Fields[0].AsString);
  DataModule2.ADOPackage.Locate('назва_упаковки', DBGrid4.Fields[4].AsString,[loCaseInsensitive,loPartialKey]);
  DBLookupComboBox2.KeyValue:= StrToInt(DataModule2.DataSATC.DataSet.Fields[0].AsString);

  Button5.Visible:= false;
  Button6.Visible:= true;
  Panel2.Visible:= true;

end;


procedure TForm1.Button5Click(Sender: TObject);
begin
  DataModule2.ADOQTovari.Close;
  DataModule2.ADOQTovari.SQL.Text:= 'INSERT INTO Препарати ( [Назва], [Ціна], [код_класу], [код_упаковки])'
  + ' values ("'+Edit1.Text+'", '+Edit2.Text+', '+IntToStr(DBLookupComboBox1.KeyValue)+', '+IntToStr(DBLookupComboBox2.KeyValue)+')';
  DataModule2.ADOQTovari.ExecSQL;

  FormShow(Sender);

  Panel2.Visible:= false;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin

  DataModule2.ADOQWork.Close;
  DataModule2.ADOQWork.SQL.Text:= 'DELETE Препарати.Назва, Препарати.Ціна , Препарати.код_класу , Препарати.код_упаковки '
  + ' WHERE (Препарати.Код_препарату = '+DBGrid4.Fields[0].AsString+')';
  DataModule2.ADOQWork.SQL.Text:= 'UPDATE Препарати SET Препарати.Назва = "'+Edit1.Text+'", Препарати.Ціна = '+Edit2.Text+', Препарати.код_класу = '+IntToStr(DBLookupComboBox1.KeyValue)+', Препарати.код_упаковки = '+IntToStr(DBLookupComboBox2.KeyValue)+' '
  + ' WHERE (Препарати.Код_препарату = '+DBGrid4.Fields[0].AsString+')';
  DataModule2.ADOQWork.ExecSQL;

  FormShow(Sender);
  Panel2.Visible:= false;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  DataModule2.ADOQWork.Close;
  DataModule2.ADOQWork.SQL.Text:= 'DELETE * FROM Препарати WHERE(((Препарати.Код_препарату) = '+DBGrid4.Fields[0].AsString+'))';
  DataModule2.ADOQWork.ExecSQL;

  FormShow(Sender);

  Panel2.Visible:= false;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  if Edit4.Text='' then
  begin
   FormShow(Sender);
  end
  else
  begin
  DataModule2.ADOQTovari.Close;
  DataModule2.ADOQTovari.SQL.Text:= 'SELECT Препарати.Код_препарату, Препарати.Назва, Препарати.Ціна, Упаковки.назва_упаковки, [ATC класи].Назва_класу'
  + ' FROM [ATC класи] INNER JOIN Препарати ON [ATC класи].Код_класу = Препарати.код_класу, Упаковки WHERE(Препарати.Код_препарату = '+Edit4.Text+' AND Упаковки.Код_упаковки = Препарати.Код_упаковки )';
  DataModule2.ADOQTovari.Open;
  end;
end;


procedure TForm1.Edit3Change(Sender: TObject);
begin
  DataModule2.ADOQTovari.Close;
  DataModule2.ADOQTovari.SQL.Text:= 'SELECT Препарати.Код_препарату, Препарати.Назва, Препарати.Ціна, Упаковки.назва_упаковки, [ATC класи].Назва_класу '
  + ' FROM [ATC класи] INNER JOIN Препарати ON [ATC класи].Код_класу = Препарати.код_класу, Упаковки WHERE(Препарати.Назва LIKE "%'+Edit3.Text+'%" AND Упаковки.Код_упаковки = Препарати.Код_упаковки)';
  DataModule2.ADOQTovari.Open;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
 Panel2.Visible:= false;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  DataModule2.ADOEmployees.Insert;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
if DataModule2.ADOEmployees.Modified then
   DataModule2.ADOEmployees.Post;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
 DataModule2.ADOEmployees.Delete;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  DataModule2.ADOPackage.Insert;
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  if DataModule2.ADOPackage.Modified then
     DataModule2.ADOPackage.Post;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
  DataModule2.ADOPackage.Delete;
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
  Form3.Show;
end;



procedure TForm1.Button4Click(Sender: TObject);
begin
  Form5.QuickRep1.PreviewModal;
end;




procedure TForm1.Button16Click(Sender: TObject);
begin
  DataModule2.ADOQCheck.Close;
  DataModule2.ADOQCheck.SQL.Text:= 'SELECT Чек.Код_чека, Чек.Дата, Чек.Сума FROM Чек'
  + ' WHERE(Чек.Дата = dt)';
  DataModule2.ADOQCheck.Parameters.ParamByName('dt').Value:=FormatDateTime('dd.mm.yyyy', DateTimePicker1.Date);
  DataModule2.ADOQCheck.Open;
end;

procedure TForm1.Edit5Change(Sender: TObject);
begin
  DataModule2.ADOQCheck.Close;
  DataModule2.ADOQCheck.SQL.Text:= 'SELECT Чек.Код_чека, Чек.Дата, Чек.Сума FROM Чек'
  + ' WHERE(Чек.Код_чека LIKE "%'+Edit5.Text+'%")';
  DataModule2.ADOQCheck.Open;
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
  FormShow(Sender);
end;

procedure TForm1.Edit6Change(Sender: TObject);
begin
  DataModule2.ADOQSales.Close;
  DataModule2.ADOQSales.SQL.Text:= 'SELECT Продажі.Код_продажі, Продажі.Кількість, Препарати.Ціна, Продажі.Вартість, Препарати.Назва, Співробітники.ПІБ, Чек.Код_чека'
  + ' FROM Препарати INNER JOIN (Чек INNER JOIN (Співробітники INNER JOIN Продажі ON Співробітники.[Код_співробітника] = Продажі.[код_співробітника]) ON Чек.[Код_чека] = Продажі.[код_чека]) ON Препарати.[Код_препарату] = Продажі.[код_препарату]'
  + ' WHERE(Чек.Код_чека LIKE "%'+Edit6.Text+'%")';
  DataModule2.ADOQSales.Open;
end;

end.
