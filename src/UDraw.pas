{------------------------------------------------------------------------------
   Diese Unit stellt Verarbeitungsroutinen zum Zeichnen eines Spielfeldes.
   Sie beinhaltet zu dem die Bilderliste auf die zugegriffen wird.

   Autor: Oleksandr Nosenko, 13.01.13
 ------------------------------------------------------------------------------}

unit UDraw;

interface

uses Winapi.Windows, Vcl.Controls, Vcl.Graphics, UData, System.Classes, System.Types, UConfig;

{Zugriffsmethode einer Bilderliste}
procedure udraw_setImageList(_ImageList : TImageList);
{Fügt ein Bild in die Bilderliste hinzu}
function udraw_addImageIntoImageList(Filepath : String) : Boolean;
{Ladet Bilder in die Bilderliste hinein}
function udraw_loadImages(ImageList : TImageList) : Boolean;
{Liest ein Bild aus der Bilsterliste}
function udraw_getImageFromImageList(Pipe: TPipe) : Integer;
{Rotiert ein Bild}
procedure udraw_rotateBitmap(bmp: TBitmap; position : TPipePosition);
{Zeichnet ein Bild auf ein anderes Bild}
function overlayWithTransparentImage (bmpBackground, bmpForeground: TBitmap): TBitmap;
{Wandelt RGB-Werte in den Typ TColor um}
function RGB2TColor(const r, g, b: byte): TColor;
{Wandelt den Typ TColor in RGB-Werte um}
procedure TColor2RGB(const color: TColor; out r,g,b: byte);
{Ändert die Farbwerte eines Bildes}
procedure changeColorOfBitmap (bmp: TBitmap; colorDest: TColor; invert : Boolean);

implementation

var
  {Eine Liste von Bildern}
  ImageList : TImageList;

  {Pfade zu den Bildern}
  ImagePaths : array[0..14] of String = ('.\\Pictures\\bike.bmp', '.\\Pictures\\line.bmp', '.\\Pictures\\threeway.bmp',
  '.\\Pictures\\hook.bmp', '.\\Pictures\\end.bmp', '.\\Pictures\\wall.bmp',
  '.\\Pictures\\lineWater.bmp', '.\\Pictures\\threewayWater.bmp','.\\Pictures\\hookWater.bmp',
   '.\\Pictures\\endWater.bmp',  '.\\Pictures\\lineNoTronTheme.bmp', '.\\Pictures\\threewayNoTronTheme.bmp',
  '.\\Pictures\\hookNoTronTheme.bmp', '.\\Pictures\\endNoTronTheme.bmp', '.\\Pictures\\wallNoTronTheme.bmp');

{Zugriffsmethode einer Bilderliste
OUT Bilderliste       - zu befüllende Bilderliste}
procedure udraw_setImageList(_ImageList : TImageList);
begin
  ImageList := _ImageList;
end;

{Ladet Bilder in die Bilderliste hinein
IN ImageList         - zu befüllende Bilderliste
RETURN               - Wahrheitswert der besagt ob ein Fehler aufgetreten ist}
function udraw_loadImages(ImageList : TImageList) : Boolean;
var
  i : integer;
  err : Boolean;
begin
  i := 0;
  err := false;
  while((err = false) and (i <=14)) do     // normale + für die tronTheme Bilder
  begin
     err:= udraw_addImageIntoImageList(ImagePaths[i]);
     Inc(i);
  end;
  udraw_loadImages := err;
end;

{Fügt ein Bild in die Bilderliste hinzu
IN Filepath          - Pfad des Bildes
RETURN               - Wahrheitswert der besagt ob ein Fehler aufgetreten ist}
function udraw_addImageIntoImageList(Filepath : String) : Boolean;
var
  bmp : TBitMap;
  err : Boolean;
begin
  err := false;
  bmp := TBitMap.Create;
  try
    bmp.LoadFromFile(Filepath);
    try
      if ImageList.Add(bmp, nil)=0 then;
    finally
      bmp.Free;
    end;
  except
    err := true;
  end;
  udraw_addImageIntoImageList := err;
end;

{Liest ein Bild aus der Bilsterliste
IN Pipe              - Rohrstück, für welches ein entsprechendes Bild ausgesucht wird}
function udraw_getImageFromImageList(Pipe: TPipe) : Integer;
var
    res : Integer;
begin
    res := 0;
    case Pipe.image of
        e_empty : res := 0;
        e_line : if (uconfig_isTronTheme()) then begin if (Pipe.water) then res := 6 else res := 1; end else res:=10;
        e_threeway : if (uconfig_isTronTheme()) then begin if (Pipe.water) then res := 7 else res := 2; end else res:=11;
        e_hook :  if (uconfig_isTronTheme()) then begin if (Pipe.water) then res := 8 else res := 3; end else res:=12;
        e_end : if (uconfig_isTronTheme()) then begin if (Pipe.water) then res := 9 else res := 4; end else res:=13;
        e_wall : if (uconfig_isTronTheme()) then res := 5 else res:=14;
    end;
    udraw_getImageFromImageList := res;
end;

{Rotiert ein Bild
IN bmp               - das zu rotierende Bild
IN position          - Ausrichtung}
procedure udraw_rotateBitmap(bmp: TBitmap; position : TPipePosition);
var
  tmpBmp: TBitmap;
  points: array[0..2] of TPoint;
begin
  tmpBmp:= TBitmap.Create;
  try
    tmpBmp.Assign(bmp);
   case position of
        e_normal:   begin
                    bmp.Width := tmpBmp.Width;
                    bmp.Height := tmpBmp.Height;
                    points[0] := Point(0, 0);
                    points[1] := Point(tmpBmp.Width, 0);
                    points[2] := Point(0, tmpBmp.Height);
                    end;
        e_left:    begin
                    bmp.Width := tmpBmp.Height;
                    bmp.Height := tmpBmp.Width;
                    points[0] := Point(tmpBmp.Height, 0);
                    points[1] := Point(tmpBmp.Height, tmpBmp.Width);
                    points[2] := Point(0, 0);
                    end;
        e_invert:   begin
                    bmp.Width := tmpBmp.Width;
                    bmp.Height := tmpBmp.Height;
                    points[0] := Point(tmpBmp.Width, tmpBmp.Height);
                    points[1] := Point(0, tmpBmp.Height);
                    points[2] := Point(tmpBmp.Height, 0);
                    end;
        e_right:     begin
                    bmp.Width := tmpBmp.Height;
                    bmp.Height := tmpBmp.Width;
                    points[0] := Point(0, tmpBmp.Width);
                    points[1] := Point(0, 0);
                    points[2] := Point(tmpBmp.Height, tmpBmp.Width);
                    end;
        end;

    if PlgBlt(bmp.Canvas.Handle, points, tmpBmp.Canvas.Handle,
      0, 0, tmpBmp.Width, tmpBmp.Height, 0, 0, 0) then ;
    finally
    tmpBmp.Free;
  end;
end;

{Zeichnet ein Bild auf ein anderes Bild
IN bmpBackground     - Hintergrundsbild
IN bmpForeground     - Vordergundgsbild
RETURN               - Neues Bild bestehend aus dem Hinter- und Vordergrundsbild}
function overlayWithTransparentImage (bmpBackground, bmpForeground: TBitmap): TBitmap;
begin
  bmpBackground.Canvas.Brush.Style := bsClear;
  bmpForeground.transparent:= true;
  if Not (uconfig_isTronTheme()) then changeColorOfBitmap(bmpForeground, uconfig_getCS() ,false);
  bmpBackground.Canvas.StretchDraw(Rect(0, 0,120-1, 120-1), bmpForeground);
  overlayWithTransparentImage := bmpBackground
end;

{Ändert die Farbwerte eines Bildes
OUT bmp               - das zu verändernde Bild
IN colorDest          - die einzusetzenden Farbwerte}
procedure changeColorOfBitmap (bmp: TBitmap;colorDest: TColor; invert : Boolean);
type
	PixArray = Array [1..3] of Byte;
var
	p: ^PixArray;
	x,y: Integer;
	rDest,gDest,bDest,        // RGB-Zielfarbe
	rBack, gBack, bBack: byte; // RGB-Hintergrundfarbe

begin
	TColor2RGB (colorDest, rDest,gDest,bDest);
	bmp.PixelFormat:= pf24Bit;
	TColor2RGB (bmp.canvas.Pixels[0,0], rBack, gBack, bBack);
	// das Pixel an 0,0 wird hier als Hintergrundfarbe angenommen
	// andere Entscheidungskriterien sind mцglich

	//invert := invert;

	for y:=0 to bmp.Height-1 do
	begin
		p:= bmp.ScanLine[y];          // Zeile einlesen
		for x:=0 to bmp.Width-1 do    // jedes Pixel prьfen
		begin
			if invert then
        begin
          if (p^[1] = bBack) and (p^[2] = gBack) and (p^[3] = rBack) then
          begin                       // fдrben, wenn Hintergrund
            p^[1]:= bDest;
            p^[2]:= gDest;
            p^[3]:= rDest;
          end;
        end
			else
        begin
          if (p^[1] <> bBack) and (p^[2] <> gBack) and (p^[3] <> rBack) then
          begin                       // fдrben, wenn nicht Hintergrund
            p^[1]:= bDest;
            p^[2]:= gDest;
            p^[3]:= rDest;
          end;
         end;
			inc(p);
		end;
	end;
end;

{Wandelt RGB-Werte in den Typ TColor um
IN r            - Rotwert
IN g            - Grünwert
IN b            - Blauwert
RETURN          - Getypter Farbwert}
function RGB2TColor(const r, g, b: byte): TColor;
begin
  RGB2TColor := (r or (g shl 8) or (b shl 16));
end;

{Wandelt den Typ TColor in RGB-Werte um
IN color        - Farben im typ TColor
OUT r           - der Wert fьr Rot
OUT g           - der Wert fьr Grün
OUT b           - der Wert fьr Blau}
procedure TColor2RGB(const color: TColor; out r,g,b: byte);
begin
  b := Byte(color shr 16);
  g := Byte(color shr 8);
  r := Byte(color);
end;


end.
