{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2018 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo: Rafael Teno Dias                                }

{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }

{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }

{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/gpl-license.php                           }

{ Daniel Simões de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{        Rua Cel.Aureliano de Camargo, 973 - Tatuí - SP - 18270-170            }

{******************************************************************************}

{$I ACBr.inc}

unit ACBrLibConfig;

interface

uses
  Classes, SysUtils, IniFiles,
  synachar;

type
  EConfigException = class(Exception);

  TNivelLog = (logNenhum, logSimples, logNormal, logCompleto, logParanoico);

  TTipoRelatorioBobina = (tpFortes, tpEscPos);

  { TLogConfig }

  TLogConfig = class
  private
    FNivel: TNivelLog;
    FPath: String;
    procedure SetPath(AValue: String);
  public
    constructor Create;
    procedure DefinirValoresPadroes;
    procedure LerIni(const AIni: TCustomIniFile);
    procedure GravarIni(const AIni: TCustomIniFile);

    property Nivel: TNivelLog read FNivel write FNivel;
    property Path: String read FPath write SetPath;
  end;

  { TSistemaConfig }

  TSistemaConfig = class
  private
    FData: TDateTime;
    FDescricao: String;
    FNome: String;
    FVersao: String;
  public
    constructor Create;
    procedure DefinirValoresPadroes;
    procedure LerIni(const AIni: TCustomIniFile);
    procedure GravarIni(const AIni: TCustomIniFile);

    property Nome: String read FNome write FNome;
    property Versao: String read FVersao write FVersao;
    property Data: TDateTime read FData write FData;
    property Descricao: String read FDescricao write FDescricao;
  end;

  { TProxyConfig }

  TProxyConfig = class
  private
    FPorta: Integer;
    FSenha: String;
    FServidor: String;
    FUsuario: String;
    FChaveCrypt: AnsiString;

    function GetSenha: String;
  public
    constructor Create(AChaveCrypt: AnsiString = ''); virtual;

    procedure DefinirValoresPadroes;
    procedure LerIni(const AIni: TCustomIniFile);
    procedure GravarIni(const AIni: TCustomIniFile);

    property Servidor: String read FServidor write FServidor;
    property Porta: Integer read FPorta write FPorta;
    property Usuario: String read FUsuario write FUsuario;
    property Senha: String read GetSenha write FSenha;
  end;

  { TEmailConfig }

  TEmailConfig = class
  private
    FCodificacao: TMimeChar;
    FConfirmacao: Boolean;
    FConta: String;
    FNome: String;
    FPorta: Integer;
    FSegundoPlano: Boolean;
    FSenha: String;
    FServidor: String;
    FSSL: Boolean;
    FTimeOut: Integer;
    FTLS: Boolean;
    FUsuario: String;
    FChaveCrypt: AnsiString;

    function GetSenha: String;
  public
    constructor Create(AChaveCrypt: AnsiString = ''); virtual;

    procedure DefinirValoresPadroes;
    procedure LerIni(const AIni: TCustomIniFile);
    procedure GravarIni(const AIni: TCustomIniFile);

    property Nome: String read FNome write FNome;
    property Servidor: String read FServidor write FServidor;
    property Conta: String read FConta write FConta;
    property Usuario: String read FUsuario write FUsuario;
    property Senha: String read GetSenha write FSenha;
    property Codificacao: TMimeChar read FCodificacao write FCodificacao;
    property Porta: Integer read FPorta write FPorta;
    property SSL: Boolean read FSSL write FSSL;
    property TLS: Boolean read FTLS write FTLS;
    property Confirmacao: Boolean read FConfirmacao write FConfirmacao;
    property SegundoPlano: Boolean read FSegundoPlano write FSegundoPlano;
    property TimeOut: Integer read FTimeOut write FTimeOut;
  end;

  { TEmpresaConfig }

  TEmpresaConfig = class
  private
    FIdentificador: String;
    FCNPJ: String;
    FEmail: String;
    FNomeFantasia: String;
    FRazaoSocial: String;
    FResponsavel: String;
    FTelefone: String;
    FWebSite: String;
  public
    constructor Create(AIdentificador: String);
    procedure DefinirValoresPadroes;
    procedure LerIni(const AIni: TCustomIniFile);
    procedure GravarIni(const AIni: TCustomIniFile);

    property Identificador: String read FIdentificador;
    property CNPJ: String read FCNPJ write FCNPJ;
    property RazaoSocial: String read FRazaoSocial write FRazaoSocial;
    property NomeFantasia: String read FNomeFantasia write FNomeFantasia;
    property WebSite: String read FWebSite write FWebSite;
    property Email: String read FEmail write FEmail;
    property Telefone: String read FTelefone write FTelefone;
    property Responsavel: String read FResponsavel write FResponsavel;
  end;

  { TLibConfig }

  TLibConfig = class
  private
    FOwner: TObject;
    FEmail: TEmailConfig;
    FIni: TMemIniFile;
    FLog: TLogConfig;
    FNomeArquivo: String;
    FProxyInfo: TProxyConfig;
    FSistema: TSistemaConfig;
    FSoftwareHouse: TEmpresaConfig;
    FEmissor: TEmpresaConfig;
    FChaveCrypt: AnsiString;

    procedure VerificarNomeEPath(Gravando: Boolean);
    procedure DefinirValoresPadroes;
    procedure VerificarSessaoEChave(ASessao, AChave: String);

  protected
    procedure AplicarConfiguracoes; virtual;

    property Owner: TObject read FOwner;

  public
    constructor Create(AOwner: TObject; ANomeArquivo: String = ''; AChaveCrypt: AnsiString = ''); virtual;
    destructor Destroy; override;

    procedure Ler; virtual;
    procedure Gravar; virtual;
    procedure GravarValor(ASessao, AChave, AValor: String);
    function LerValor(ASessao, AChave: String): String;

    property NomeArquivo: String read FNomeArquivo write FNomeArquivo;

    property Log: TLogConfig read FLog;
    property ProxyInfo: TProxyConfig read FProxyInfo;
    property Email: TEmailConfig read FEmail;
    property SoftwareHouse: TEmpresaConfig read FSoftwareHouse;
    property Sistema: TSistemaConfig read FSistema;
    property Emissor: TEmpresaConfig read FEmissor;

    property Ini: TMemIniFile read FIni;
  end;

implementation

uses
  ACBrLibConsts, ACBrLibComum,
  ACBrUtil;

{ TSistemaConfig }

constructor TSistemaConfig.Create;
begin
  inherited Create;
  DefinirValoresPadroes;
end;

procedure TSistemaConfig.DefinirValoresPadroes;
begin
  FData := 0;
  FDescricao := '';
  FNome := '';
  FVersao := '';
end;

procedure TSistemaConfig.LerIni(const AIni: TCustomIniFile);
begin
  FNome := AIni.ReadString(CSessaoSistema, CChaveNome, FNome);
  FVersao := AIni.ReadString(CSessaoSistema, CChaveVersao, FVersao);
  FData := AIni.ReadDateTime(CSessaoSistema, CChaveData, FData);
  FDescricao := AIni.ReadString(CSessaoSistema, CChaveDescricao, FDescricao);
end;

procedure TSistemaConfig.GravarIni(const AIni: TCustomIniFile);
begin
  AIni.WriteString(CSessaoSistema, CChaveNome, FNome);
  AIni.WriteString(CSessaoSistema, CChaveVersao, FVersao);
  AIni.WriteDateTime(CSessaoSistema, CChaveData, FData);
  AIni.WriteString(CSessaoSistema, CChaveDescricao, FDescricao);
end;

{ TProxyConfig }

constructor TProxyConfig.Create(AChaveCrypt: AnsiString);
begin
  inherited Create;
  FChaveCrypt := AChaveCrypt;
  DefinirValoresPadroes;
end;

procedure TProxyConfig.DefinirValoresPadroes;
begin
  FServidor := '';
  FPorta := 0;
  FUsuario := '';
  FSenha := '';
end;

function TProxyConfig.GetSenha: String;
begin
  Result := B64CryptToString(FSenha, FChaveCrypt);
end;

procedure TProxyConfig.LerIni(const AIni: TCustomIniFile);
begin
  FServidor := AIni.ReadString(CSessaoProxy, CChaveServidor, FServidor);
  FPorta := AIni.ReadInteger(CSessaoProxy, CChavePorta, FPorta);
  FUsuario := AIni.ReadString(CSessaoProxy, CChaveUsuario, FUsuario);
  FSenha := AIni.ReadString(CSessaoProxy, CChaveSenha, '');
end;

procedure TProxyConfig.GravarIni(const AIni: TCustomIniFile);
begin
  AIni.WriteString(CSessaoProxy, CChaveServidor, FServidor);
  AIni.WriteInteger(CSessaoProxy, CChavePorta, FPorta);
  AIni.WriteString(CSessaoProxy, CChaveUsuario, FUsuario);
  AIni.WriteString(CSessaoProxy, CChaveSenha, StringToB64Crypt(FSenha, FChaveCrypt));
end;

{ TEmailConfig }

constructor TEmailConfig.Create(AChaveCrypt: AnsiString);
begin
  inherited Create;
  FChaveCrypt := AChaveCrypt;
  DefinirValoresPadroes;
end;

procedure TEmailConfig.DefinirValoresPadroes;
begin
  FNome := '';
  FServidor := '';
  FConta := '';
  FUsuario := '';
  FSenha := '';
  FCodificacao := UTF_8;
  FPorta := 0;
  FSSL := False;
  FTLS := False;
  FConfirmacao := False;
  FSegundoPlano := False;
  FTimeOut := 0;
end;

function TEmailConfig.GetSenha: String;
begin
  Result := B64CryptToString(FSenha, FChaveCrypt);
end;

procedure TEmailConfig.LerIni(const AIni: TCustomIniFile);
begin
  FNome := AIni.ReadString(CSessaoEmail, CChaveNome, FNome);
  FServidor := AIni.ReadString(CSessaoEmail, CChaveServidor, FServidor);
  FConta := AIni.ReadString(CSessaoEmail, CChaveEmailConta, FConta);
  FUsuario := AIni.ReadString(CSessaoEmail, CChaveUsuario, FUsuario);
  FSenha := AIni.ReadString(CSessaoEmail, CChaveSenha, '');
  FCodificacao := TMimeChar(AIni.ReadInteger(CSessaoEmail, CChaveEmailCodificacao, Integer(FCodificacao)));
  FPorta := AIni.ReadInteger(CSessaoEmail, CChavePorta, FPorta);
  FSSL := AIni.ReadBool(CSessaoEmail, CChaveEmailSSL, FSSL);
  FTLS := AIni.ReadBool(CSessaoEmail, CChaveEmailTLS, FTLS);
  FTimeOut := AIni.ReadInteger(CSessaoEmail, CChaveTimeOut, FTimeOut);
  FConfirmacao := AIni.ReadBool(CSessaoEmail, CChaveEmailConfirmacao, FConfirmacao);
  FSegundoPlano := AIni.ReadBool(CSessaoEmail, CChaveEmailSegundoPlano, FSegundoPlano);
end;

procedure TEmailConfig.GravarIni(const AIni: TCustomIniFile);
begin
  AIni.WriteString(CSessaoEmail, CChaveNome, FNome);
  AIni.WriteString(CSessaoEmail, CChaveServidor, FServidor);
  AIni.WriteString(CSessaoEmail, CChaveEmailConta, FConta);
  AIni.WriteString(CSessaoEmail, CChaveUsuario, FUsuario);
  AIni.WriteString(CSessaoEmail, CChaveSenha, StringToB64Crypt(FSenha, FChaveCrypt));
  AIni.WriteInteger(CSessaoEmail, CChaveEmailCodificacao, Integer(FCodificacao));
  AIni.WriteInteger(CSessaoEmail, CChavePorta, FPorta);
  AIni.WriteBool(CSessaoEmail, CChaveEmailSSL, FSSL);
  AIni.WriteBool(CSessaoEmail, CChaveEmailTLS, FTLS);
  AIni.WriteInteger(CSessaoEmail, CChaveTimeOut, FTimeOut);
  AIni.WriteBool(CSessaoEmail, CChaveEmailConfirmacao, FConfirmacao);
  AIni.WriteBool(CSessaoEmail, CChaveEmailSegundoPlano, FSegundoPlano);
end;

{ TEmpresaConfig }

constructor TEmpresaConfig.Create(AIdentificador: String);
begin
  inherited Create;

  FIdentificador := AIdentificador;
  DefinirValoresPadroes;
end;

procedure TEmpresaConfig.DefinirValoresPadroes;
begin
  FCNPJ := '';
  FRazaoSocial := '';
  FNomeFantasia := '';
  FWebSite := '';
  FEmail := '';
  FTelefone := '';
  FResponsavel := '';
end;

procedure TEmpresaConfig.LerIni(const AIni: TCustomIniFile);
begin
  CNPJ := OnlyNumber(AIni.ReadString(FIdentificador, CChaveCNPJ, CNPJ));
  RazaoSocial := AIni.ReadString(FIdentificador, CChaveRazaoSocial, RazaoSocial);
  NomeFantasia := AIni.ReadString(FIdentificador, CChaveNomeFantasia, NomeFantasia);
  WebSite := AIni.ReadString(FIdentificador, CChaveWebSite, WebSite);
  Email := AIni.ReadString(FIdentificador, CChaveEmail, Email);
  Telefone := AIni.ReadString(FIdentificador, CChaveTelefone, Telefone);
  Responsavel := AIni.ReadString(FIdentificador, CChaveResponsavel, Responsavel);
end;

procedure TEmpresaConfig.GravarIni(const AIni: TCustomIniFile);
begin
  AIni.WriteString(FIdentificador, CChaveCNPJ, CNPJ);
  AIni.WriteString(FIdentificador, CChaveRazaoSocial, RazaoSocial);
  AIni.WriteString(FIdentificador, CChaveNomeFantasia, NomeFantasia);
  AIni.WriteString(FIdentificador, CChaveWebSite, WebSite);
  AIni.WriteString(FIdentificador, CChaveEmail, Email);
  AIni.WriteString(FIdentificador, CChaveTelefone, Telefone);
  AIni.WriteString(FIdentificador, CChaveRazaoSocial, RazaoSocial);
  AIni.WriteString(FIdentificador, CChaveResponsavel, Responsavel);
end;

{ TLogConfig }

constructor TLogConfig.Create;
begin
  inherited Create;
  DefinirValoresPadroes;
end;

procedure TLogConfig.DefinirValoresPadroes;
begin
  FNivel := logNenhum;
  FPath := ApplicationPath;
end;

procedure TLogConfig.SetPath(AValue: String);
begin
  if (FPath = AValue) then
    Exit;

  FPath := PathWithoutDelim(ExtractFilePath(AValue));
end;

procedure TLogConfig.LerIni(const AIni: TCustomIniFile);
begin
  FNivel := TNivelLog(AIni.ReadInteger(CSessaoPrincipal, CChaveLogNivel, Integer(FNivel)));
  FPath := AIni.ReadString(CSessaoPrincipal, CChaveLogPath, FPath);
end;

procedure TLogConfig.GravarIni(const AIni: TCustomIniFile);
begin
  AIni.WriteInteger(CSessaoPrincipal, CChaveLogNivel, Integer(Nivel));
  AIni.WriteString(CSessaoPrincipal, CChaveLogPath, Path);
end;

{ TLibConfig }

constructor TLibConfig.Create(AOwner: TObject; ANomeArquivo: String; AChaveCrypt: AnsiString);
begin
  if not (AOwner is TACBrLib) then
    raise EConfigException.Create(SErrLibDono);

  inherited Create;
  FOwner := AOwner;
  FNomeArquivo := Trim(ANomeArquivo);
  VerificarNomeEPath(True);

  if Length(AChaveCrypt) = 0 then
    FChaveCrypt := CLibChaveCrypt
  else
    FChaveCrypt := AChaveCrypt;

  TACBrLib(FOwner).GravarLog(ClassName + '.Create(' + FNomeArquivo + ', ' +
    StringOfChar('*', Length(FChaveCrypt)) + ' )', logCompleto);

  FLog := TLogConfig.Create;
  FSistema := TSistemaConfig.Create;
  FEmail := TEmailConfig.Create(FChaveCrypt);
  FProxyInfo := TProxyConfig.Create(FChaveCrypt);
  FSoftwareHouse := TEmpresaConfig.Create(CSessaoSwHouse);
  FEmissor := TEmpresaConfig.Create(CSessaoEmissor);

  FIni := TMemIniFile.Create(FNomeArquivo);

  DefinirValoresPadroes;

  TACBrLib(FOwner).GravarLog(ClassName + '.Create - Feito', logParanoico);
end;

destructor TLibConfig.Destroy;
begin
  TACBrLib(FOwner).GravarLog(ClassName + '.Destroy', logCompleto);

  FIni.Free;
  FLog.Free;
  FSistema.Free;
  FEmissor.Free;
  FSoftwareHouse.Free;
  FProxyInfo.Free;
  FEmail.Free;

  inherited Destroy;

  TACBrLib(FOwner).GravarLog(ClassName + '.Destroy - Feito', logParanoico);
end;

procedure TLibConfig.VerificarNomeEPath(Gravando: Boolean);
var
  APath: String;
begin
  if EstaVazio(FNomeArquivo) then
    FNomeArquivo := ApplicationPath + CNomeArqConf;

  APath := ExtractFilePath(FNomeArquivo);
  if NaoEstaVazio(APath) then
  begin
    if (not DirectoryExists(APath)) then
      raise EConfigException.CreateFmt(SErrDiretorioInvalido, [APath]);
  end
  else
    FNomeArquivo := ApplicationPath + ExtractFileName(FNomeArquivo);

  if (not Gravando) and (not FileExists(FNomeArquivo)) then
    raise EConfigException.Create(Format(SErrArquivoNaoExiste, [FNomeArquivo]));
end;

procedure TLibConfig.DefinirValoresPadroes;
begin
  TACBrLib(FOwner).GravarLog(ClassName + '.DefinirValoresPadroes', logParanoico);

  FLog.DefinirValoresPadroes;
  FSistema.DefinirValoresPadroes;
  FEmail.DefinirValoresPadroes;
  FProxyInfo.DefinirValoresPadroes;
  FSoftwareHouse.DefinirValoresPadroes;
  FEmissor.DefinirValoresPadroes;
end;

procedure TLibConfig.VerificarSessaoEChave(ASessao, AChave: String);
var
  NaoExiste: String;
begin
  if not FIni.SectionExists(ASessao) then
    raise EConfigException.Create(SErrConfSessaoNaoExiste);

  NaoExiste := '*NaoExiste*';
  if (FIni.ReadString(ASessao, AChave, NaoExiste) = NaoExiste) then
    raise EConfigException.Create(SErrConfChaveNaoExiste);
end;

procedure TLibConfig.AplicarConfiguracoes;
begin
  TACBrLib(FOwner).GravarLog(ClassName + '.AplicarConfiguracoes: ' + FNomeArquivo, logCompleto);
end;

procedure TLibConfig.Ler;
begin
  TACBrLib(FOwner).GravarLog(ClassName + '.Ler: ' + FNomeArquivo, logCompleto);
  VerificarNomeEPath(False);

  DefinirValoresPadroes;

  FLog.LerIni(FIni);
  FSistema.LerIni(FIni);
  FEmail.LerIni(FIni);
  FProxyInfo.LerIni(FIni);
  FSoftwareHouse.LerIni(FIni);
  FEmissor.LerIni(FIni);

  TACBrLib(FOwner).GravarLog(ClassName + '.Ler - Feito', logParanoico);
end;

procedure TLibConfig.Gravar;
begin
  TACBrLib(FOwner).GravarLog(ClassName + '.Gravar: ' + FNomeArquivo, logCompleto);
  VerificarNomeEPath(True);

  FLog.GravarIni(FIni);
  FSistema.GravarIni(FIni);
  FEmail.GravarIni(FIni);
  FProxyInfo.GravarIni(FIni);
  FSoftwareHouse.GravarIni(FIni);
  FEmissor.GravarIni(FIni);

  FIni.UpdateFile;

  TACBrLib(FOwner).GravarLog(ClassName + '.Gravar - Feito', logParanoico);
end;

procedure TLibConfig.GravarValor(ASessao, AChave, AValor: String);
begin
  VerificarSessaoEChave(ASessao, AChave);
  FIni.WriteString(ASessao, AChave, AValor);
  AplicarConfiguracoes;
end;

function TLibConfig.LerValor(ASessao, AChave: String): String;
begin
  VerificarSessaoEChave(ASessao, AChave);
  Result := FIni.ReadString(ASessao, AChave, '');
end;

end.
