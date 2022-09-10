unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  Vcl.StdCtrls, frxClass, frxExportBaseDialog, frxExportPDF, frxDesgn, frxDBSet,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, BrookHandledClasses,
  BrookHTTPServer, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,BrookHTTPRequest,
  BrookHTTPResponse;

type
  TFMain = class(TForm)
    FBServer: TBrookHTTPServer;
    FDCon: TFDConnection;
    Q: TFDQuery;
    Ds: TDataSource;
    R: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    frxDesigner1: TfrxDesigner;
    pdfexport: TfrxPDFExport;
    Button1: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FBServerRequest(ASender: TObject; ARequest: TBrookHTTPRequest;
      AResponse: TBrookHTTPResponse);
  private
    { Private declarations }
  public
    { Public declarations }
    AFile : String;
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}

procedure TFMain.Button1Click(Sender: TObject);
begin
FBServer.Port := strtointdef(edit1.Text,0);
FBServer.Open;
FDcon.Connected := true;
Q.SQL.Text := 'select * from dokter limit 6';
Q.open;

R.DesignReport;

end;

procedure TFMain.FBServerRequest(ASender: TObject; ARequest: TBrookHTTPRequest;
  AResponse: TBrookHTTPResponse);
  var bit : TBytesStream;
begin
  //Define how the request and response is handled
  bit :=  TBytesStream.Create;
  R.LoadFromFile(getcurrentdir+'/Report/doctor.fr3');
  R.PrepareReport(true);
  pdfexport.FileName := getcurrentdir+'/Report/doctor.pdf';
  R.Export(pdfexport);
  AFile := getcurrentdir+'/Report/doctor.pdf';
  bit.LoadFromFile(AFile);
  AResponse.SendBytes(bit.Bytes,bit.Size,'',200);
end;

end.
