unit Unit2;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TDataModule2 = class(TDataModule)
    ADOConnection1: TADOConnection;
    ADOATC: TADOTable;
    DataSATC: TDataSource;
    DataSPackage: TDataSource;
    ADOPackage: TADOTable;
    DataSEmployees: TDataSource;
    ADOEmployees: TADOTable;
    ADOQTovari: TADOQuery;
    DataSTovari: TDataSource;
    ADOQWork: TADOQuery;
    DataSWork: TDataSource;
    ADOQCheck: TADOQuery;
    DataSCheck: TDataSource;
    DataSSales: TDataSource;
    ADOQSales: TADOQuery;
    ADOTov_Rep: TADOTable;
    DataSTov_Rep: TDataSource;
    ADOQCheck_Rep: TADOQuery;
    DataSCheck_Rep: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule2: TDataModule2;

implementation

{$R *.dfm}




end.
