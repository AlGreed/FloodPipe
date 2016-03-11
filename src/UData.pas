{------------------------------------------------------------------------------
   Diese Unit dient zur Datenhaltung fuer die Rohrstücke auf dem Spielfeld.
   Sie stellt Verarbeitungsroutinen und Typen zum Verwalten der Rohrstuecke.

   Autor: Oleksandr Nosenko, 13.01.13
 ------------------------------------------------------------------------------}

unit UData;

interface

type
    {Bestimmt welches Rohrstück eingesetzt wird}
    TPipeImage = (e_empty, e_line, e_threeway, e_hook, e_end, e_wall);

    {Bestimmt in welche Position ein Rohrstueck eingesetzt werden soll}
    TPipePosition = (e_normal, e_right, e_invert, e_left);

    {Stellt ein Feld des Spielfeldes dar}
    TPipe = record
       water : Boolean;
       image : TPipeImage;
       position : TPipePosition;
       canalUp, canalRight, canalBottom, canalLeft : Boolean;
    end;

    {Stellt das gesamte Spielfeld dar}
    TGameField = record
        Pipes : array of array of TPipe;
        Height : Integer;
        Width : Integer;
    end;

    {Richtungsangaben}
    TGo = (goUp, goRight, goBottom, goLeft);

{Rotiert ein Rohrstück}
procedure udata_changePosition(var Pipe : TPipe; toRight : Boolean);
{Initialisiert das Spielfeld}
procedure udata_initializeGameField(var GameField : TGameField; Height, Width: Integer);
{Gibt das Spielfeld frei}
procedure udata_freeGameField(var GameField : TGameField);
{Gibt ein Feld vom Spielfeld zurück}
function udata_getPipeFromGameField(GameField : TGameField; ACol, ARow: Integer) : TPipe;
{Setzt ein Feld auf das Spielfeld}
procedure udata_putPipeOnGameField(Pipe : TPipe; GameField : TGameField; ACol, ARow: Integer);
{Setzt die Ausgangsrichtung eines Rohrstückes fest}
procedure udata_setCanals(var Pipe : TPipe);

implementation

{Initialisiert ein Spielfeld
OUT GameField       - Spielfeld
IN Height           - Spielfeldhöhe
IN Width            - Spielfeldbreite}
procedure udata_initializeGameField(var GameField : TGameField; Height, Width: Integer);
var
  i,j : Integer;
begin
  GameField.Height := Height;
  GameField.Width := Width;
  SetLength(GameField.Pipes, Width, Height);

  for j := 0 to Height-1 do
     for i := 0 to Width-1 do
      begin
        GameField.Pipes[i,j].water := false;
        GameField.Pipes[i,j].image := e_empty;
        GameField.Pipes[i,j].position := e_normal;
        udata_setCanals(GameField.Pipes[i,j]);
	  	end;
end;

{Gibt das Spielfeld frei
OUT GameField       - zu freigebendes SpielFeld }
procedure udata_freeGameField(var GameField : TGameField);
begin
  SetLength(GameField.Pipes, 0, 0);
end;

{Setzt ein Feld auf das Spielfeld
IN Pipe             - zu setzendes Rohrstück
IN GameField        - Spielfeld
IN ACol             - X-Koordinate
IN ARow             - Y-Koordinate}
procedure udata_putPipeOnGameField(Pipe : TPipe; GameField : TGameField; ACol, ARow: Integer);
begin
  GameField.Pipes[ACol, ARow] := Pipe;
end;

{Gibt ein Feld vom Spielfeld zurück
IN GameField        - SpielFeld
IN ACol             - X-Koordinate
IN ARow             - Y-Koordinate}
function udata_getPipeFromGameField(GameField : TGameField; ACol, ARow: Integer) : TPipe;
begin
  udata_getPipeFromGameField := GameField.Pipes[ACol, ARow];
end;

{Hilfsfunktion zum Rotieren eines Rohrstückes
OUT Pipe            - zu drehendes Rohrstück
IN toRight          - Richtung in die gedreht werden soll}
procedure udata_rotateCanals(var Pipe : TPipe; toRight : Boolean);
var
  flag : Boolean;
begin
  if (toRight) then
    begin
      flag := Pipe.canalUp;
      Pipe.canalUp := Pipe.canalLeft;
      Pipe.canalLeft := Pipe.canalBottom;
      Pipe.canalBottom := Pipe.canalRight;
      Pipe.canalRight := flag;
    end
  else
    begin
      flag := Pipe.canalUp;
      Pipe.canalUp := Pipe.canalRight;
      Pipe.canalRight := Pipe.canalBottom;
      Pipe.canalBottom := Pipe.canalLeft;
      Pipe.canalLeft := flag;
    end
end;

{Rotiert ein Rohrstück
OUT Pipe            - zu drehendes Rohrstück
IN toRight          - Richtung in die gedreht werden soll}
procedure udata_changePosition(var Pipe : TPipe; toRight : Boolean);
begin
  udata_rotateCanals(Pipe, toRight);
  case Pipe.position of
          e_normal : if (toRight) then Pipe.position := e_left
                     else Pipe.position := e_right;
          e_right :  if (toRight) then Pipe.position := e_normal
                     else Pipe.position := e_invert;
          e_invert:  if (toRight) then Pipe.position := e_right
                     else Pipe.position := e_left;
          e_left :   if (toRight) then Pipe.position := e_invert
                     else Pipe.position := e_normal;
  end;
end;

{Hilfsfunktion, setzt die Ausgangsrichtung eines Rohrstückes fest)
OUT Pipe            - entsprechendes Rohrstück
IN _canalUp         - Kanal nach oben
IN _canalRight      - Kanal nach rechts
IN _canalBottom     - Kanal nach links
IN _canalLeft       - Kanal nach unten}
procedure udata_setCanalsValues(var Pipe : TPipe; _canalUp, _canalRight, _canalBottom, _canalLeft : Boolean);
begin
  Pipe.canalUp := _canalUp;
  Pipe.canalRight := _canalRight;
  Pipe.canalBottom := _canalBottom;
  Pipe.canalLeft := _canalLeft;
end;

{Setzt die Ausgangsrichtung eines Rohrstückes fest
OUT Pipe            - zu drehendes Rohrstück}
procedure udata_setCanals(var Pipe : TPipe);
begin
  case Pipe.image of
          e_empty, e_wall: udata_setCanalsValues(Pipe, false, false, false, false);
          e_line: udata_setCanalsValues(Pipe, false, true, false, true);
          e_hook: udata_setCanalsValues(Pipe, false, true, true, false);
          e_threeway: udata_setCanalsValues(Pipe, false, true, true, true);
          e_end: udata_setCanalsValues(Pipe, false, false, true, false);
  end;
end;
end.
