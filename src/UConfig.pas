{------------------------------------------------------------------------------
   Diese Unit dient der Initialisierung von voreingestellten sowie
   benutzerdefinierten Einstellungen.

   Autor: Oleksandr Nosenko, 13.01.13
 ------------------------------------------------------------------------------}

unit UConfig;

interface

uses Vcl.Graphics, Winapi.Windows;

{initialisiert die Standardparameter}
procedure uconfig_init_standard_values();
{speichert die benutzerdefinierte Einstellungen}
procedure uconfig_saving();
{ladet die benutzerdefinierte Einstellungen hoch}
function uconfig_loading(Filename : String) : Boolean;

{Zugriffsroutinen für die Standardparameter}
function uconfig_isTronTheme() : boolean;
procedure uconfig_setTronTheme(flag : Boolean);
function uconfig_isOverflow() : boolean;
procedure uconfig_setOverflow(flag : Boolean);
function uconfig_getCBG() : TColor;
procedure uconfig_setCBG(flag : TColor);
function uconfig_getCEP() : TColor;
procedure uconfig_setCEP(flag : TColor);
function uconfig_getCFP() : TColor;
procedure uconfig_setCFP(flag : TColor);
function uconfig_getCS() : TColor;
procedure uconfig_setCS(flag : TColor);
function uconfig_getCW() : TColor;
procedure uconfig_setCW(flag : TColor);
function uconfig_getGFHeight() : Integer;
procedure uconfig_setGFHeight(flag : Integer);
function uconfig_getGFWidth() : Integer;
procedure uconfig_setGFWidth(flag : Integer);

var
     color_background:TColor;
     color_empty_pipe:TColor;
     color_full_pipe:TColor;
     color_spring:TColor;
     color_wall:TColor;
     tronTheme : Boolean;
     overflow : Boolean;
     GFHeight, GFWidth : Integer;
     wallPercent : Double;
     xStart, yStart : Integer;



implementation

uses
  System.Classes, Vcl.Dialogs, System.SysUtils;

{initialisiert die Standardparameter}
procedure uconfig_init_standard_values();
begin
    uconfig_setTronTheme(true);
    uconfig_setOverflow(false);
    uconfig_setCBG(clBlack);
    uconfig_setCEP(clWhite);
    uconfig_setCFP(clBlue);
    uconfig_setCS(clGreen);
    uconfig_setCW(clYellow);
    uconfig_setGFHeight(5);
    uconfig_setGFWidth(5);
    wallPercent := (2/25) * 100;
end;

{Get Gamefield-Höhe
Return Gamefield-Höhe}
function uconfig_getGFHeight() : Integer;
begin
  uconfig_getGFHeight := GFHeight;
end;

{Set Gamefield-Höhe
In flag : Gamefield-Höhe}
procedure uconfig_setGFHeight(flag : Integer);
begin
   GFHeight := flag;
end;

{Get Gamefield-Breite
Return Gamefield-Breite}
function uconfig_getGFWidth() : Integer;
begin
  uconfig_getGFWidth := GFWidth;
end;

{Set Gamefield-Breite
In flag : Gamefield-Breite}
procedure uconfig_setGFWidth(flag : Integer);
begin
   GFWidth := flag;
end;

{Get Background-Color
Return Background-Color}
function uconfig_getCBG() : TColor;
begin
  uconfig_getCBG := color_background;
end;

{Set Background-Color
In flag : Background-Color}
procedure uconfig_setCBG(flag : TColor);
begin
   color_background := flag;
end;
{Get Empty Pipe-Color
Return Empty Pipe-Color}
function uconfig_getCEP() : TColor;
begin
  uconfig_getCEP := color_empty_pipe;
end;
{Set Empty Pipe-Color
In flag : Empty Pipe-Color}
procedure uconfig_setCEP(flag : TColor);
begin
   color_empty_pipe := flag;
end;
{Get Full Pipe-Color
Return Full Pipe-Color}
function uconfig_getCFP() : TColor;
begin
  uconfig_getCFP := color_full_pipe;
end;
{Set Full Pipe-Color
In flag : Full Pipe-Color}
procedure uconfig_setCFP(flag : TColor);
begin
   color_full_pipe := flag;
end;
{Get Spring-Color
Return Spring-Color}
function uconfig_getCS() : TColor;
begin
  uconfig_getCS := color_spring;
end;
{Set Spring-Color
In flag : Spring-Color}
procedure uconfig_setCS(flag : TColor);
begin
   color_spring := flag;
end;
{Get Wall-Color
Return Wall-Color}
function uconfig_getCW() : TColor;
begin
  uconfig_getCW := color_wall;
end;
{Set Wall-Color
In flag : Wall-Color}
procedure uconfig_setCW(flag : TColor);
begin
   color_wall := flag;
end;
{Get ob TronTheme angeschaltet ist
Return TronTheme}
function uconfig_isTronTheme() : boolean;
begin
  uconfig_isTronTheme := tronTheme;
end;
{Set schaltet TronTheme an oder aus
In flag : isTronTheme}
procedure uconfig_setTronTheme(flag : Boolean);
begin
   tronTheme := flag;
end;
{Get ob OverFlow-Modus angeschaltet ist
Return OverFlow}
function uconfig_isOverflow() : boolean;
begin
  uconfig_isOverflow := overflow;
end;
{Set schaltet OverFlow-Modus an oder aus
In flag : isOverFlow}
procedure uconfig_setOverflow(flag : Boolean);
begin
   overflow := flag;
end;

{speichert benutzerdefinierte Daten in 'Game.cfg'}
procedure uconfig_saving();
var
  InputStream : TFileStream;
begin
  try
    InputStream := TFileStream.Create('Game.cfg', fmCreate);
    try
      InputStream.WriteBuffer(GFHeight, sizeOf(Integer));
      InputStream.WriteBuffer(GFWidth, sizeOf(Integer));
      InputStream.WriteBuffer(overflow, sizeOf(Boolean));
      InputStream.WriteBuffer(tronTheme, sizeOf(Boolean));
      InputStream.WriteBuffer(wallPercent, sizeOf(Double));

      InputStream.WriteBuffer(color_background, sizeOf(TColor));
      InputStream.WriteBuffer(color_empty_pipe, sizeOf(TColor));
      InputStream.WriteBuffer(color_full_pipe, sizeOf(TColor));
      InputStream.WriteBuffer(color_spring, sizeOf(TColor));
      InputStream.WriteBuffer(color_wall, sizeOf(TColor));
    finally
      InputStream.Free;
    end;
  except
    ShowMessage('The configuration cant be saved!');
  end;
end;
{ladet die benutzerdefinierte Einstellungen aus Filename hoch
IN Filename - Pfad zu einer Datei
RETURN ob ein Fehler auftrat}
function uconfig_loading(Filename : String) : Boolean;
var
  OutputStream : TFileStream;
  noErr : Boolean;
begin
  noErr := true;
  try
    OutputStream := TFileStream.Create(Filename, fmOpenRead);
    try
      OutputStream.ReadBuffer(GFHeight, sizeOf(Integer));
      OutputStream.ReadBuffer(GFWidth, sizeOf(Integer));
      OutputStream.ReadBuffer(overflow, sizeOf(Boolean));
      OutputStream.ReadBuffer(tronTheme, sizeOf(Boolean));
      OutputStream.ReadBuffer(wallPercent, sizeOf(Double));

      OutputStream.ReadBuffer(color_background, sizeOf(TColor));
      OutputStream.ReadBuffer(color_empty_pipe, sizeOf(TColor));
      OutputStream.ReadBuffer(color_full_pipe, sizeOf(TColor));
      OutputStream.ReadBuffer(color_spring, sizeOf(TColor));
      OutputStream.ReadBuffer(color_wall, sizeOf(TColor));
    finally
      OutputStream.Free;
    end;
  except
    noErr := false;
  end;
  uconfig_loading := noErr;
end;

end.
