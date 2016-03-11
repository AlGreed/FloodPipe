{------------------------------------------------------------------------------
   Diese Unit beinhaltet die eigentlichen Routinen die dem Spiel eine Logik
   verleiht.
   Autor: Oleksandr Nosenko, 13.01.13
 ------------------------------------------------------------------------------}

unit ULogic;

interface

uses UData, UConfig;

{Prüft ob alle Rohrstücke an ihren offenen Seiten verbunden sind}
function ulogic_won() : Boolean;
{Generiert ein Spielfeld}
procedure generateGameField(Heigth, Width : Integer);
{Belegt ein Feld mit einem Rohrstück}
procedure generateField(xCord, yCord : Integer);
{Befüllt die Rohrstücke mit Wasser (Rekursiv)}
procedure ulogic_fillwater(xCord, yCord : Integer);
{Entleert die Rohrstücke von Wasser}
procedure ulogic_nowater();

var
     GameField: TGameField; // Spielfeld

implementation

{Prüft ob das Feld nicht außerhald des Spielfeldes liegt
RETURN                   - Wahrheitswert}
function notOutOfTheField(x, y : Integer): Boolean;
begin
   notOutOfTheField :=  (x < GameField.Width) and (x >=0) and (y < GameField.Height) and (y >=0);
end;

{Prüft ob ein Verbinden mit einem benachbartem Feld sein muss
IN Pipe                  - Rohrstück
IN go                    - Ausrichtung
OUT noWay                - benachbartes Feld mit keinem Zugang
RETURN                   - Wahrheitswert}
function HasToOrCantBeConnectedTo(Pipe : TPipe; go : TGo; var noWay : Boolean): Boolean;
var flag : Boolean;
begin
   flag := false;
   case go of
         goUp: if (Pipe.canalBottom = true) then flag:=true else noWay := true;
         goRight: if (Pipe.canalLeft = true) then flag:=true else noWay := true;
         goBottom: if (Pipe.canalUp = true) then flag:=true else noWay := true;
         goLeft: if (Pipe.canalRight = true) then flag:=true else noWay := true;
   end;
HasToOrCantBeConnectedTo := flag;
end;

{Prüft ob das Feld freie Felder in seiner Umgebung hat
IN Pipe                  - Rohrstück
IN go                    - Ausrichtung
RETURN                   - Wahrheitswert}
function isFieldFree(Pipe : TPipe; go : TGo): Boolean;
var flag : Boolean;
begin
   flag := false;
   if (Pipe.image = e_empty) then begin
     case go of
           goUp:  flag := true;
           goRight: flag := true;
           goBottom: flag := true;
           goLeft: flag := true;
     end;
   end;
   isFieldFree := flag;
end;

{Untersucht die benachbarten Felder
IN Pipe                  - Rohrstück
IN go                    - Ausrichtung
OUT  weight              - Zahl der benachbarten Rohrstücke, die zu verbinden sind
OUT free                 - Freiheitsgrad
OUT _isFree              - ob benachbartes Feld frei ist
OUT noWay                - ob benachbartes Feld mit keinem Zugang ist
RETURN                   - Wahrheitswert}
function weighting(Pipe : TPipe; go : TGo; var free, weight : Integer; var noWay: Boolean; var _isFree : Boolean) : Boolean;
var flag : Boolean;
begin
    flag := false;
    _isFree :=  isFieldFree(Pipe, go);
    if _isFree then begin
           Inc(free);
           flag := false;
           end
      else
           if HasToOrCantBeConnectedTo(Pipe, go, noWay) then begin Inc(weight); flag := true; end;
   weighting := flag;
end;


{Dreht zuällig alle Felder}
procedure ulogic_messGameField();
 var
    i,j : Integer;
 begin
   for j := 0 to GameField.Height-1 do
       for I := 0 to GameField.Width-1 do
          udata_changePosition(GameField.Pipes[i,j], Random(2) = 0);
end;


{Platziert Wände
RETURN    Wahrheitswert der besagt ob der Anteil an Wänden überschritten wurde}
function ulogic_putWalls() : boolean;
var
   i,j, counter : Integer;
    flag : Boolean;
  begin
  counter := 0;
  flag := false;
     for j := 0 to GameField.Height-1 do
         for I := 0 to GameField.Width-1 do
            if GameField.Pipes[i,j].image = e_empty then begin
                  GameField.Pipes[i,j].image := e_wall;
                  Inc(counter);
                  //geprüft, ob die Zahl der platzierten Wände die Zahl
                  //der gelassenen Wände nicht überstiegen ist
                  if counter > ((GameField.Width * GameField.Height * wallPercent)/100) then begin
                      flag := true;
                      break;
                  end;
            end;
     ulogic_putWalls := flag;
end;


{Generiert ein Spielfeld
IN Height                - Spielfeldhöhe
IN Width                 - Spielfeldbreite}
procedure generateGameField(Heigth, Width : Integer);
begin
    // Das SpielFeld wird initialisiert
    udata_initializeGameField(GameField, Heigth, Width);

    //Es werden die Startkoordinaten bestimmt
    xStart := Random(GameField.Width);
    yStart := Random(GameField.Height);

    // Es wird ein Feld mit den Startkoordinaten belegt
    generateField(xStart, yStart);

    //Es werden Wände gelegt. Sollte es sich zu viele Wände auf dem Spieldfeld
    // befinden, so wird das Generieren des Spielfeldes neu gestartet.
    if  ulogic_putWalls() then begin
        udata_freeGameField(GameField);
        generateGameField(Heigth, Width); end
    else begin
    // Zufälliges Drehen der Felder auf dem SpielFeld
      ulogic_messGameField();
    // Es wird bestimmt, welche Rohrstücke mit Wasser gefüllt sind
      ulogic_fillwater(xStart,yStart);
    end;
end;

{Liefert bei einem Überlauf die Koordinaten das nächst vorkommenden Rohrstückes
IN go                    - Ausrichtung
IN xCord                 - x-Koordinate des Ausgangsspielfeldes
IN yCord                 - y-Koordinate des Ausgangsspielfeldes
IN tmpxCord              - x-Koordinate des Zugangsspielfeldes
IN tmpyCord              - y-Koordinate des ZugangsSpielfeldes}
procedure setCordinates(go : TGo; xCord, yCord : Integer; var tmpxCord, tmpyCord:Integer);
begin
   case go of
     goUp:     if ((uconfig_isOverflow()) and (yCord-1 < 0)) then begin
                  tmpxCord:=xCord; tmpyCord:=GameField.Height-1; end
               else begin tmpxCord:=xCord; tmpyCord:=yCord-1;  end;

     goRight:  if ((uconfig_isOverflow()) and (xCord+1 = GameField.Width)) then begin
                  tmpxCord:=0; tmpyCord:=yCord; end
               else begin tmpxCord:=xCord+1; tmpyCord:=yCord; end;

     goBottom: if ((uconfig_isOverflow()) and (yCord+1 = GameField.Height)) then begin
                  tmpxCord:=xCord; tmpyCord:=0; end
               else begin tmpxCord:=xCord; tmpyCord:=yCord+1; end;

     goLeft:   if ((uconfig_isOverflow()) and (xCord-1 < 0)) then begin
                  tmpxCord:=GameField.Width-1; tmpyCord:=yCord; end
               else begin tmpxCord:=xCord-1; tmpyCord:=yCord; end;
   end;
end;

{Prüft ob alle Rohrstücke an ihren offenen Seiten verbunden sind
RETURN                   - Wahrheitswert}
function ulogic_won() : Boolean;
var
  xCord,yCord : Integer;
  isWon : boolean;
  tmpxCord, tmpyCord : Integer;
   Pipe : TPipe;
begin
   isWon := true;
   for yCord := 0 to GameField.Height-1 do
     for xCord := 0 to GameField.Width-1 do
       begin
    Pipe := GameField.Pipes[xCord,yCord];
       //alle Rohrstücke müssen mit Wasser gefüllt sein
    if ((Pipe.water = false) and Not (Pipe.image = e_wall)) then
         isWon := false
    else
    //Es müssen keine freien Felder, keine Rohrstücke mit offenen Kanalen vorhanden sein
        if (Pipe.canalUp = true) then  //Es wird das obenligende Rohrstück geprüft
          if notOutOfTheField(xCord, yCord-1) or (uconfig_isOverflow()) then begin
             setCordinates(goUp, xCord, yCord, tmpxCord, tmpyCord);
             if  Not GameField.Pipes[tmpxCord,tmpyCord].canalBottom then
                 isWon := false;
          end
          else isWon := false;

        if (Pipe.canalRight = true) then  //Es wird das rechtsligende Rohrstück geprüft
          if notOutOfTheField(xCord+1, yCord) or (uconfig_isOverflow()) then begin
             setCordinates(goRight, xCord, yCord, tmpxCord, tmpyCord);
             if Not GameField.Pipes[tmpxCord,tmpyCord].canalLeft then
                 isWon := false;
          end
          else isWon := false;

        if (Pipe.canalBottom = true) then //Es wird das untenligende Rohrstück geprüft
          if notOutOfTheField(xCord, yCord+1) or (uconfig_isOverflow()) then begin
             setCordinates(goBottom, xCord, yCord, tmpxCord, tmpyCord);
             if Not GameField.Pipes[tmpxCord,tmpyCord].canalUp then
                 isWon := false;
          end
          else isWon := false;

        if (Pipe.canalLeft = true) then //Es wird das linksligende Rohrstück geprüft
          if notOutOfTheField(xCord-1, yCord) or (uconfig_isOverflow()) then begin
             setCordinates(goLeft, xCord, yCord, tmpxCord, tmpyCord);
             if Not GameField.Pipes[tmpxCord,tmpyCord].canalRight then
                isWon := false;
          end
          else isWon := false;
   end;
   ulogic_won := isWon;
end;

{Bestimmt welches Feld als nächstes belegt werden soll
IN xCord                 - x-Koordinate des Spielfeldes
IN yCord                 - y-Koordinate des Spielfeldes
IN upFree                - ist das obenliegende Feld frei
IN rightFree             - ist das rechtsliegende Feld frei
IN bottomFree            - ist das untenliegende Feld frei
IN leftFree              - ist das linksliegende Feld frei}
procedure ulogic_next(xCord, yCord : Integer; upFree, rightFree, bottomFree, leftFree : Boolean);
var
   tmpxCord, tmpyCord : Integer;
   Pipe : TPipe;
begin
   Pipe := GameField.Pipes[xCord, yCord];
   //Pipe hat ein offener Kanal nach oben und oben liegt ein freies Feld,
   // dann wird dieses Feld als nächstes belegt
   if (Pipe.canalUp and upFree) then begin
        setCordinates(TGo.goUp, xCord, yCord, tmpxCord, tmpyCord);
        generateField(tmpxCord, tmpyCord);
        end;

   if (Pipe.canalRight and rightFree) then begin
        setCordinates(TGo.goRight, xCord, yCord, tmpxCord, tmpyCord);
        generateField(tmpxCord, tmpyCord);
        end;

   if (Pipe.canalBottom and bottomFree) then begin
        setCordinates(TGo.goBottom, xCord, yCord, tmpxCord, tmpyCord);
        generateField(tmpxCord, tmpyCord);
        end;

   if (Pipe.canalLeft and leftFree) then begin
        setCordinates(TGo.goLeft, xCord, yCord, tmpxCord, tmpyCord);
        generateField(tmpxCord, tmpyCord);
        end;
end;

{Belegt ein Feld mit einem Rohrstück
IN xCord                 - x-Koordinate des Spielfeldes
IN yCord                 - y-Koordinate des Spielfeldes}
procedure generateField(xCord, yCord : Integer);
var
   // zeigen, welche Kanäle zu verbinden sind
   up, right, bottom, left : Boolean;
   // zeigen, welche Kanäle nicht zu verbinden sind
   upNoWay, rightNoWay, bottomNoWay, leftNoWay : Boolean;
   // zeigen, welche benachbarte Felder frei sind
   upFree, rightFree, bottomFree, leftFree : Boolean;
   // prüft, ob das Rohrstück korrekt auf dem Spielfeld liegt
   rightPosition : Boolean;
   // zeigt, wie viele benachbarte Rohrstücke zu verbinden sind
   weight: Integer;
   // Freiheitsgrad
   free: Integer;
   tmpxCord, tmpyCord : Integer;
   Pipe : TPipe;
   // zum detallierten Überprüfen von rightPosition
   b1,b2,b3,b4,b5,b6,b7,b8 : boolean;
begin
   weight := 0;
   free := 0;
   up := false;
   right := false;
   bottom:= false;
   left := false;
   upNoWay := false;
   rightNoWay := false;
   bottomNoWay := false;
   leftNoWay := false;
   upFree := false;
   rightFree := false;
   bottomFree := false;
   leftFree := false;
   // Greifen an bestimmtes Rohrstück
   Pipe := udata_getPipeFromGameField(GameField, xCord, yCord);

   // Überprüfung der Feldumgebung
   //Up
   if notOutOfTheField(xCord, yCord-1) or (uconfig_isOverflow()) then begin
      setCordinates(TGo.goUp, xCord, yCord, tmpxCord, tmpyCord);
      up := weighting(GameField.Pipes[tmpxCord, tmpyCord], goUp, free, weight, upNoWay, upFree);
      end
   else upNoWay:=true;
    //Right
   if notOutOfTheField(xCord+1, yCord) or (uconfig_isOverflow()) then begin
      setCordinates(TGo.goRight, xCord, yCord, tmpxCord, tmpyCord);
      right := weighting(GameField.Pipes[tmpxCord, tmpyCord], goRight, free, weight, rightNoWay, rightFree);
   end
   else rightNoWay:=true;
    //Bottom
   if notOutOfTheField(xCord, yCord+1) or (uconfig_isOverflow()) then begin
      setCordinates(TGo.goBottom, xCord, yCord, tmpxCord, tmpyCord);
      bottom := weighting(GameField.Pipes[tmpxCord, tmpyCord], goBottom, free, weight, bottomNoWay, bottomFree);
   end
   else bottomNoWay:=true;
    //Left
   if notOutOfTheField(xCord-1, yCord) or (uconfig_isOverflow()) then begin
      setCordinates(TGo.goLeft, xCord, yCord, tmpxCord, tmpyCord);
      left := weighting(GameField.Pipes[tmpxCord, tmpyCord], goLeft, free, weight, leftNoWay, leftFree);
   end
   else leftNoWay:=true;

   //Je nach der Feldumgebung, wird es ein bestimmtes(aus der Menge
   //gelassener Rohrstücke randomisiert genommen) Rohrstück platziert.
   case weight of
        0:  case free of
                  2: Pipe.image := TPipeImage(3);// hook (StartCell)
                  3, 4: Pipe.image := TPipeImage(1+Random(3)); //line  or threeway or hook (StartCell)
            end;
        1:  case free of
                  0: Pipe.image := TPipeImage(4);
                  1: if ((upNoWay = bottomNoWay) or (rightNoWay = leftNoWay)) then Pipe.image := TPipeImage(1) //line
                         else Pipe.image := TPipeImage(3);// hook;
                  2: if ((upFree = bottomFree) or (rightFree = leftFree)) then Pipe.image := TPipeImage(2+Random(2)) // hook or threeway;
                         else Pipe.image := TPipeImage(1+Random(3)); //line  or threeway or hook
                  3: Pipe.image := TPipeImage(1+Random(3));//line  or threeway or hook
            end;
        2: case free of
                  0:  if ((up = bottom) and (left=right)) then Pipe.image := TPipeImage(1) //line
                         else Pipe.image := TPipeImage(3); // hook
                  1, 2:  if ((up = bottom) and (left=right)) then Pipe.image := TPipeImage(1+Random(2))  //line  or threeway
                         else Pipe.image := TPipeImage(2+Random(2));// hook or threeway;
            end;
        3: Pipe.image := TPipeImage(2); // threeway
   end;
   // Setzen der Position des Rohrstückes
   Pipe.position := e_normal;
   // Setzen der Kanälen des Rohrstückes
   udata_setCanals(Pipe);

   // Überprüfen, ob das Rohrstück korrekt auf dem Spielfeld liegt
   // wenn nein - dann drehen bis es passiert.
   Repeat
       b1 := ((up = Pipe.canalUp) or (upFree = Pipe.canalUp));
       b2 :=  ((right = Pipe.canalRight) or (rightFree = Pipe.canalRight));
       b3 := ((bottom = Pipe.canalBottom) or (bottomFree = Pipe.canalBottom)) ;
       b4 := ((left = Pipe.canalLeft) or (leftFree = Pipe.canalLeft))    ;
       b5 := ((Not upNoWay = Pipe.canalUp) or upFree);
       b6 := ((Not rightNoWay = Pipe.canalRight) or rightFree);
       b7 :=  ((Not bottomNoWay = Pipe.canalBottom) or bottomFree);
       b8 :=  ((Not leftNoWay = Pipe.canalLeft) or leftFree);

       rightPosition := b1 and  b2 and  b3
        and b4 and b5
        and b6 and b7
        and b8;
        if  Not rightPosition then udata_changePosition(Pipe, true);
   Until rightPosition;
   // das Feld wird mit dem Rohrstück belegt
   udata_putPipeOnGameField(Pipe, GameField, xCord, yCord);
   // Es wird bestimmt, welches Feld als nächstes belegt wird
   ulogic_next(xCord, yCord, upFree, rightFree, bottomFree, leftFree);
end;

{Entleert die Rohrstücke von Wasser}
procedure ulogic_nowater();
var
  i,j : Integer;
begin
   for j := 0 to GameField.Height-1 do
     for i := 0 to GameField.Width-1 do
        GameField.Pipes[i,j].water := false;
end;

{Befüllt die Rohrstücke mit Wasser (Rekursiv)
IN xCord                 - x-Koordinate des Spielfeldes
IN yCord                 - y-Koordinate des Spielfeldes}
procedure ulogic_fillwater(xCord, yCord : Integer);
var
  Pipe : TPipe;
  tmpxCord, tmpyCord : Integer;
begin
  Pipe := GameField.Pipes[xCord,yCord];

	if NOT Pipe.water then
	begin
		Pipe.water := true;
    udata_putPipeOnGameField(Pipe, GameField, xCord, yCord);

		if (Pipe.canalUp = true) then
      if notOutOfTheField(xCord, yCord-1) or (uconfig_isOverflow()) then begin
         setCordinates(goUp, xCord, yCord, tmpxCord, tmpyCord);
         if GameField.Pipes[tmpxCord,tmpyCord].canalBottom then
             ulogic_fillwater(tmpxCord,tmpyCord);
      end;

		if (Pipe.canalRight = true) then
      if notOutOfTheField(xCord+1, yCord) or (uconfig_isOverflow()) then begin
         setCordinates(goRight, xCord, yCord, tmpxCord, tmpyCord);
         if GameField.Pipes[tmpxCord,tmpyCord].canalLeft then
             ulogic_fillwater(tmpxCord,tmpyCord);
      end;

		if (Pipe.canalBottom = true) then
      if notOutOfTheField(xCord, yCord+1) or (uconfig_isOverflow()) then begin
         setCordinates(goBottom, xCord, yCord, tmpxCord, tmpyCord);
         if GameField.Pipes[tmpxCord,tmpyCord].canalUp then
             ulogic_fillwater(tmpxCord,tmpyCord);
      end;

		if (Pipe.canalLeft = true) then
      if notOutOfTheField(xCord-1, yCord) or (uconfig_isOverflow()) then begin
         setCordinates(goLeft, xCord, yCord, tmpxCord, tmpyCord);
         if GameField.Pipes[tmpxCord,tmpyCord].canalRight then
             ulogic_fillwater(tmpxCord,tmpyCord);
      end;
	end;
end;

end.

