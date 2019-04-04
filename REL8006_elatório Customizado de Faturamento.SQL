-- Relatório Customizado de Faturamento
SELECT  N.NUMNOTA as "Nota Fiscal",
        N.SERIE as "Série",
        N.NUMPED as "Pedido",
        N.CODCLI as "Cód.Cliente",
        N.CLIENTE as "Cliente", 
        PCREDECLIENTE.DESCRICAO as "Rede",
        PCATIVI.RAMO as "Atividade",
        C.MUNICENT as "Cidade",
        C.ESTENT as "Estado",
        PCEMPR.NOME as "Emitente",
        PCUSUARI.NOME as "RCA",
        C.PERCOMCLI as "Comissão",
        (M.QTCONT * NVL(M.VLFRETE, 0)) as "Vl.Frete",
        N.FRETEDESPACHO as "TP Frete",
        N.TRANSPORTADORA as "Transportadora",
        PCPEDC.TIPOCARGA as "TP Carga",
        M.CODPROD as "Cód. Produto",
        M.DESCRICAO as "Produto",
        M.EMBALAGEM as "Embalagem",
        PCPEDC.DATA as "Data Pedido",
        N.DTSAIDA as "Data Faturamento",
        M.QTCONT as "Qtdade",
        M.PUNITCONT - NVL(M.ST, 0) as "Vl.Unitário",
        (M.QTCONT * NVL(M.ST, 0)) as "Vl.ST",
        (M.QTCONT * (M.PUNITCONT)) as "Vl.Total",
        M.CODFISCAL CFOP,
        N.CODCOB as "Cód.Cobrança",
        N.COBRANCA as "Cobrança",
        N.CODPLPAG as "Cód.Pl.Pag.",
        PCPLPAG.DESCRICAO as "Plano Pag."
FROM PCNFSAID N, 
     PCMOV M, 
     PCMOVCOMPLE MC, 
     PCCLIENT C,
     PCREDECLIENTE,
     PCUSUARI,
     PCEMPR,
     PCPEDC,
     PCPLPAG,
     PCATIVI
WHERE PCUSUARI.CODUSUR = N.CODUSUR
  AND M.NUMTRANSVENDA = N.NUMTRANSVENDA 
  AND M.NUMTRANSITEM = MC.NUMTRANSITEM(+) 
  AND M.NUMNOTA = N.NUMNOTA 
  AND N.CODCLI = C.CODCLI 
  AND NVL(N.CODFILIALNF, N.CODFILIAL) = :CODFILIAL 
  AND N.DTSAIDA BETWEEN :DATA1 AND :DATA2  
  AND M.CODFISCAL BETWEEN 5000 AND 7999 
  AND N.ESPECIE IN ('NF', 'NC', 'CP', 'CT', 'CO') 
  AND M.QTCONT > 0 
  AND M.STATUS IN ('A', 'AB') 
  AND M.DTCANCEL IS NULL 
  AND N.DTCANCEL IS NULL
  AND PCREDECLIENTE.CODREDE = C.CODREDE
  AND PCEMPR.MATRICULA = N.CODEMITENTEPEDIDO
  AND PCPEDC.NUMPED = N.NUMPED
  AND PCPLPAG.CODPLPAG = N.CODPLPAG
  AND C.CODATV1 = PCATIVI.CODATIV
  AND N.CODCOB <> 'BNF'