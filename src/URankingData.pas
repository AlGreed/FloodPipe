{------------------------------------------------------------------------------
   Diese Unit dient zur Datenhaltung fuer die Ranglisten.
   Sie stellt Verarbeitungsroutinen zum Verwalten der Liste.
   Es ist zudem auch möglich die Liste zu Speichern und Laden.

   Autor: Oleksandr Nosenko, 13.01.13
 ------------------------------------------------------------------------------}

unit URankingData;


{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF}

interface
  const
   TMaxScore  = 4; {Maximale Anzahl an Ranglisteneinträge}
  type

   {Punktetyp}
   TScoreType = (e_clicks, e_time);

   {Spielmodus}
   TGameType = (e_overflow, e_NOToverflow);

   {Ranglisteneintrag}
   TScore = record
       Name : String[10]; {Spielername}
       Time : String[20]; {Zeitstempel}
       Score : Double;    {Punktestand}
   end;

   {Ranglisteneinträge}
   TScoreIndex = 0 .. TMaxScore;
   TScoreList = array[TScoreIndex] of TScore;

   {Ranglisteneinträge mit allen Disziplinen}
   TStorage = Array[TScoreType, TGameType] of TScoreList;

   {Initialisiert die Rangliste}
   procedure uranking_data_init();
   {Fügt einen neuen Eintrag in die Rangliste hinzu}
   procedure uranking_data_addScore_intoStorage(GameType : TGameType; ScoreType : TScoreType; _Name : String; _Time : String; _Score : Double);
   {Ladet Einträge in die Rangliste hinein}
   procedure uranking_data_load_fromFile();
   {Speichert die Rangliste ab}
   procedure uranking_data_save_intoFile();
   {Prüft ob ein neuer Rekord erreicht wurde}
   function uranking_data_checkScore(GameType : TGameType; ScoreType : TScoreType; _Score : Double) : Boolean;
   {Liefert die Position eines Spielers in der Rangliste}
   function  uranking_data_checkName(GameType : TGameType; ScoreType : TScoreType; _Name : String) : Integer;
   {Prüft ob ein Rekordhalter seinen Rekord geschlagen hat}
   function  uranking_data_isHero(GameType : TGameType; ScoreType : TScoreType; _Name : String; _Score : Double) : Boolean;
   {Liefert einen Ranglisteneintrag zurück}
   function uranking_data_getScore(GameType : TGameType; ScoreType : TScoreType; Index : Integer) : TScore;

implementation

uses
  System.Classes, Vcl.Dialogs, System.SysUtils;

var
  Storage : TStorage;

{Liefert einen Ranglisteneintrag zurück
IN Gametype               - SpielModus
IN ScoreType              - Punktetyp
IN Index                  - Position
RETURN                    - Ranglisteneintrag}
function uranking_data_getScore(GameType : TGameType; ScoreType : TScoreType; Index : Integer) : TScore;
begin
    try
       uranking_data_getScore := Storage[ScoreType, GameType, Index];
    except
       ShowMessage('Cant get Score with Index:' + IntToStr(index));
       uranking_data_init();
    end;
end;

{Initialisiert die Rangliste}
procedure uranking_data_init();
var
    x : Integer;
    y : TGameType;
    z : TScoreType;
begin
    for x := Low(TScoreList) to High(TScoreList) do
      for y := Low(TGameType) to High(TGameType) do
        for z := Low(TScoreType) to High(TScoreType) do
          begin
              Storage[z,y,x].Name := '----------';
              Storage[z,y,x].Time := '--------------------';
              Storage[z,y,x].Score := 9999999;
          end;
end;

{Prüft ob ein neuer Rekord erreicht wurde
IN Gametype               - SpielModus
IN ScoreType              - Punktetyp
IN Score                  - erreichte Punkte
RETURN                    - Wahrheitswert}
function uranking_data_checkScore(GameType : TGameType; ScoreType : TScoreType; _Score : Double) : Boolean;
var
    x : Integer;
    flag : Boolean;
begin
    flag := false;
    for x := Low(TScoreList) to High(TScoreList) do
         if (Storage[ScoreType,GameType,x].Score  > _Score) then
            flag := true;
     uranking_data_checkScore := flag;
end;

{Liefert die Position eines Spielers in der Rangliste
IN Gametype               - SpielModus
IN ScoreType              - Punktetyp
IN _Name                  - Spielername
RETURN                    - sein Platz in Ranking}
function  uranking_data_checkName(GameType : TGameType; ScoreType : TScoreType; _Name : String) : Integer;
var
    x : Integer;
    flag : Integer;
begin
    flag := -1;
    for x := Low(TScoreList) to High(TScoreList) do
         if (Storage[ScoreType,GameType,x].Name = _Name) then
            flag := x;
     uranking_data_checkName := flag;
end;

{Prüft ob ein Rekordhalter seinen Rekord geschlagen hat
IN Gametype               - SpielModus
IN ScoreType              - Punktetyp
In _Name                  - Name des Spielers
In Score                  - erreichte Punkte
Return                    - Wahrheitswert}
function uranking_data_isHero(GameType : TGameType; ScoreType : TScoreType; _Name : String; _Score : Double) : Boolean;
var
    flag : Boolean;
    check : Integer;
begin
    //Platz des Spielers in der Rangliste
    check :=  uranking_data_checkName(GameType, ScoreType, _Name);
    flag := false;
    if check > -1 then begin
      if Storage[ScoreType,GameType,check].Score > _Score then
          flag := true;
       end
    else
          flag := true;
    uranking_data_isHero := flag;
end;

{Fügt einen neuen Eintrag in die Rangliste hinzu
IN Gametype               - SpielModus
IN ScoreType              - Punktetyp
In _Name                  - SpielerName
In _Time                  - Zeitstempel
In Score                  - erreichte Punkte }
procedure uranking_data_addScore_intoStorage(GameType : TGameType; ScoreType : TScoreType; _Name : String; _Time : String; _Score : Double);
var
    x, high : Integer;
    check : Integer;
    tmpName : String;
    tmpTime : String;
    tmpScore : Double;
    begin
    check :=  uranking_data_checkName(GameType, ScoreType, _Name); //Spielerposition in der Rangliste
    if check > -1 then
         high := check //Spieler hat einen Eintrag in der Rangliste
    else high := TMaxScore; //Spieler hat keinen Eintrag in der Rangliste
    //absteigend zu dem Platz des alten Eintrages oder bis letzte Position in der Rankgliste
    for x := Low(TScoreList) to high do
    begin
       if (Storage[ScoreType,GameType,x].Score > _Score) then begin
          tmpName := Storage[ScoreType,GameType,x].Name;
          tmpTime := Storage[ScoreType,GameType,x].Time;
          tmpScore := Storage[ScoreType,GameType,x].Score;

          Storage[ScoreType,GameType,x].Name := _Name;
          Storage[ScoreType,GameType,x].Time := _Time;
          Storage[ScoreType,GameType,x].Score := _Score;

          _Name := tmpName;
          _Time := tmpTime;
          _Score := tmpScore;
       end;
    end;
end;

{Speichert die Rangliste ab}
procedure uranking_data_save_intoFile();
var
  InputStream : TFileStream;
begin
  try
    InputStream := TFileStream.Create('rStorage.sav', fmCreate);
    try
      InputStream.WriteBuffer(Storage, SizeOf(TStorage));
    finally
      InputStream.Free;
    end;
  except
    ShowMessage('rStorage could not be created!');
  end;
end;

{Ladet Einträge in die Rangliste hinein}
procedure uranking_data_load_fromFile();
var
  OutputStream : TFileStream;
begin
  try
    OutputStream := TFileStream.Create('rStorage.sav', fmOpenRead);
    try
      OutputStream.ReadBuffer(Storage, SizeOf(TStorage));
    finally
      OutputStream.Free;
    end;
  except
    ShowMessage('Ranking could not be loaded from rStorage! A new file will be created!');
  end;
end;

end.


