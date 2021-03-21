library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_bit.all;

entity tb_cenario_erro is
end entity;

architecture tb of tb_cenario_erro is
	component circuito_projeto
	port(
		  -- Entrada
		  clock : in std_logic;
		  reset : in std_logic;
		  iniciar : in std_logic;
		  repete  : in  std_logic;
		  nivel	  : in  std_logic_vector(1 downto 0);
		  botoes : in std_logic_vector(3 downto 0);
		  -- Saida
		  leds : out std_logic_vector(3 downto 0);
		  espera : out std_logic;
		  fim : out std_logic;
		  acertou : out std_logic;
		  errou : out std_logic;
		  -- Depuracao
		  db_chavesIgualMemoria	: out std_logic;
		  db_tem_jogada : out std_logic;
		  db_jogada 	: out std_logic_vector(6 downto 0);
		  db_contagem 	: out std_logic_vector(6 downto 0);
		  db_memoria 	: out std_logic_vector(6 downto 0);
		  db_limite 	: out std_logic_vector(6 downto 0); 
		  db_estado 	: out std_logic_vector(6 downto 0);
		  db_nivel	 	: out std_logic_vector(6 downto 0) 
	);
	end component;
	type arranjo_memoria is array(0 to 15) of std_logic_vector(3 downto 0);
	signal memoria : arranjo_memoria := 
		(
			"0001",
			"0010",
			"0100",
			"1000",
			"0100",
			"0010",
			"0001",
			"0001",
			"0010",
			"0010",
			"0100",
			"0100",
			"1000",
			"1000",
			"0100",
			"0001" 
		);
  
	constant tb_Period 		: time := 1000 ns;
	signal tb_simulation 	: std_logic := '0';
	signal tb_buttonOnWait	: integer := 10;
	signal tb_buttonOffWait	: integer := 15;
	signal tb_zero			: std_logic_vector(3 downto 0) := "0000";

	signal clock, reset, iniciar, repete, fim, espera, acertou, errou 	: std_logic;
	signal nivel														: std_logic_vector(1 downto 0);
	signal botoes, leds 								 				: std_logic_vector(3 downto 0);
	signal db_tem_jogada, db_chavesIgualMemoria 							    : std_logic;
	signal db_jogada, db_contagem, db_memoria, db_limite, db_estado, db_nivel 	: std_logic_vector(6 downto 0);

begin
	DUT: circuito_semana1 port map 
	(
		clock			=>	clock,
		reset			=>	reset,
		iniciar			=>	iniciar,
		repete			=> 	repete,
		nivel			=>  nivel,
		botoes			=>	botoes,
		leds			=>	leds,
		espera			=>  espera,
		fim				=>	fim,
		acertou			=>	acertou,
		errou			=>	errou,
		db_chavesIgualMemoria	=> db_chavesIgualMemoria,
		db_tem_jogada	=>	db_tem_jogada,
		db_jogada		=> 	db_jogada, 
		db_contagem		=> 	db_contagem, 
		db_memoria		=> 	db_memoria, 
		db_limite		=> 	db_limite, 
		db_estado		=> 	db_estado,
		db_nivel		=>	db_nivel
	);
	
	clock <= not clock after tb_period/2 when tb_simulation = '1' else '0';
	stimuli: process
	begin
		tb_simulation <= '1';
			
			-- Condicoes iniciais
				nivel <= "10";
				repete <= '0';
				iniciar <= '0';
				botoes <= tb_zero;
				reset <= '1';
				wait for tb_period*5;
				reset <= '0';
				wait for tb_period*5;
				
				--Inicio
				iniciar <= '1';
				wait for tb_period*5;
				iniciar <= '0';
				wait for tb_period*5;
				
				--Teste ate o 3 e errar
				for i in 0 to 3 loop
					for j in 0 to i loop
						botoes <= memoria(j);
						wait for tb_buttonOnWait * tb_period;
						botoes <= tb_zero;
						wait for tb_buttonOffWait * tb_period;
					end loop;
				end loop;
	
				botoes <= "1000";
				wait for tb_buttonOnWait * tb_period;
				botoes <= tb_zero;
				wait for 100 * tb_period;
	
				botoes <= "0000";
	
				repete <= '1';
				wait for 3*tb_period;
				repete <= '0';
				wait for 6000*tb_period;
				tb_simulation <= '0';
		wait;
	end process;
		
end architecture;
