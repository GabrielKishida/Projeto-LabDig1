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
    db_estado: 		out std_logic_vector(3 downto 0)
  );
end entity;

architecture fsm of unidade_controle is
  type t_estado is (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P);
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
		I when  Eatual=N else
		O when  Eatual=J and repete='1' else
		P when  Eatual=O and conta_um='1' and end_igual='0' else
		O when  Eatual=O and conta_um='0' and end_igual='0' else
		O when  Eatual=P  else
		J when  Eatual=O and end_igual='1' else
		A;

  -- logica de saída (maquina de Moore)
  with Eatual select
    zera_end <= '0' when A | D | E | F | G | H | I | K | L | M | N | O | P ,
                '1' when B | C | J,
                '0' when others;

  with Eatual select
    zera_lim <= '0' when A | C | D | E | F | G | H | I | J | K | L | M | N | O | P,
                '1' when B ,
                '0' when others;

  with Eatual select
    conta_end <= '0' when A | B | C | D | E | F | H | I | J | K | L | M | N | O,
                 '1' when G | P,
                 '0' when others;
					  
  with Eatual select
    conta_repete <= '0' when A | B | C | D | E | F | G | H | I | J | K | L | M | N | P,
                    '1' when O,
                    '0' when others;
  with Eatual select
    zera_repete <=  '0' when A | B | C | D | E | F | G | H | I | K | L | M | N | O,
                    '1' when J | P,
                    '0' when others;
						  
  with Eatual select
    repetindo <=    '0' when A | B | C | D | E | F | G | H | I | J | K | L | M | N ,
                    '1' when O | P,
                    '0' when others;

  with Eatual select
    conta_lim <= '0' when A | B | C | D | E | F | G | H | J | K | L | M | N | O | P,
                 '1' when I,
                 '0' when others;
					  
  with Eatual select
    conta_to <= '0'  when A | B | C | E | F | G | H | I | J | K | M | N | O | P,
                '1' when D | L ,
                '0' when others;

  with Eatual select
    pronto   <= '0' when A | B | C | D | E | F | G | H | I | L | M | N,
                '1' when J | K | O | P,
                '0' when others;

  with Eatual select
    errou 	 <= '0' when A | B | C | D | E | F | G | H | I | K | L | M | N ,
                '1' when J | O | P,
                '0' when others;

  with Eatual select
    acertou  <= '0' when A | B | C | D | E | F | H | I | J | L | M | N | O | P,
                '1' when K,
                '0' when others;
	
  with Eatual select
    registra <= '0' when A | B | C | D | F | G | H | I | J | K | L | N | O | P,
                '1' when M | E,
                '0' when others;
  
  with Eatual select
    escreve  <= '0' when A | B | C | D | E | F | G | H | I | J | K | L | M | O | P,
                '1' when N,
                '0' when others;
  
  -- saida de depuracao (db_estado)
  with Eatual select
    db_estado <= "0000" when A,      -- 0 40
                 "0001" when B,      -- 1 79
                 "0010" when C,      -- 2 24
                 "0011" when D,      -- 3 30 
                 "0100" when E,      -- 4 19
                 "0101" when F,      -- 5 12
					  "0110" when G,		 -- 6 02
                 "0111" when H,      -- 7 78
                 "1000" when I,      -- 8 00
                 "1001" when J,      -- 9 
                 "1010" when K,      -- A
                 "1011" when L,      -- B
                 "1100" when M,      -- C
                 "1101" when N,      -- D
					  "1110" when O,		 -- E
                 "1111" when P,      -- F
                 "0000" when others;
					  
	with Eatual select			  
	espera_jogada <= '1' when L,
						  '0' when others;
end fsm;     

	 