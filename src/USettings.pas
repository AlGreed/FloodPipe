{------------------------------------------------------------------------------
   Unit, die der Verwaltund des Formulares Settings dient.
   Autor: Oleksandr Nosenko, 13.01.13
 ------------------------------------------------------------------------------}
unit USettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, UConfig;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    RowTrackBar: TTrackBar;
    ColTrackBar: TTrackBar;
    GroupBox3: TGroupBox;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    ColorDialog1: TColorDialog;
    RadioButton5: TRadioButton;
    overflowCheckBox: TCheckBox;
    Panel1: TPanel;
    ColorButton: TPanel;
    TronCheckBox: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    WandTrackBar: TTrackBar;
    ApplyButton: TPanel;
    AbortButton: TPanel;
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ColorButtonClick(Sender: TObject);
    procedure TronCheckBoxClick(Sender: TObject);
    procedure overflowCheckBoxClick(Sender: TObject);
    procedure RowTrackBarChange(Sender: TObject);
    procedure ColTrackBarChange(Sender: TObject);
    procedure WandTrackBarChange(Sender: TObject);
    procedure ApplyButtonMouseLeave(Sender: TObject);
    procedure AbortButtonMouseEnter(Sender: TObject);
    procedure AbortButtonMouseLeave(Sender: TObject);
    procedure ApplyButtonMouseEnter(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
    procedure AbortButtonClick(Sender: TObject);

  private
    {Initialisierung der Parameter}
    procedure initParameters();
    {Setzt Fonts bestimmte Colors}
    procedure setColorInBlue();
  public
  end;

var
  Settings: TForm2;
  restart : Boolean;

  tmpTronTheme : Boolean;
  tmpOverflow : Boolean;
  tmpColor_background : TColor;
  tmpColor_empty_pipe : TColor;
  tmpColor_full_pipe : TColor;
  tmpColor_spring : TColor;
  tmpColor_wall : TColor;
  tmpHeight : Integer;
  tmpWidth : Integer;
  tmpWallPercent : Integer;


implementation

{$R *.dfm}

{Aktiviert und schaltet Checkbox1 aus, der für Overflow-Modus verantwortlich ist}
procedure TForm2.overflowCheckBoxClick(Sender: TObject);
begin
    tmpOverflow := overflowCheckBox.Checked;
    restart := true;
    if overflowCheckBox.Checked then
      overflowCheckBox.Font.Color := $00009CFE
      else
      overflowCheckBox.Font.Color := $00DFC36F;
end;

{Aktiviert und schaltet Checkbox2 aus, der für tronTheme-Modus verantwortlich ist}
procedure TForm2.TronCheckBoxClick(Sender: TObject);
begin
    tmpTronTheme := TronCheckBox.Checked;
    //Wenn tronTheme eingeschaltet ist, darf man keine Farbe für Bilder wählen
    RadioButton1.Enabled := Not TronCheckBox.Checked;
    RadioButton2.Enabled := Not TronCheckBox.Checked;
    RadioButton3.Enabled := Not TronCheckBox.Checked;
    RadioButton4.Enabled := Not TronCheckBox.Checked;
    RadioButton5.Enabled := Not TronCheckBox.Checked;
    ColorButton.Enabled := Not TronCheckBox.Checked;;
    if TronCheckBox.Checked then
      TronCheckBox.Font.Color := $00009CFE
    else
      TronCheckBox.Font.Color := $00DFC36F;
end;

procedure TForm2.initParameters();
begin
  {Es werden dummy-Variablen angelegt,
   damit der Spielet seinen Auswahl auch stornieren könnte}
  tmpColor_background := uconfig_getCBG();
  tmpColor_empty_pipe := uconfig_getCEP();
  tmpColor_full_pipe := uconfig_getCFP();
  tmpColor_spring := uconfig_getCS();
  tmpColor_wall := uconfig_getCW();

 // tronTheme;
  tmpTronTheme := uconfig_isTronTheme();
  TronCheckBox.Checked := tmpTronTheme;

  // overflow;
  tmpOverflow := uconfig_isOverflow();
  overflowCheckBox.Checked := tmpOverflow;

  //Trackbars
  tmpHeight := uconfig_getGFHeight();
  RowTrackBar.Position := tmpHeight;
  Label3.Caption := IntToStr(RowTrackBar.Position);

  tmpWidth := uconfig_getGFWidth();
  ColTrackBar.Position := tmpWidth;
  Label4.Caption := IntToStr(ColTrackBar.Position);

  tmpWallPercent := Round(wallPercent);
  WandTrackBar.Position := tmpWallPercent;
  GroupBox2.Caption := 'Wall:' + IntToStr(WandTrackBar.Position) + '%';
  WandTrackBar.SelStart := 8;
  WandTrackBar.SelEnd := WandTrackBar.Position;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin

  initParameters();
  // Panel1 zeigt, welche Farbe für jedes Element des Bildes zugewiesen ist
  Panel1.Color := tmpColor_background;
  Label3.Parent := GroupBox1;
  setColorInBlue();

  RadioButton1.Enabled := Not TronCheckBox.Checked;
  RadioButton2.Enabled := Not TronCheckBox.Checked;
  RadioButton3.Enabled := Not TronCheckBox.Checked;
  RadioButton4.Enabled := Not TronCheckBox.Checked;
  RadioButton5.Enabled := Not TronCheckBox.Checked;
  ColorButton.Enabled := Not TronCheckBox.Checked;

  if tmpTronTheme then
      overflowCheckBox.Font.Color := $00009CFE
      else
      overflowCheckBox.Font.Color := $00DFC36F;
  restart := false;
end;

{Es wird ein ColorDialog aufgerufen, um Farbe des Bildes zu ändern}
procedure TForm2.ColorButtonClick(Sender: TObject);
begin
    if (ColorDialog1.Execute()) then
     begin
      if RadioButton1.Checked then tmpColor_background := ColorDialog1.Color
         else if RadioButton2.Checked then tmpColor_empty_pipe := ColorDialog1.Color
           else if RadioButton3.Checked then tmpColor_full_pipe := ColorDialog1.Color
             else if RadioButton4.Checked then tmpColor_spring := ColorDialog1.Color
               else if RadioButton5.Checked then tmpColor_wall := ColorDialog1.Color;
      Panel1.Color := ColorDialog1.Color;
     end;
end;

{Ok-Button. Es wird zuerst geprüft, ob ein Restart notwendig ist.
die bestimmten Parameter werden nue gesetzt.
das Fenster wird geschlossen}
procedure TForm2.ApplyButtonClick(Sender: TObject);
var
  buttonSelected : Integer;
begin
  buttonSelected := 0;
  if restart then
      buttonSelected := messageDlg('Parameters were changed. The Game will be restarted.', mtWarning, [mbOk,mbCancel], 0);
      if (buttonSelected = mrOk) then begin
                uconfig_setGFHeight(tmpHeight);
                uconfig_setGFWidth(tmpWidth);
                uconfig_setOverflow(overflowCheckBox.Checked);

      end;
      wallPercent := tmpWallPercent;
      uconfig_setCBG(tmpColor_background);
      uconfig_setCEP(tmpColor_empty_pipe);
      uconfig_setCFP(tmpColor_full_pipe);
      uconfig_setCS(tmpColor_spring);
      uconfig_setCW(tmpColor_wall);
      uconfig_setTronTheme(TronCheckBox.Checked);
      Settings.Close;
end;

procedure TForm2.ApplyButtonMouseEnter(Sender: TObject);
begin
   ApplyButton.Caption := '<Apply>';
   ApplyButton.Font.Color := $002EAF3E;
end;

procedure TForm2.ApplyButtonMouseLeave(Sender: TObject);
begin
   ApplyButton.Caption := 'Apply';
   ApplyButton.Font.Color := $00DFC36F;
end;

{Abort-Button: alle Parameter werden auf die alten Werten gesetzt}
procedure TForm2.AbortButtonClick(Sender: TObject);
begin
    restart := false;
    initParameters();
    Settings.Close;
end;

procedure TForm2.AbortButtonMouseEnter(Sender: TObject);
begin
    AbortButton.Caption := '<Abort>';
    AbortButton.Font.Color := clRed;
end;

procedure TForm2.AbortButtonMouseLeave(Sender: TObject);
begin
   AbortButton.Caption := 'Abort';
   AbortButton.Font.Color := $00DFC36F;
end;

procedure TForm2.RadioButton1Click(Sender: TObject);
begin
    Panel1.Color := tmpColor_background;
    Panel1.Repaint;
    setColorInBlue();
    RadioButton1.Font.Color := $00009CFE;
end;

procedure TForm2.RadioButton2Click(Sender: TObject);
begin
    Panel1.Color := tmpColor_empty_pipe;
    Panel1.Repaint;
    setColorInBlue();
    RadioButton2.Font.Color := $00009CFE;
end;

procedure TForm2.RadioButton3Click(Sender: TObject);
begin
    Panel1.Color := tmpColor_full_pipe;
    Panel1.Repaint;
    setColorInBlue();
    RadioButton3.Font.Color := $00009CFE;
end;

procedure TForm2.RadioButton4Click(Sender: TObject);
begin
    Panel1.Color := tmpColor_spring;
    Panel1.Repaint;
    setColorInBlue();
    RadioButton4.Font.Color := $00009CFE;
end;

procedure TForm2.RadioButton5Click(Sender: TObject);
begin
    Panel1.Color := tmpColor_wall;
    Panel1.Repaint;
    setColorInBlue();
    RadioButton5.Font.Color := $00009CFE;
end;

procedure TForm2.RowTrackBarChange(Sender: TObject);
begin
    Label3.Caption := IntToStr(RowTrackBar.Position);
    tmpHeight := RowTrackBar.Position;
    restart := true;
end;

procedure TForm2.ColTrackBarChange(Sender: TObject);
begin
    Label4.Caption := IntToStr(ColTrackBar.Position);
    tmpWidth := ColTrackBar.Position;
    restart := true;
end;

procedure TForm2.WandTrackBarChange(Sender: TObject);
begin
    GroupBox2.Caption := 'Wall:' + IntToStr(WandTrackBar.Position) + '%';
    WandTrackBar.SelStart := 8;
    WandTrackBar.SelEnd := WandTrackBar.Position;
    tmpWallPercent := WandTrackBar.Position;
end;

{Setzt Fonts bestimmte Colors}
procedure TForm2.setColorInBlue();
begin
  RadioButton1.Font.Color := $00DFC36F;
  RadioButton2.Font.Color := $00DFC36F;
  RadioButton3.Font.Color := $00DFC36F;
  RadioButton4.Font.Color := $00DFC36F;
  RadioButton5.Font.Color := $00DFC36F;
end;

end.
