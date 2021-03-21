library ieee;
use ieee.std_logic_1164.all;

entity circuito_projeto is
	port (
		-- Entrada
		clock 						: in  std_logic;
		reset 						: in  std_logic;
		iniciar  					: in  std_logic;
		repete						: in  std_logic;
		nivel							: in  std_logic_vector(1 downto 0);
		botoes   					: in  std_logic_vector(3 downto 0);
		-- Saida
		leds 							: out std_logic_vector(3 downto 0);
		espera						: out std_logic;
		fim	   					: out std_logic;
		acertou  					: out std_logic;
		errou 						: out std_logic;
		-- Depuracao
		db_chavesIgualMemoria	: out std_logic;
		db_tem_jogada  			: out std_logic;
		db_contagem 				: out std_logic_vector(6 downto 0);
		db_memoria 					: out std_logic_vector(6 downto 0);
		db_jogada 	   			: out std_logic_vector(6 downto 0);
		db_limite 					: out std_logic_vector(6 downto 0); 
		db_estado 					: out std_logic_vector(6 downto 0);
		db_nivel						: out std_logic_vector(6 downto 0)
	);
	
end entity;

architecture circuito_projeto_arch of circuito_projeto is

	component fluxo_dados
		port(
        	clock       				: in  std_logic;
			escreve						: in  std_logic;
        	zeraL       				: in  std_logic;
        	contaL      				: in  std_logic;
			zeraE							: in  std_logic;
			contaE						: in  std_logic;
			conta_to						: in  std_logic;
			conta_repete				: in  std_logic;
			zera_repete					: in  std_logic;
			repetindo					: in  std_logic;
			registraR					: in  std_logic;
			limpaR						: in  std_logic;
			nivel							: in  std_logic_vector(1 downto 0);
        	botoes      				: in  std_logic_vector(3 downto 0);
        	chavesIgualMemoria      : out std_logic;
			enderecoMenorLimite 		: out std_logic;
			enderecoIgualLimite		: out std_logic;
			enderecoMaiorLimite		: out std_logic;
        	fimE        				: out std_logic;
			fimL        				: out std_logic;
			tem_jogada					: out std_logic;
			conta_um						: out std_logic;
			db_timeout					: out std_logic;
			db_tem_jogada				: out std_logic;
			db_jogada					: out std_logic_vector(3 downto 0);
        	db_contagem 				: out std_logic_vector(3 downto 0);
        	db_memoria  				: out std_logic_vector(3 downto 0);
			db_limite					: out std_logic_vector(3 downto 0);
			db_nivel						: out std_logic_vector(1 downto 0)
		);
		
	end component fluxo_dados;
		
	component unidade_controle
		port( 	
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
			repetindo:		out std_logic;
			db_estado: 		out std_logic_vector(3 downto 0)
		);
		
	end component unidade_controle;
		
	component hexa7seg
     port (
        hexa : in  std_logic_vector(3 downto 0);
        sseg : out std_logic_vector(6 downto 0)
     );
	end component hexa7seg;
	
	-- Sinais de depuracao
	signal s_db_jogada   	: std_logic_vector(3 downto 0);
	signal s_db_contagem 	: std_logic_vector(3 downto 0);
	signal s_db_limite   	: std_logic_vector(3 downto 0);
	signal s_db_memoria  	: std_logic_vector(3 downto 0);
	signal s_db_estado   	: std_logic_vector(3 downto 0);
	signal s_db_nivel			: std_logic_vector(3 downto 0);
	signal s_db_nivel_aux	: std_logic_vector(1 downto 0);
	signal s_db_tem_jogada	: std_logic;
	signal s_db_timeout		: std_logic;
	
	
	-- Sinais intermediarios
	signal sig_repetindo			: std_logic;
	signal sig_tem_jogada	  	: std_logic;
	signal sig_zeraL	        	: std_logic;
	signal sig_contaL	        	: std_logic;
	signal sig_zeraE	        	: std_logic;
	signal sig_contaE	  		  	: std_logic;
	signal sig_registra       	: std_logic;
	signal sig_jogada         	: std_logic;
	signal sig_fimE	        	: std_logic;
	signal sig_jog_igual		  	: std_logic;
	signal sig_end_menor		  	: std_logic;
	signal sig_end_maior		  	: std_logic;
	signal sig_end_igual		  	: std_logic;
	signal sig_escreve		  	: std_logic;
	signal sig_espera			  	: std_logic;
	signal sig_conta_to			: std_logic;
	signal sig_conta_um			: std_logic;
	signal sig_conta_repete		: std_logic;
	signal sig_zera_repete		: std_logic;
	
	

begin

	FD: fluxo_dados
		port map(
			clock       					=> clock,
			escreve							=> sig_escreve,
			zeraL       					=> sig_zeraL,
			contaL      					=> sig_contaL,
			zeraE								=> sig_zeraE,
			contaE							=> sig_contaE,
			conta_to							=> sig_conta_to,
			conta_repete					=> sig_conta_repete,
			zera_repete						=> sig_zera_repete,
			repetindo						=> sig_repetindo,
			registraR						=> sig_registra,
			limpaR							=> reset,
			nivel								=> nivel,
			botoes      					=> botoes,
			chavesIgualMemoria       	=> sig_jog_igual,
			enderecoMenorLimite 			=> sig_end_menor,
			enderecoMaiorLimite			=> sig_end_maior,
			enderecoIgualLimite			=> sig_end_igual,
			fimE        					=> sig_fimE,
			fimL        					=> open,
			tem_jogada						=> s_db_tem_jogada,
			conta_um							=> sig_conta_um,
			db_timeout						=> s_db_timeout,
			db_tem_jogada					=> sig_tem_jogada,
			db_contagem 					=> s_db_contagem,
			db_memoria  					=> s_db_memoria,
			db_jogada						=> s_db_jogada,
			db_limite						=> s_db_limite,
			db_nivel							=> s_db_nivel_aux
			);
	
	UC: unidade_controle
		port map(
			clock				=> clock, 
			reset				=> reset, 
			jogar				=> iniciar,
			fim_uc			=> sig_fimE,
			jog_igual		=> sig_jog_igual,
			end_igual		=> sig_end_igual,
			end_menor		=> sig_end_menor,
			end_maior		=> sig_end_maior,
			jogada			=> s_db_tem_jogada,
			timeout			=> s_db_timeout,
			repete			=> repete,
			conta_um			=> sig_conta_um,
			espera_jogada  => sig_espera,
			escreve			=> sig_escreve,
			errou				=> errou,
			acertou			=> acertou,
			zera_end			=> sig_zeraE,
			zera_lim			=> sig_zeraL,
			zera_repete		=> sig_zera_repete,
			conta_end		=> sig_contaE,
			conta_to			=> sig_conta_to,
			conta_lim		=> sig_contaL,
			conta_repete	=> sig_conta_repete,
			pronto			=> fim,
			registra			=> sig_registra,
			repetindo		=> sig_repetindo,
			db_estado		=> s_db_estado
		
		);
		
	HEX0: hexa7seg
		port map(
			hexa => s_db_contagem,
			sseg => db_contagem
		);
	
	HEX1: hexa7seg
		port map(
			hexa => s_db_memoria,
			sseg => db_memoria
		
		);
		
	HEX2: hexa7seg
		port map(
			hexa => s_db_jogada,
			sseg => db_jogada
		
		);
		
	HEX3: hexa7seg
		port map(
			hexa => s_db_limite,
			sseg => db_limite
		
		);
	
	s_db_nivel <= "00" & s_db_nivel_aux;
	HEX4: hexa7seg
		port map(
			hexa => s_db_nivel,
			sseg => db_nivel
		);
		
	HEX5: hexa7seg
		port map(
			hexa => s_db_estado,
			sseg => db_estado
		);
		
	db_chavesIgualMemoria <= sig_jog_igual;
	leds <= s_db_jogada;
	db_tem_jogada <= sig_tem_jogada;
	espera <= sig_espera;
		

end architecture;