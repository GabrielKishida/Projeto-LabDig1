library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados is
    port(
        	clock       					: in  std_logic;
			escreve							: in  std_logic;
        	zeraL       					: in  std_logic;
        	contaL      					: in  std_logic;
			zeraE								: in  std_logic;
			contaE							: in  std_logic;
			conta_to							: in  std_logic;
			conta_repete					: in  std_logic;
			zera_repete						: in  std_logic;
			repetindo						: in  std_logic;
			registraR						: in  std_logic;
			limpaR							: in  std_logic;
			nivel								: in  std_logic_vector(1 downto 0);
        	botoes      					: in  std_logic_vector(3 downto 0);
        	chavesIgualMemoria       	: out std_logic;
			enderecoMenorLimite 			: out std_logic;
			enderecoIgualLimite			: out std_logic;
			enderecoMaiorLimite			: out std_logic;
        	fimE        					: out std_logic;
			fimL        					: out std_logic;
			tem_jogada						: out std_logic;
			conta_um							: out std_logic;
			db_timeout						: out std_logic;
			db_tem_jogada					: out std_logic;
			db_jogada						: out std_logic_vector(3 downto 0);
        	db_contagem 					: out std_logic_vector(3 downto 0);
        	db_memoria  					: out std_logic_vector(3 downto 0);
			db_limite						: out std_logic_vector(3 downto 0);
			db_nivel							: out std_logic_vector(1 downto 0);
			db_random						: out std_logic_vector(3 downto 0)
    );

end fluxo_dados;

architecture estrutural of fluxo_dados is

    component contador_163
        port(
        	clock : in  std_logic;
        	clr   : in  std_logic;
        	ld    : in  std_logic;
        	ent   : in  std_logic;
        	enp   : in  std_logic;
        	D     : in  std_logic_vector (3 downto 0);
        	Q     : out std_logic_vector (3 downto 0);
        	rco   : out std_logic 
        );
    end component contador_163;

    component ram_16x4
        port (
			clk			 : in  std_logic;
         endereco     : in  std_logic_vector(3 downto 0);
         dado_entrada : in  std_logic_vector(3 downto 0);
         we           : in  std_logic;
         ce           : in  std_logic;
         dado_saida   : out std_logic_vector(3 downto 0)
        );
    end component ram_16x4;

    component comparador_85
        port(
    		i_A     : in  std_logic_vector(3 downto 0);
    		i_B     : in  std_logic_vector(3 downto 0);
    		i_AGTB  : in  std_logic;
    		i_ALTB  : in  std_logic;
    		i_AEQB  : in  std_logic;
    		o_AGTB  : out std_logic;
    		o_ALTB  : out std_logic;
    		o_AEQB  : out std_logic;
			o_BLETA : out std_logic
        );
    end component comparador_85;
	 
	 component contador_timeout
        port(
        	clock : in  std_logic;
        	clr   : in  std_logic;
        	ld    : in  std_logic;
        	ent   : in  std_logic;
        	enp   : in  std_logic;
        	D     : in  std_logic_vector (14 downto 0);
        	Q     : out std_logic_vector (14 downto 0);
        	rco   : out std_logic 
        );
    end component contador_timeout;
	 
	 component contador_1s
        port(
        	clock : in  std_logic;
        	clr   : in  std_logic;
        	ld    : in  std_logic;
        	ent   : in  std_logic;
        	enp   : in  std_logic;
        	D     : in  std_logic_vector (9 downto 0);
        	Q     : out std_logic_vector (9 downto 0);
        	rco   : out std_logic 
        );
    end component contador_1s;
	 
	 component comparador_timeout
        port(
			 i_A    : in std_logic_vector(14 downto 0);
			 i_B    : in std_logic_vector(14 downto 0);
			 i_AEQB : in  std_logic;
			 o_AEQB : out std_logic
        );
	 end component comparador_timeout;
	 
	 component edge_detector
		  port (
		    clock  : in  std_logic;
			 reset  : in  std_logic;
			 sinal  : in  std_logic;
			 pulso  : out std_logic
		  );
	 end component edge_detector;
	
	component registrador_4bits
		port (
			clock:  in  std_logic;
			clear:  in  std_logic;
			enable: in  std_logic;
			D:      in  std_logic_vector(3 downto 0);
			Q:      out std_logic_vector(3 downto 0)
		);
	end component registrador_4bits;
	
	component nivel_select is
		port (
			clock				: in  std_logic;
			clear				: in  std_logic;
			enable			: in  std_logic;
			nivel				: in  std_logic_vector(1 downto 0);
			limite			: out std_logic_vector(3 downto 0);
			limite_timeout	: out std_logic_vector(14 downto 0);
			db_nivel			: out std_logic_vector(1 downto 0)
		);
	end component nivel_select;
	
	component random_sort is
    port(
        clock     : in  std_logic;
        dado      : out std_logic_vector(3 downto 0)
    );
	 end component random_sort;

	signal s_cont_timeout  	: std_logic_vector(14 downto 0);
	signal s_limite_timeout : std_logic_vector(14 downto 0);
	signal s_dado     	  	: std_logic_vector(3 downto 0);
   signal s_endereco 	  	: std_logic_vector(3 downto 0);
	signal s_jogada	  	  	: std_logic_vector(3 downto 0);
	signal s_limite  	  	  	: std_logic_vector(3 downto 0);
	signal s_nivel_limite	: std_logic_vector(3 downto 0);
	signal s_random			: std_logic_vector(3 downto 0);
	signal s_or_botoes	  	: std_logic;
	signal s_tem_jogada	  	: std_logic;
	signal s_not_zeraE	  	: std_logic;
	signal s_not_zeraL	  	: std_logic;
	signal s_not_escreve	  	: std_logic;
	signal s_not_clear_to  	: std_logic;
	signal s_not_zera_repete: std_logic;
	signal s_conta_repete	: std_logic;
	
	begin
	
	 s_or_botoes <= botoes(0) or botoes(1) or botoes(2) or botoes(3);
	 
	 JogadaDetector : edge_detector
	 port map(
			clock => clock,
			reset => limpaR,
			sinal => s_or_botoes,
			pulso => s_tem_jogada
	 );
	
	 RegBotoes : registrador_4bits
	 port map(
	 		clock  => clock,
			clear  => contaL,
			enable => registraR,
			D      => botoes,
			Q      => s_jogada

	 );
	
	s_not_zeraE <= not(zeraE);
    ContEnd : contador_163
    port map(
	      clock => clock,
        	clr   => s_not_zeraE,
        	ld    => '1',
        	ent   => '1',
        	enp   => contaE,
        	D     => "0000",
        	Q     => s_endereco,
        	rco   => open
    );
	 
	 s_not_zeraL <= not(zeraL);
    ContLmt : contador_163
    port map(
	      clock => clock,
        	clr   => s_not_zeraL,
        	ld    => '1',
        	ent   => '1',
        	enp   => contaL,
        	D     => "0000",
        	Q     => s_limite,
        	rco   => fimL
    );
	
	s_not_escreve <= not(escreve);
    MemJog : ram_16x4
    port map(
			clk			 => clock,
         endereco     => s_endereco,
         dado_entrada => s_random,
         we           => s_not_escreve,
         ce           => '0',
         dado_saida   => s_dado
    );

    CompLmt : comparador_85 
    port map(
    		i_A     => s_limite,
    		i_B     => s_endereco,
    		i_AGTB  => '0',
    		i_ALTB  => '0',
    		i_AEQB  => '1',
    		o_AGTB  => enderecoMenorLimite,
    		o_ALTB  => enderecoMaiorLimite,
    		o_AEQB  => enderecoIgualLimite,
			o_BLETA => open
	);
	 
	 CompJog : comparador_85
    port map(
    		i_A     => s_dado,
    		i_B     => s_jogada,
    		i_AGTB  => '0',
    		i_ALTB  => '0',
    		i_AEQB  => '1',
    		o_AGTB  => open,
    		o_ALTB  => open,
    		o_AEQB  => chavesIgualMemoria,
			o_BLETA => open
        );
		  
	 s_not_clear_to <= not(registraR);
	 contador_to : contador_timeout
	 port map(
	     clock => clock,
        clr   => s_not_clear_to,
        ld    => '1',
        ent   => '1',
        enp   => conta_to,
        D     => "000000000000000",
        Q     => s_cont_timeout,
        rco   => open 
	 );
	 s_not_zera_repete <= not(zera_repete);
	 contador_repete : contador_1s
	 port map(
	     clock => clock,
        clr   => s_not_zera_repete,
        ld    => '1',
        ent   => '1',
        enp   => conta_repete,
        D     => "0000000000",
        Q     => open,
        rco   => conta_um 
	 );
	 
	 comparador_to : comparador_timeout
	 port map(
    	i_A    => s_limite_timeout,
    	i_B    => s_cont_timeout,
    	i_AEQB => '1',
    	o_AEQB => db_timeout
	 );
	 
	 CompNivel : comparador_85
	 port map(
			i_A     => s_endereco,
    		i_B     => s_nivel_limite,
    		i_AGTB  => '0',
    		i_ALTB  => '0',
    		i_AEQB  => '1',
    		o_AGTB  => open,
    		o_ALTB  => open,
    		o_AEQB  => fimE,
			o_BLETA => open
    );
	 
	 limite_select : nivel_select
	 port map(
		clock		=> clock,
		clear		=> '0',
		enable	=> zeraL,
		nivel		=> nivel,
		limite	=> s_nivel_limite,
		limite_timeout => s_limite_timeout,
		db_nivel	=> db_nivel
	 );
	 
	 gerador_aleatorio : random_sort
	 port map(
		clock		=> clock,
		dado		=> s_random
	 );

	 db_random <= s_random;
	 
	 tem_jogada  <= s_tem_jogada;
	 db_limite   <= s_limite;
	 db_jogada   <= s_jogada when repetindo = '0' and zera_repete='0' else
						 s_dado when repetindo = '1' and zera_repete='0' else
						 "0000";
	 db_contagem <= s_endereco;
	 db_memoria	 <= s_dado;
	 db_tem_jogada <= s_or_botoes;


end architecture;