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
  DataModule2.ADOQTovari.SQL.Text:= 'SELECT Препарати.Код_препарату, Препарати.Назва, Препарати.Ціна, Упаковки.назва_упаковки, [ATC класи].Назва_класу'
  +' FROM Препарати, Упаковки, [ATC класи] WHERE ([ATC класи].Код_класу = Препарати.код_класу AND Упаковки.Код_упаковки = Препарати.код_упаковки)';
  DataModule2.ADOQTovari.Open;

end;

procedure TForm4.Button4Click(Sender: TObject);
begin
  if DBLookupComboBox1.KeyValue = null then
    ShowMessage('Введіть персональні дані')
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
  DataModule2.ADOQWork.SQL.Text:= 'INSERT INTO Чек ([Дата], [Сума]) Values (:dt, 0)';
  DataModule2.ADOQWork.Parameters.ParamByName('dt').Value:=FormatDateTime('dd.mm.yyyy', DateTimePicker1.Date);
  DataModule2.ADOQWork.ExecSQL;

  DataModule2.ADOQWork.Close;
  DataModule2.ADOQWork.SQL.Text:= 'SELECT * FROM Чек ';
  DataModule2.ADOQWork.Open;

  DataModule2.ADOQWork.Last;
  ch_number:= DataModule2.ADOQWork.Fields[0].AsString;
  Label2.Caption:='Чек №'+ ch_number;

    DataModule2.ADOQSales.Close;
    DataModule2.ADOQSales.SQL.Text:= 'SELECT Продажі.Код_продажі, Препарати.Назва, Препарати.Ціна, Продажі.Кількість, Продажі.Вартість, Співробітники.ПІБ, Продажі.код_чека'
    +' FROM Препарати INNER JOIN (Співробітники INNER JOIN Продажі ON Співробітники.[Код_співробітника] = Продажі.[код_співробітника]) ON Препарати.[Код_препарату] = Продажі.[код_препарату] WHERE (Продажі.код_чека = '+ch_number+')';
    DataModule2.ADOQSales.Open;

  FormShow(Sender);
  Button1.Enabled:= false;

end;



procedure TForm4.Button5Click(Sender: TObject);
begin
   vartist:= DBGrid1.Fields[2].AsFloat * StrToFloat(Edit1.Text);
   
   DataModule2.ADOQWork.Close;
   DataModule2.ADOQWork.SQL.Text:='INSERT INTO Продажі ([код_співробітника], [код_препарату], [Кількість], [Вартість], [код_чека]) '
   + ' values ('+IntToStr(DBLookupComboBox1.KeyValue)+','+DBGrid1.Fields[0].AsString+','+Edit1.text+',"'+FloatToStr(vartist)+'", '+ch_number+') ';
   DataModule2.ADOQWork.ExecSQL;

    DataModule2.ADOQSales.Close;
    DataModule2.ADOQSales.SQL.Text:= 'SELECT Продажі.Код_продажі, Препарати.Назва, Препарати.Ціна, Продажі.Кількість, Продажі.Вартість, Співробітники.ПІБ, Продажі.код_чека'
    +' FROM Препарати INNER JOIN (Співробітники INNER JOIN Продажі ON Співробітники.[Код_співробітника] = Продажі.[код_співробітника]) ON Препарати.[Код_препарату] = Продажі.[код_препарату] WHERE (Продажі.код_чека = '+ch_number+')';
    DataModule2.ADOQSales.Open;

    ch_sum:= ch_sum + vartist;
    Label5.Caption:= 'Сума чеку: ' + FloatToStr(ch_sum);

    DataModule2.ADOQWork.Close;
    DataModule2.ADOQWork.SQL.Text:= 'UPDATE Чек SET Чек.Сума = "'+FloatToStr(ch_sum)+'" WHERE ((Чек.Код_чека) = '+ch_number+')';
    DataModule2.ADOQWork.ExecSQL;
end;

procedure TForm4.N1Click(Sender: TObject);
begin
  Form1.Show();
end;

procedure TForm4.Edit2Change(Sender: TObject);
begin
  DataModule2.ADOQTovari.Close;
  DataModule2.ADOQTovari.SQL.Text:='SELECT Препарати.Код_препарату, Препарати.Назва, Препарати.Ціна, Упаковки.назва_упаковки, [ATC класи].Назва_класу '
  + ' FROM [ATC класи] INNER JOIN Препарати ON [ATC класи].Код_класу = Препарати.код_класу, Упаковки WHERE(Препарати.Назва LIKE "%'+Edit2.Text+'%" AND Упаковки.Код_упаковки = Препарати.Код_упаковки)';;
  DataModule2.ADOQTovari.Open;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  Label2.Caption:= 'Чек №';
  Label5.Caption:= 'Сума чеку:';
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
    DataModule2.ADOQWork.SQL.Text:= 'DELETE * FROM Продажі WHERE (Продажі.Код_продажі = '+DBGrid2.Fields[0].AsString+')';
    Datamodule2.ADOQWork.ExecSQL;

    DataModule2.ADOQSales.Close;
    DataModule2.ADOQSales.SQL.Text:= 'SELECT Продажі.Код_продажі, Препарати.Назва, Препарати.Ціна, Продажі.Кількість, Продажі.Вартість, Співробітники.ПІБ, Продажі.код_чека'
    +' FROM Препарати INNER JOIN (Співробітники INNER JOIN Продажі ON Співробітники.[Код_співробітника] = Продажі.[код_співробітника]) ON Препарати.[Код_препарату] = Продажі.[код_препарату] WHERE (Продажі.код_чека = '+ch_number+')';
    DataModule2.ADOQSales.Open;

    ch_sum:= ch_sum - vartist;
    Label5.Caption:= 'Сума чеку: ' + FloatToStr(ch_sum);

    DataModule2.ADOQWork.Close;
    DataModule2.ADOQWork.SQL.Text:= 'UPDATE Чек SET Чек.Сума = "'+FloatToStr(ch_sum)+'" WHERE ((Чек.Код_чека) = '+ch_number+')';
    DataModule2.ADOQWork.ExecSQL;
end;






procedure TForm4.N2Click(Sender: TObject);
begin
  Label2.Caption:= 'Чек №';
  Label5.Caption:= 'Сума чеку:';
  Panel1.Visible:=False;
  DBGrid2.Visible:=false;
  Button4.Enabled:= true;
  DBLookupComboBox1.Enabled:= true;
end;

procedure TForm4.Button3Click(Sender: TObject);
begin
  DataModule2.ADOQCheck_Rep.Close;
  DataModule2.ADOQCheck_Rep.SQL.Text:= 'SELECT Чек.Код_чека, Чек.Дата, Препарати.Назва, Препарати.Ціна, Продажі.Кількість, Продажі.Вартість, Чек.Сума'
  + ' FROM Препарати INNER JOIN (Чек INNER JOIN Продажі ON Чек.[Код_чека] = Продажі.[код_чека]) ON Препарати.[Код_препарату] = Продажі.[код_препарату] WHERE(Продажі.код_чека = '+ch_number+')';
  DataModule2.ADOQCheck_Rep.Open;

  Form6.QRLabel1.Caption:= 'Чек № ' + ch_number;
  Form6.QRLabel2.Caption:= 'Дата:' + DateToStr(DateTimePicker1.Date);
  Form6.QRLabel3.Caption:= 'Продавець:' + DBLookupComboBox1.Text;
  Form6.QRLabel10.Caption:= 'Сума по чеку, грн:' + FloatToStr(ch_sum);

  Form6.QuickRep1.PreviewModal;



end;

procedure TForm4.N3Click(Sender: TObject);
begin
  Form7.Show();
end;

end.
