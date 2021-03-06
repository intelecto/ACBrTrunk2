{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2007 Andrews Ricardo Bejatto                }
{                                       Anderson Rogerio Bejatto               }
{                                                                              }
{ Colaboradores nesse arquivo:          Daniel Simooes de Almeida              }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrETQZplII;

interface

uses
  Classes,
  ACBrETQClass, ACBrDevice;

type

  { TACBrETQZplII }

  TACBrETQZplII = class(TACBrETQClass)
  private
    function FormatarTexto(aTexto: String): String;

    function ConverterOrientacao(aOrientacao: TACBrETQOrientacao): String;

    function ComandoCoordenadas(aVertical, aHorizontal: Integer): String;
    function ComandoReverso(aImprimirReverso: Boolean): String;
    function ComandoOrientcao(aOrientacao: TACBrETQOrientacao): String;
    function ComandoFonte(aFonte: String; aMultVertical, aMultHorizontal: Integer): String;

    function ComandoBarras(aTipo: String; aOrientacao: TACBrETQOrientacao;
      aAlturaBarras: Integer; aExibeCodigo: TACBrETQBarraExibeCodigo): String;
    function ConverterExibeCodigo(aExibeCodigo: TACBrETQBarraExibeCodigo): String;

    function ComandoLinhaCaixa(aAltura, aLargura, Espessura: Integer): String;
    function AjustarNomeArquivoImagem( aNomeImagem: String): String;
    function ConverterMultiplicadorImagem(aMultiplicador: Integer): String;
  protected
    function ComandoAbertura: AnsiString; override;
    function ComandoUnidade: AnsiString; override;
    function ComandoTemperatura: AnsiString; override;
    function ComandoResolucao: AnsiString; override;
    function ComandoVelocidade: AnsiString; override;
    function ComandoBackFeed: AnsiString; override;

  public
    constructor Create(AOwner: TComponent);

    function TratarComandoAntesDeEnviar(aCmd: AnsiString): AnsiString; override;

    function ComandoLimparMemoria: AnsiString; override;
    function ComandoCopias(const NumCopias: Integer): AnsiString; override;
    function ComandoImprimir: AnsiString; override;
    function ComandoAvancarEtiqueta(const aAvancoEtq: Integer): AnsiString; override;

    function ComandoImprimirTexto(aOrientacao: TACBrETQOrientacao; aFonte: String;
      aMultHorizontal, aMultVertical, aVertical, aHorizontal: Integer; aTexto: String;
      aSubFonte: Integer = 0; aImprimirReverso: Boolean = False): AnsiString; override;

    function ConverterTipoBarras(TipoBarras: TACBrTipoCodBarra): String; override;
    function ComandoImprimirBarras(aOrientacao: TACBrETQOrientacao; aTipoBarras: String;
      aBarraLarga, aBarraFina, aVertical, aHorizontal: Integer; aTexto: String;
      aAlturaBarras: Integer; aExibeCodigo: TACBrETQBarraExibeCodigo = becPadrao
      ): AnsiString; override;

    function ComandoImprimirLinha(aVertical, aHorizontal, aLargura, aAltura: Integer
      ): AnsiString; override;

    function ComandoImprimirCaixa(aVertical, aHorizontal, aLargura, aAltura, aEspVertical,
      aEspHorizontal: Integer): AnsiString; override;

    function ComandoImprimirImagem(aMultImagem, aVertical, aHorizontal: Integer;
      aNomeImagem: String): AnsiString; override;

    function ComandoCarregarImagem(aStream: TStream; aNomeImagem: String;
      aFlipped: Boolean; aTipo: String): AnsiString; override;
  end;

implementation

uses
  math, {$IFNDEF COMPILER6_UP} ACBrD5, Windows, {$ENDIF} sysutils, strutils,
  ACBrUtil, ACBrConsts, synautil;

{ TACBrETQPpla }

constructor TACBrETQZplII.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'ZPLII';
  fpLimiteCopias := 999;
end;

function TACBrETQZplII.ComandoLimparMemoria: AnsiString;
begin
  Result := '^MCY';
end;

function TACBrETQZplII.FormatarTexto(aTexto: String): String;
var
  ConvTexto: String;
begin
  ConvTexto := aTexto;
  if (pos('\', ConvTexto) > 0) then
    ConvTexto := StringReplace(ConvTexto, '\', '\x5C', [rfReplaceAll]);

  if (pos('^', ConvTexto) > 0) then
    ConvTexto := StringReplace(ConvTexto, '^', '\x5E', [rfReplaceAll]);

  if (pos('~', ConvTexto) > 0) then
    ConvTexto := StringReplace(ConvTexto, '~', '\x7E', [rfReplaceAll]);

  ConvTexto := BinaryStringToString(ConvTexto);
  ConvTexto := StringReplace(ConvTexto, '\x', '\', [rfReplaceAll]);

  Result := '^FD' + ConvTexto + '^FS';

  if (ConvTexto <> aTexto) then
    Result := '^FH\' + Result;
end;

function TACBrETQZplII.ComandoFonte(aFonte: String; aMultVertical,
  aMultHorizontal: Integer): String;
var
  cFonte: Char;
begin
  if (aMultVertical > 10) then
    raise Exception.Create('Multiplicador Vertical deve estar entre 1 e 10');

  if (aMultHorizontal > 10) then
    raise Exception.Create('Multiplicador Horizontal deve estar entre 1 e 10');

  cFonte := PadLeft(aFonte,1,'A')[1];
  if not CharInSet(cFonte, ['0'..'9','A'..'Z']) then
    raise Exception.Create('Fonte deve "0" a "9" e "A" a "Z"');

  Result := '^CF' + cFonte +
                   IntToStr(Max(aMultVertical,1))     + ',' +
                   IntToStr(Max(aMultHorizontal,1));
end;

function TACBrETQZplII.ComandoCoordenadas(aVertical, aHorizontal: Integer
  ): String;
begin
  if (aVertical < 0) or (aVertical > 32000) then
    raise Exception.Create('Vertical deve estar entre 0 e 32000');

  if (aHorizontal < 0) or (aHorizontal > 32000) then
    raise Exception.Create('Horizontal deve estar entre 0 e 32000');

  Result := '^FO' + IntToStr(aHorizontal) + ',' + IntToStr(aVertical);
end;

function TACBrETQZplII.ComandoReverso(aImprimirReverso: Boolean): String;
begin
  if aImprimirReverso then
    Result := '^FR'
  else
    Result := '';
end;

function TACBrETQZplII.ComandoOrientcao(aOrientacao: TACBrETQOrientacao
  ): String;
begin
  Result := '^FW'+ConverterOrientacao(aOrientacao);
end;

function TACBrETQZplII.ComandoLinhaCaixa(aAltura, aLargura, Espessura: Integer
  ): String;
var
  AlturaDots, LarguraDots, EspessuraDots: Integer;
begin
  AlturaDots    := ConverterUnidade(etqDots, aAltura);
  LarguraDots   := ConverterUnidade(etqDots, aLargura);
  EspessuraDots := Max(ConverterUnidade(etqDots, Espessura), 1);

  Result := '^GB' + IntToStr(LarguraDots)   + ',' +
                    IntToStr(AlturaDots)    + ',' +
                    IntToStr(EspessuraDots) + ',' +
                    'B'                     + ',' +
                    '0'                     +
            '^FS';
end;

function TACBrETQZplII.AjustarNomeArquivoImagem(aNomeImagem: String): String;
begin
  Result := UpperCase(LeftStr(OnlyAlphaNum(aNomeImagem), 8));
end;

function TACBrETQZplII.ConverterMultiplicadorImagem(aMultiplicador: Integer
  ): String;
begin
  aMultiplicador := max(aMultiplicador,1);
  if (aMultiplicador > 10) then
    raise Exception.Create('Multiplicador Imagem deve ser de 1 a 10');

  Result := IntToStr(aMultiplicador);
end;

function TACBrETQZplII.ConverterExibeCodigo(
  aExibeCodigo: TACBrETQBarraExibeCodigo): String;
begin
  if (aExibeCodigo = becSIM) then
    Result := 'Y'
  else
    Result := 'N';
end;

function TACBrETQZplII.ConverterOrientacao(aOrientacao: TACBrETQOrientacao
  ): String;
begin
  case aOrientacao of
    or270: Result := 'B';  // 270
    or180: Result := 'I';  // 180
    or90:  Result := 'R';  // 90
  else
    Result := 'N';  // Normal
  end;
end;

function TACBrETQZplII.ComandoBarras(aTipo: String;
  aOrientacao: TACBrETQOrientacao; aAlturaBarras: Integer;
  aExibeCodigo: TACBrETQBarraExibeCodigo): String;
var
  cTipo: Char;
begin
  cTipo := PadLeft(aTipo,1)[1];
  if not CharInSet(cTipo, ['0'..'9','A'..'Z']) then
    raise Exception.Create('Tipo Cod.Barras deve estar "0" a "9" ou "A" a "Z"');

  Result := '^B' + aTipo +
            ConverterOrientacao(aOrientacao)                   + ',' +
            IntToStr(ConverterUnidade(etqDots, aAlturaBarras)) + ',' +
            ConverterExibeCodigo(aExibeCodigo)                 + ',' +
            'N';
end;

function TACBrETQZplII.ComandoAbertura: AnsiString;
begin
  Result := '^XA';
end;

function TACBrETQZplII.ComandoUnidade: AnsiString;
//var
//  a: Char;
begin
  //case Unidade of
  //  etqDots       : a := 'D';
  //  etqPolegadas  : a := 'I';
  //else
  //  a := 'M';
  //end;
  //
  //Result := '^MU'+d;
  Result := '';  // Todos os comandos s�o convertidos para etqDots;
end;

function TACBrETQZplII.ComandoTemperatura: AnsiString;
begin
  if (Temperatura < 0) or (Temperatura > 30) then
    raise Exception.Create('Temperatura deve ser de 0 a 30');

  Result := '~SD' + IntToStrZero(Temperatura, 2);
end;

function TACBrETQZplII.ComandoResolucao: AnsiString;
var
  aCmdRes: Char;
begin

  case DPI of
    dpi600: aCmdRes := 'A'; // A = 24 dots/mm, 12 dots/mm, 8 dots/mm or 6 dots/mm
  else
    aCmdRes := 'B';
  end;

  Result := '^JM'+aCmdRes+'^FS';
end;

function TACBrETQZplII.ComandoVelocidade: AnsiString;
begin
  if (Velocidade > 12) then
    raise Exception.Create('Velocidade deve ser de 2 a 12 ');

  if (Velocidade > 0) then
    Result := '^PR' + IntToStr(Max(Velocidade,2))
  else
    Result := EmptyStr;
end;

function TACBrETQZplII.ComandoBackFeed: AnsiString;
begin
  case fpBackFeed of
    bfOn : Result := '~JSN';
    bfOff: Result := '~JSO';
  else
    Result := EmptyStr;
  end;
end;

function TACBrETQZplII.ComandoCopias(const NumCopias: Integer): AnsiString;
begin
  Result := EmptyStr;
  inherited ComandoCopias(NumCopias);

  Result := '^PQ' + IntToStr(Max(NumCopias,1));
end;

function TACBrETQZplII.ComandoImprimir: AnsiString;
begin
  Result := '^XZ';
end;

function TACBrETQZplII.ComandoAvancarEtiqueta(const aAvancoEtq: Integer
  ): AnsiString;
begin
  if (aAvancoEtq > 0) then
    Result := '^PH'
  else
    Result := EmptyStr;
end;

function TACBrETQZplII.TratarComandoAntesDeEnviar(aCmd: AnsiString): AnsiString;
begin
  Result := ChangeLineBreak( aCmd, CRLF );
end;

function TACBrETQZplII.ComandoImprimirTexto(aOrientacao: TACBrETQOrientacao;
  aFonte: String; aMultHorizontal, aMultVertical, aVertical,
  aHorizontal: Integer; aTexto: String; aSubFonte: Integer;
  aImprimirReverso: Boolean): AnsiString;
begin
  if (Length(aTexto) > 255) then
    raise Exception.Create(ACBrStr('Tamanho m�ximo para o texto 255 caracteres'));

  Result := ComandoFonte(aFonte, aMultVertical, aMultHorizontal) + sLineBreak +
            ComandoOrientcao(aOrientacao) + sLineBreak +
            ComandoCoordenadas(aVertical, aHorizontal) +
            ComandoReverso(aImprimirReverso) +
            FormatarTexto(aTexto);
end;

function TACBrETQZplII.ConverterTipoBarras(TipoBarras: TACBrTipoCodBarra
  ): String;
begin
  case TipoBarras of
    barEAN13      : Result := 'E';
    barEAN8       : Result := '8';
    barSTANDARD   : Result := 'J';
    barINTERLEAVED: Result := '2';
    barCODE128    : Result := 'C';
    barCODE39     : Result := '3';
    barCODE93     : Result := 'A';
    barUPCA       : Result := 'U';
    barCODABAR    : Result := 'K';
    barMSI        : Result := 'M';
    barCODE11     : Result := '1';
  else
    Result := '';
  end;
end;

function TACBrETQZplII.ComandoImprimirBarras(aOrientacao: TACBrETQOrientacao;
  aTipoBarras: String; aBarraLarga, aBarraFina, aVertical,
  aHorizontal: Integer; aTexto: String; aAlturaBarras: Integer;
  aExibeCodigo: TACBrETQBarraExibeCodigo): AnsiString;
begin
  Result := ComandoCoordenadas(aVertical, aHorizontal) +
            ComandoBarras(aTipoBarras, aOrientacao, aAlturaBarras, aExibeCodigo ) +
            FormatarTexto(aTexto);
end;

function TACBrETQZplII.ComandoImprimirLinha(aVertical, aHorizontal, aLargura,
  aAltura: Integer): AnsiString;
begin
  Result := ComandoCoordenadas(aVertical, aHorizontal) +
            ComandoLinhaCaixa(aAltura, aLargura, Min(aAltura, aLargura) );
end;

function TACBrETQZplII.ComandoImprimirCaixa(aVertical, aHorizontal, aLargura,
  aAltura, aEspVertical, aEspHorizontal: Integer): AnsiString;
begin
  Result := ComandoCoordenadas(aVertical, aHorizontal) +
            ComandoLinhaCaixa(aAltura, aLargura, Max(aEspVertical, aEspHorizontal) )+
            '^FS';
end;

function TACBrETQZplII.ComandoImprimirImagem(aMultImagem, aVertical,
  aHorizontal: Integer; aNomeImagem: String): AnsiString;
begin
  Result := ComandoCoordenadas(aVertical, aHorizontal) +
            '^XGR:'                                    +
            AjustarNomeArquivoImagem(aNomeImagem)      +
            '.GRF'                                     + ',' +
            ConverterMultiplicadorImagem(aMultImagem)  + ',' +
            ConverterMultiplicadorImagem(aMultImagem);
end;

function TACBrETQZplII.ComandoCarregarImagem(aStream: TStream;
  aNomeImagem: String; aFlipped: Boolean; aTipo: String): AnsiString;
var
  b, x: Char;
  Data: AnsiString;
begin
  aTipo := UpperCase(LeftStr(aTipo,3));

  b := 'B';

  if (aTipo = 'PCX') then
    x := 'X'
  else if (aTipo = 'GRF') then
    x := 'G'
  else if (aTipo = 'BMP') then
    x := 'B'
  else if (aTipo = 'PNG') then
  begin
    x := 'P';
    b := 'P';
  end
  else
    raise Exception.Create(ACBrStr(
      'Formato de Imagem deve ser Monocrom�tico e do atipo: BMP, PCX, GRF ou PNG'));

  aStream.Position := 0;
  Data := ReadStrFromStream(aStream, aStream.Size);

  if b <> 'B' then
    Data := AsciiToHex(Data);

  aStream.Position := 0;
  Result := '~DYR:' +
            AjustarNomeArquivoImagem(aNomeImagem) + ',' +
            b                                     + ',' +
            x                                     + ',' +
            IntToStr(aStream.Size)                + ',' +
            '0,' + Data;
end;

end.


