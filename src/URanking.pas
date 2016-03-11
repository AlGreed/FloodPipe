{------------------------------------------------------------------------------
   Diese Unit dient der Motorik auf dem Formular fuer Ranglisten.
   Die eigentliche Datenhaltung erfolgt in einer seperaten Unit.

   Autor: Oleksandr Nosenko, 13.01.13
 ------------------------------------------------------------------------------}

unit URanking;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, URankingData;

type
  TForm3 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox3: TGroupBox;
    ListView1: TListView;
    ListView2: TListView;
    ListView3: TListView;
    ListView4: TListView;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    {Trägt die Daten in Spalten hinein}
    procedure fillList(Score : TScore; List : TListView);
  public
    { Public declarations }
  end;

var
  Ranking: TForm3;

  ListViewArray : Array[0..3] of TListView;

implementation

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
var
  i : Integer;
  NewColumn : TListColumn;
  List : TListView;
begin
  ListViewArray[0] := ListView1;
  ListViewArray[1] := ListView2;
  ListViewArray[2] := ListView3;
  ListViewArray[3] := ListView4;

  {Es werden pro Liste 3 Spalten angelegt}
  for i := Low(ListViewArray) to High(ListViewArray) do
  begin
    List := ListViewArray[i];
    with List do
    begin
         List.ReadOnly := true;
         ViewStyle := vsReport;
         NewColumn := List.Columns.Add;
         NewColumn.Caption := 'Name';
         NewColumn.Width := 100;
         NewColumn.MaxWidth := 100;
         NewColumn.MinWidth := 100;
         NewColumn := List.Columns.Add;
         NewColumn.Caption := 'Time';
         NewColumn.Width := 146;
         NewColumn.MaxWidth := 146;
         NewColumn.MinWidth := 146;;
         NewColumn := List.Columns.Add;
         NewColumn.Caption := 'Score';
         NewColumn.Width := 100;
         NewColumn.MaxWidth := 100;
         NewColumn.MinWidth := 100;
    end;
  end;
end;

procedure TForm3.FormShow(Sender: TObject);
var
   x: Integer;
begin
        //Löschen und Neuplatzieren von Ranglisten
        ListView1.Clear;
        ListView2.Clear;
        ListView3.Clear;
        ListView4.Clear;
        for x := Low(TScoreList) to High(TScoreList) do begin
        //mittlere Anzahl von Klicks pro Zelle im einfachen Modus
           fillList(uranking_data_getScore(e_NOToverflow, e_clicks, x), ListView3);
         //mittlere Anzahl von Klicks pro Zelle im ueberlaufmodus
           fillList(uranking_data_getScore(e_overflow, e_clicks, x), ListView1);
         //mittlere Zeit pro Zelle im einfachen Modus
           fillList(uranking_data_getScore(e_NOToverflow, e_time, x), ListView4);
         //mittlere Zeit pro Zelle im ueberlaufmodus
           fillList(uranking_data_getScore(e_overflow, e_time, x), ListView2);
        end;
end;

{Trägt die Daten in Spalten hinein
IN Score          - Ranglisteneintrag
IN List           - Rangliste}
procedure TForm3.fillList(Score : TScore; List : TListView);
var
     Item : TListItem;
begin
     Item := List.Items.Add; //erste Spalte (Name)
     Item.Caption := String(Score.Name);
     if Item.SubItems.Add(String(Score.Time)) = -1 then; //zweite Spalte(Time)
     if Score.Score = 9999999 then begin      //dritte Spalte (Score)
        if Item.SubItems.Add(FloatToStr(0.00)) = -1 then;
     end
     else
        if Item.SubItems.Add(FloatToStr(Score.Score)) = -1 then;
end;

end.


