------------------------------------------------------------------
-- Arquivo   : unidade_controle.vhd
-- Projeto   : Experiencia 07 - Projeto do Jogo do Desafio da Memória

------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     27/02/2021  1.0     Rafael Yokowo	   criacao
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is 
  port ( 
    clock:     		in  std_logic; 
    reset:     		in  std_logic; 
    jogar:     		in  std_logic;
    fim_uc:    		in  std_logic;
    jog_igual: 		in  std_logic;
    end_igual: 		in  std_logic;
    end_menor: 		in  std_logic;
    end_maior: 		in  std_logic;
    jogada: 			in  std_logic;
	 timeout:			in  std_logic;
	 repete:				in  std_logic;
    conta_um:     	in  std_logic;
	 espera_jogada:	out std_logic;
    escreve:   		out std_logic;
    errou:     		out std_logic;
    acertou:   		out std_logic;
    zera_end:  		out std_logic;
    zera_lim:  		out std_logic;
	 zera_repete:		out std_logic;
    conta_end: 		out std_logic;
	 conta_repete:		out std_logic;
	 conta_to:			out std_logic;
    conta_lim: 		out std_logic;
    pronto:    		out std_logic;
	 registra:			out std_logic;
	 repetindo:			out std_logic;
    db_estado: 		out std_logic_vector(6 downto 0)
  );
end entity;

architecture fsm of unidade_controle is
  type t_estado is (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S);
  signal Eatual, Eprox: t_estado;
  signal end_flag: std_logic;
begin
  -- memoria de estado
  process (clock,reset,Eatual,fim_uc)
  begin
	 --if Eatual=L then
	 -- espera_jogada <= '1';
	 --end if;
	 if Eatual= L and fim_uc='1' then
      end_flag <= '1';
	 elsif Eatual = B or Eatual= A then
		end_flag <= '0';
    end if;
    if reset='1' then
		end_flag <= '0';
      Eatual <= A;
    elsif clock'event and clock = '1' then
      Eatual <= Eprox; 
    end if;
  end process;


  -- logica de proximo estado
  Eprox <=
		A when  Eatual=A and jogar='0' else
		B when  Eatual=A and jogar='1' else
		C when  Eatual=B else
		--D when  Eatual=C else
		D when  Eatual=D and jogada='0' and timeout='0' else
		E when  Eatual=D and jogada='1' else
		F when  Eatual=E else
		K when  Eatual=F and jog_igual='1' and fim_uc='1' and end_flag='1' else
		J when  Eatual=F and jog_igual='0' else
		G when  Eatual=F and jog_igual='1' and fim_uc='0' else
		H when  Eatual=G else
		H when  Eatual=C else
		L when  Eatual=H and (end_igual='1' or fim_uc='1') and end_flag ='0' else
		I when  Eatual=H and end_maior='1' else
		D when  Eatual=H and ((end_menor='1' and fim_uc='0') or end_flag='1') else
		C when  Eatual=I else
		B when  Eatual=K and jogar='1' else
		K when  Eatual=K and jogar='0' else
		B when  Eatual=J and jogar='1' else
		J when  Eatual=J and jogar='0' and repete='0' else
		L when  Eatual=L and jogada='0' and timeout='0' else
		M when  Eatual=L and jogada='1' else
		N when  Eatual=M else
		J when  Eatual=D and timeout='1' else
		J when  Eatual=L and timeout='1' else
		Q when  Eatual=N else
		R when  Eatual=Q else
		S when  Eatual=R and conta_um='1' and end_menor='1' else
		R when  Eatual=R and conta_um='0' and end_menor='1' else
		I when  Eatual=R and end_menor='0' else
		R when  Eatual=S else
		O when  Eatual=J and repete='1' else
		P when  Eatual=O and conta_um='1' and end_igual='0' else
		O when  Eatual=O and conta_um='0' and end_igual='0' else
		O when  Eatual=P  else
		J when  Eatual=O and end_igual='1' else
		A;

  -- logica de saída (maquina de Moore)
  with Eatual select
    zera_end <= '1' when B | C | J | Q,
                '0' when others;

  with Eatual select
    zera_lim <= '1' when B ,
                '0' when others;

  with Eatual select
    conta_end <= '1' when G | P | S,
                 '0' when others;
					  
  with Eatual select
    conta_repete <= '1' when O | R,
                    '0' when others;
  with Eatual select
    zera_repete <=  '1' when J | P | Q | S,
                    '0' when others;
						  
  with Eatual select
    repetindo <=    '1' when O | P | R | S,
                    '0' when others;

  with Eatual select
    conta_lim <= '1' when I,
                 '0' when others;
					  
  with Eatual select
    conta_to <= '1' when D | L ,
                '0' when others;

  with Eatual select
    pronto   <= '1' when J | K | O | P,
                '0' when others;

  with Eatual select
    errou 	 <= '1' when J | O | P,
                '0' when others;

  with Eatual select
    acertou  <= '1' when K,
                '0' when others;
	
  with Eatual select
    registra <= '1' when M | E,
                '0' when others;
  
  with Eatual select
    escreve  <= '1' when N,
                '0' when others;
 
  
  -- saida de depuracao (db_estado)
  with Eatual select
    db_estado <= "0000000" when A,      -- 00 
                 "0000001" when B,      -- 01
                 "0000010" when C,      -- 02
                 "0000011" when D,      -- 03  
                 "0000100" when E,      -- 04 
                 "0000101" when F,      -- 05 
					  "0000110" when G,		 -- 06 
                 "0000111" when H,      -- 07 
                 "0001000" when I,      -- 08 
                 "0001001" when J,      -- 09 
                 "0001010" when K,      -- 0A
                 "0001011" when L,      -- 0B
                 "0001100" when M,      -- 0C
                 "0001101" when N,      -- 0D
					  "0001110" when O,		 -- 0E
                 "0001111" when P,      -- 0F
					  "0010000" when Q,		 -- 10
					  "0010001" when R,		 -- 11
					  "0010010" when S,		 -- 12
                 "1000000" when others; -- 40
					  
	with Eatual select			  
	espera_jogada <= '1' when L,
						  '0' when others;
end fsm;     

	 