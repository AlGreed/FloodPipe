{------------------------------------------------------------------------------
   Diese Unit dient der Verwaltung des Hauptformulars.
   Sie kontrolliert mit Ihren Ereignissen den Spielfluss.

   Autor: Oleksandr Nosenko, 13.01.13
 ------------------------------------------------------------------------------}

unit FloodPipe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.MPlayer,
  Vcl.ImgList, USettings, ULogic, UDraw, Vcl.Grids, UData, TypInfo, UConfig, URankingData,
  Vcl.Buttons;
type
  TForm1 = class(TForm)
    MediaPlayer1: TMediaPlayer;
    MusikTimer: TTimer;
    NewGameButton: TPanel;
    SettingsButton: TPanel;
    StatsButton: TPanel;
    ExitButton: TPanel;
    ImageList1: TImageList;
    DrawGrid1: TDrawGrid;
    Timer2: TTimer;
    Label1: TLabel;
    Panel1: TPanel;
    LoadButton: TPanel;
    SaveButton: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure MusikTimerTimer(Sender: TObject);
    procedure NewGameButtonMouseEnter(Sender: TObject);
    procedure NewGameButtonMouseLeave(Sender: TObject);
    procedure SettingsButtonMouseLeave(Sender: TObject);
    procedure SettingsButtonMouseEnter(Sender: TObject);
    procedure StatsButtonMouseEnter(Sender: TObject);
    procedure StatsButtonMouseLeave(Sender: TObject);
    procedure ExitButtonMouseEnter(Sender: TObject);
    procedure ExitButtonMouseLeave(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure SettingsButtonClick(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DrawGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NewGameButtonClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure StatsButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure LoadButtonMouseLeave(Sender: TObject);
    procedure LoadButtonMouseEnter(Sender: TObject);
    procedure SaveButtonMouseEnter(Sender: TObject);
    procedure SaveButtonMouseLeave(Sender: TObject);
  private
    {Wandelt die Sekunden in '00:00:00' }
    function SecToTime(Sec: Integer): string;
    {Rechnet und setzt neue Bild- und DrawGridgrößen}
    procedure setCoordinates();
    {Berechnet die mittlere Anzahl an Klicks pro Zelle}
    function clicks_pro_cell(clicks : Integer) : Double;
    {Berechnet die mittlere Zeit pro Zelle}
    function time_pro_cell(Time : TTime) : Double;
  public
    { Public declarations }
  end;
const
    DEF_FRM_WIDTH = 1024; //Minimale Spielfensterauflösung
    DEF_FRM_HEIGHT = 768; //Minimale Spielfensterauflösung
    DEF_FIELDSIZE = 120;  //ursprungliche DrawGridFeldGröße
    IMAGE_HEIGHT = 120;   // Bildgröße
    IMAGE_WIDTH = 120;    // Bildgröße

var
  Main: TForm1;
  timeInSec : Integer;    // Zeit, wie lange das Spiel dauert
  clicks : Integer;       // Anzahl von clicks, die während des Spiel entstanden
  CellWidth : Integer;    // DrawGridFeldbreite (für die Skalierung)
  CellHeight : Integer;   // DrawGridfeldhöhe  (für die Skalierung)
  MusicPath : String;     // Pfad zur Musikdatei
  FontPath : PWideChar;   // Pfad zur Datei mit Schriften

implementation

{$R *.dfm}

uses URanking;

{Zeichnet das Spielfeld mit Hilfe der DrawGrid Komponente}
procedure TForm1.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  rand :integer;
  bmp, start : TBitMap;
begin
   ulogic_nowater();
   ulogic_fillwater(xStart, yStart);
   //Es wird die Nummer des erforderlichen Bildes bekommen
   rand := udraw_getImageFromImageList(GameField.Pipes[ACol, ARow]);
   //Es wird eine BitMap erzeugt
   bmp := TBitMap.Create;
   //Es wird ein bestimmtes Bild in die BitMap gespeichert
   if ImageList1.GetBitmap(rand, bmp) then;
    //Es werden benutzerdefinierte Farben eingesetzt
   if NOT (uconfig_istronTheme()) then begin
      if (GameField.Pipes[ACol, ARow].image = e_wall) then
           //Wall
          changeColorOfBitmap(bmp, uconfig_getCW(), true)
      else begin
          if GameField.Pipes[ACol, ARow].water then
             //Rohrstück mit Wasser
             changeColorOfBitmap(bmp, uconfig_getCFP() ,false)
          else
             //Rohrstück ohne Wasser
             changeColorOfBitmap(bmp, uconfig_getCEP(), false);
          //Background
          changeColorOfBitmap(bmp, uconfig_getCBG() ,true);
      end;
   end;
   //das Bild wird je nach seiner Position gedreht
   udraw_rotateBitmap(bmp, GameField.Pipes[ACol, ARow].position);
    //das Startszmbol wird gezeichnet
    if NOT (GameField.Pipes[ACol, ARow].image = e_empty) then
        if ((xStart = ACol) and (yStart = ARow)) then begin
           start := TBitMap.Create;
           if ImageList1.GetBitmap(0, start) then;
           bmp:= overlayWithTransparentImage (bmp, start);
        end;
   //Einzeichen des Feldes
   DrawGrid1.Canvas.CopyRect(DrawGrid1.CellRect(ACol, ARow), bmp.Canvas, System.Classes.Rect(0,0,bmp.Height-1,bmp.Width-1));
   bmp.Free;
end;

{Bearbeitet die Anzah der Klicks}
procedure TForm1.DrawGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var
     col,row : Integer;
     GameType : TGameType;
     Name : String;
     clicksScore, timeScore : Double;
begin
  //Bekommen der Koordinaten des Feldes, welches angedrückt war
  TDrawGrid(Sender).MouseToCell(X,Y,col,row);
  //Drehen des Bildes je nach dem angedrückten Button
  if ((col >= 0) and (col < uconfig_getGFWidth()) and (row >= 0) and (row < uconfig_getGFHeight())) then begin
  case Button of
     TMouseButton.mbLeft: udata_changePosition(GameField.Pipes[col,row], false);
     TMouseButton.mbRight: udata_changePosition(GameField.Pipes[col,row], true);
  end;
  DrawGrid1.Repaint;
  Inc(clicks);  //Inkrementieren des Fachindexes
  //Inkrementieren des Fachindexes
  //Es wird bestimmt, ob das Spiel zum Ende ist
  if ulogic_won() then
  begin
      Timer2.Enabled := false;  //Timer wird angehalten
      if uconfig_isOverflow() then GameType:= e_overflow else GameType:= e_NOToverflow;
      //Es werden Scores berechnet
      clicksScore :=  clicks_pro_cell(clicks);
      timeScore := time_pro_cell(timeInSec);
      //Es wird bestimmt, ob der Spieler gewonnen hat und einen Platz im Ranking genommen
      if (uranking_data_checkScore(GameType, e_clicks, clicksScore) or
          uranking_data_checkScore(GameType, e_time, timeScore)) then
          begin
            ShowMessage('Congratulations! You have done it with ' + IntToStr(clicks) + ' clicks and in ' + IntToStr(timeInSec) + ' seconds');
            repeat
                Name := InputBox('','Please enter your name, user!', 'User');
            until ((Name <> '') and (Length(Name) < 11));
            if uranking_data_isHero(GameType,e_clicks,Name,clicksScore) then begin
               uranking_data_addScore_intoStorage(GameType, e_clicks, Name, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now), clicksScore);
               uranking_data_addScore_intoStorage(GameType, e_time, Name, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now), timeScore);
               end
            else if uranking_data_isHero(GameType,e_time,Name,timeScore) then
                    uranking_data_addScore_intoStorage(GameType, e_time, Name, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now), timeScore)
                 else
                    ShowMessage('It is a pity, user. You last result was better!');
          end
      else
           ShowMessage('Do your best next time, user!');
      NewGameButtonClick(Self);
  end;
 end;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
  buttonSelected : Integer;
  openDialog : TOpenDialog;
  fileSelected : Boolean;
begin
// Initialisierung der Standardwerte
  fileSelected := true;
  FontPath := 'tr2n.TTF';
  MusicPath := 'music.wma';

  uconfig_init_standard_values();

  Main.Height := DEF_FRM_HEIGHT;
  Main.Width := DEF_FRM_WIDTH;
  ImageList1.Width := IMAGE_WIDTH;
  ImageList1.Height := IMAGE_HEIGHT;
  CellWidth := DEF_FIELDSIZE;
  CellHeight := DEF_FIELDSIZE;
  DrawGrid1.DefaultDrawing := false;

  // Es wird Config hochgeladen
  if Not uconfig_loading('Game.cfg') then
  begin
     ShowMessage('The configuration cant be loaded!');
     buttonSelected := MessageDlg('Would you like to find the file yourself?',mtConfirmation,
                              [mbYes,mbNo], 0);
       if buttonSelected = mrYes  then begin
           openDialog := TOpenDialog.Create(self);
         openDialog.InitialDir := GetCurrentDir;
         openDialog.Options := [ofFileMustExist];
         openDialog.Filter := 'Only cfg files(*.cfg)|*.cfg';
         openDialog.FilterIndex := 1;
         if openDialog.Execute then begin
            if Not  uconfig_loading(openDialog.FileName) then
                ShowMessage('The configuration cant be loaded! Standart values will be taken');
         end;
         openDialog.Free;
       end;
  end;

  // Es werden Ranking-daten hochgeladen
  uranking_data_init();
  uranking_data_load_fromFile();
  try
     if AddFontResource(FontPath)=1 then;
     if SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0)=1 then;
  except
      ShowMessage('Path to fonts is wrong!');
  end;

   // Fehlerbearbeitung: Musikdatei ist nicht existiert.
  if Not FileExists(MusicPath) then begin
      ShowMessage('Path to music is wrong!');
       buttonSelected := MessageDlg('Do you want to change the path?',mtConfirmation,
                              [mbYes,mbNo], 0);
       if buttonSelected = mrYes  then begin
         openDialog := TOpenDialog.Create(self);
         openDialog.InitialDir := GetCurrentDir;
        // Only allow existing files to be selected
         openDialog.Options := [ofFileMustExist];
        // Allow only .dpr and .pas files to be selected
        openDialog.Filter := 'Only wma files(*.wma)|*.wma';
        openDialog.FilterIndex := 1;
         // Display the open file dialog
         if openDialog.Execute then begin
          MusicPath:=openDialog.FileName;
          fileSelected := true;
         end
         else begin
          fileSelected := false;
          ShowMessage('Open file was cancelled');
         end;
         // Free up the dialog
         openDialog.Free;
       end;

       if buttonSelected = mrNo then
           fileSelected := false;
  end;
  if fileSelected then begin
    try
      MediaPlayer1.filename:= MusicPath;
      MediaPlayer1.open;
      MediaPlayer1.TimeFormat := tfMilliseconds;
      MusikTimer.Interval := MediaPlayer1.Length + 1000;
      MediaPlayer1.play;
      MusikTimer.Enabled := True;
    finally
    end;
  end;

   // Es werden Bilder hochgeladen
  udraw_setImageList(ImageList1);
  if udraw_loadImages(ImageList1) then begin
     ShowMessage('Pictures cant be loaded! The program will be terminated!');
     Application.Terminate;
  end;

  NewGameButtonClick(Self);
  end;

{Ändert die Größe des Spielfensters}
procedure TForm1.FormResize(Sender: TObject);
begin
    setCoordinates();
    DrawGrid1.Repaint;
end;

{Rechnet und setzt neue Bild- und DrawGridgrößen}
procedure TForm1.setCoordinates();
begin
      CellWidth :=  round((DEF_FRM_WIDTH - 270)/ uconfig_getGFWidth()) + round((Main.Width - DEF_FRM_WIDTH) / uconfig_getGFWidth());
    DrawGrid1.DefaultColWidth := CellWidth;
    //Berechnung, setzen der Spielfeldbreite mit Rahmen und Randpixeln
    DrawGrid1.Width := uconfig_getGFWidth() * (CellWidth) +
                               (uconfig_getGFWidth()+1) * DrawGrid1.GridLineWidth + 2;

    //Berechnung der Zellenhoehe
    CellHeight :=  round((DEF_FRM_HEIGHT - 70)/ uconfig_getGFHeight()) + round((Main.Height - DEF_FRM_HEIGHT) / uconfig_getGFHeight());
    DrawGrid1.DefaultRowHeight := CellHeight;
    //Berechnung, setzen der Spielfeldhoehe mit Rahmen und Randpixeln
    DrawGrid1.Height := uconfig_getGFHeight() * (CellHeight) +
                                (uconfig_getGFHeight()+1) * DrawGrid1.GridLineWidth + 2;
end;

{Startet ein neues Spiel}
procedure TForm1.NewGameButtonClick(Sender: TObject);
var
    GameField : TGameField;
begin
    Timer2.Interval := 1000;
    Timer2.Enabled := true;
    //Das Spiel bei dem Generieren des Spielfeldes neuzustarten ist nicht erlaubt
    NewGameButton.Enabled :=false;
    LoadButton.Enabled :=false;
    clicks := 0;
    timeInSec := 0;
    udata_freeGameField(GameField);
    DrawGrid1.ColCount := uconfig_getGFWidth();
    DrawGrid1.RowCount := uconfig_getGFHeight();
    generateGameField(DrawGrid1.RowCount, DrawGrid1.ColCount);
    setCoordinates();
    NewGameButton.Enabled :=true;
    LoadButton.Enabled :=true;
    DrawGrid1.Repaint;
end;

procedure TForm1.NewGameButtonMouseEnter(Sender: TObject);
begin
    NewGameButton.Caption := '<New Game>';
    NewGameButton.Font.Color := $00009CFE;
end;

procedure TForm1.NewGameButtonMouseLeave(Sender: TObject);
begin
    NewGameButton.Caption := 'New Game';
    NewGameButton.Font.Color := $00DFC36F;
end;

{Startet das Formular mit Settings an}
procedure TForm1.SettingsButtonClick(Sender: TObject);
begin
    Timer2.Enabled := false;
    if Settings.ShowModal=1 then;
    Timer2.Enabled := true;
    if restart then begin
          udata_freeGameField(GameField);
          DrawGrid1.ColCount := uconfig_getGFWidth();
          DrawGrid1.RowCount := uconfig_getGFHeight();
          generateGameField(DrawGrid1.RowCount, DrawGrid1.ColCount);
          setCoordinates();
          NewGameButtonClick(nil);
          restart := false;
    end;
    DrawGrid1.Repaint;
end;

procedure TForm1.SettingsButtonMouseEnter(Sender: TObject);
begin
    SettingsButton.Caption := '<Settings>';
    SettingsButton.Font.Color := $00009CFE;
end;

procedure TForm1.SettingsButtonMouseLeave(Sender: TObject);
begin
   SettingsButton.Caption := 'Settings';
   SettingsButton.Font.Color := $00DFC36F;
end;

{Startet das Formular mit den Ranglisten}
procedure TForm1.StatsButtonClick(Sender: TObject);
begin
   Timer2.Enabled := false;
   if Ranking.ShowModal=0 then;
   Timer2.Enabled := true;
end;

procedure TForm1.StatsButtonMouseEnter(Sender: TObject);
begin
   StatsButton.Caption := '<Stats>';
   StatsButton.Font.Color := $00009CFE;
end;

procedure TForm1.StatsButtonMouseLeave(Sender: TObject);
begin
   StatsButton.Caption := 'Stats';
   StatsButton.Font.Color := $00DFC36F;
end;

{Schliest das Spielfenster}
procedure TForm1.ExitButtonClick(Sender: TObject);
begin
   uranking_data_save_intoFile();
   uconfig_saving();
   udata_freeGameField(GameField);
   if RemoveFontResource(FontPath) then ;
   if SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0)=0 then ;
   Main.Close;
end;

procedure TForm1.ExitButtonMouseEnter(Sender: TObject);
begin
   ExitButton.Caption := '<End>';
   ExitButton.Font.Color := $00009CFE;
end;

procedure TForm1.ExitButtonMouseLeave(Sender: TObject);
begin
   ExitButton.Caption := 'End';
   ExitButton.Font.Color := $00DFC36F;
end;

{Lädt das Spiel}
procedure TForm1.LoadButtonClick(Sender: TObject);
var
  i,j, height, width : Integer;
  OutputStream : TFileStream;
begin
  try
    OutputStream := TFileStream.Create('gSame.sav', fmOpenRead);
    udata_freeGameField(GameField);
    try
      OutputStream.ReadBuffer(clicks, SizeOf(Integer));
      OutputStream.ReadBuffer(timeInSec, SizeOf(Integer));
      OutputStream.ReadBuffer(xStart, SizeOf(Integer));
      OutputStream.ReadBuffer(yStart, SizeOf(Integer));
      OutputStream.ReadBuffer(height, SizeOf(Integer));
      OutputStream.ReadBuffer(width, SizeOf(Integer));
      uconfig_setGFHeight(height);
      uconfig_setGFWidth(width);
      DrawGrid1.ColCount := width;
      DrawGrid1.RowCount := height;
      udata_initializeGameField(GameField,  DrawGrid1.RowCount, DrawGrid1.ColCount);
      setCoordinates();
      for j := 0 to  DrawGrid1.RowCount-1 do
          for i := 0 to DrawGrid1.ColCount-1 do
              begin
                 OutputStream.ReadBuffer(GameField.Pipes[i,j].water, sizeOf(Boolean));
                 OutputStream.ReadBuffer(GameField.Pipes[i,j].image, sizeOf(TPipeImage));
                 OutputStream.ReadBuffer(GameField.Pipes[i,j].position, sizeOf(TPipePosition));
                 OutputStream.ReadBuffer(GameField.Pipes[i,j].canalUp, sizeOf(Boolean));
                 OutputStream.ReadBuffer(GameField.Pipes[i,j].canalRight, sizeOf(Boolean));
                 OutputStream.ReadBuffer(GameField.Pipes[i,j].canalBottom, sizeOf(Boolean));
                 OutputStream.ReadBuffer(GameField.Pipes[i,j].canalLeft, sizeOf(Boolean));
              end;
    finally
      OutputStream.Free;
    end;
  except
    ShowMessage('The game could not be loaded!');
  end;
  DrawGrid1.Repaint;
end;

{Speichert das Spiel}
procedure TForm1.SaveButtonClick(Sender: TObject);
var
  i,j, height, width : Integer;
  InputStream : TFileStream;
begin
  height := uconfig_getGFHeight();
  width := uconfig_getGFWidth();
  try
    InputStream := TFileStream.Create('gSame.sav', fmCreate);
    try
      InputStream.WriteBuffer(clicks, SizeOf(Integer));
      InputStream.WriteBuffer(timeInSec, SizeOf(Integer));
      InputStream.WriteBuffer(xStart, SizeOf(Integer));
      InputStream.WriteBuffer(yStart, SizeOf(Integer));
      InputStream.WriteBuffer(height, sizeOf(Integer));
      InputStream.WriteBuffer(width, sizeOf(Integer));

      for j := 0 to height-1 do
          for i := 0 to width-1 do
              begin
                 InputStream.WriteBuffer(GameField.Pipes[i,j].water, sizeOf(Boolean));
                 InputStream.WriteBuffer(GameField.Pipes[i,j].image, sizeOf(TPipeImage));
                 InputStream.WriteBuffer(GameField.Pipes[i,j].position, sizeOf(TPipePosition));
                 InputStream.WriteBuffer(GameField.Pipes[i,j].canalUp, sizeOf(Boolean));
                 InputStream.WriteBuffer(GameField.Pipes[i,j].canalRight, sizeOf(Boolean));
                 InputStream.WriteBuffer(GameField.Pipes[i,j].canalBottom, sizeOf(Boolean));
                 InputStream.WriteBuffer(GameField.Pipes[i,j].canalLeft, sizeOf(Boolean));
              end;
    finally
      InputStream.Free;
    end;
  except
    ShowMessage('The configuration cant be saved!');
  end;
end;

{Startet Musik an}
procedure TForm1.MusikTimerTimer(Sender: TObject);
begin
  MediaPlayer1.Play;
end;

{Zählt die Sekunden, wie lange das Spiel dauert}
procedure TForm1.Timer2Timer(Sender: TObject);
begin
 Inc(timeInSec);
 Panel1.Caption := SecToTime(timeInSec);
 Panel1.Visible := true;
end;

{Wandelt die Sekunden in '00:00:00'
IN                          - Integer
RETURN                      - Uhrzeit}
function TForm1.SecToTime(Sec: Integer): string;
var
   H, M, S: string;
   ZH, ZM, ZS: Integer;
begin
   ZH := Sec div 3600;
   ZM := Sec div 60 - ZH * 60;
   ZS := Sec - (ZH * 3600 + ZM * 60) ;
   H := IntToStr(ZH) ;
   M := IntToStr(ZM) ;
   S := IntToStr(ZS) ;
   if Length(H) = 1 then H:='0' + H;
   if Length(M) = 1 then M:='0' + M;
   if Length(S) = 1 then S:='0' + S;

   SecToTime := H + ':' + M + ':' + S;
end;

{Es wird mittlere Anzahl von Klicks pro Zelle berechnet
IN clicks                   - von der Klicks
RETURN                      - mittlere Anzahl von Klicks pro Zelle
}
function TForm1.clicks_pro_cell(clicks : Integer) : Double;
begin
   clicks_pro_cell := clicks / (uconfig_getGFHeight()*uconfig_getGFWidth());
end;

{Es wird mittlere Zeit pro Zelle berechnet
In Time                     - Spieldauer
RETURN                      - mittlere Zeit pro Zelle}
function TForm1.time_pro_cell(Time : TTime) : Double;
begin
   time_pro_cell := Time / (uconfig_getGFHeight()*uconfig_getGFWidth());
end;

procedure TForm1.LoadButtonMouseEnter(Sender: TObject);
begin
   LoadButton.Caption := '<Load>';
   LoadButton.Font.Color := $00009CFE;
end;

procedure TForm1.LoadButtonMouseLeave(Sender: TObject);
begin
  LoadButton.Caption := 'Load';
  LoadButton.Font.Color := $00DFC36F;
end;

procedure TForm1.SaveButtonMouseLeave(Sender: TObject);
begin
  SaveButton.Caption := 'Save';
  SaveButton.Font.Color := $00DFC36F;
end;

procedure TForm1.SaveButtonMouseEnter(Sender: TObject);
begin
  SaveButton.Caption := '<Save>';
  SaveButton.Font.Color := $00009CFE;
end;



end.

