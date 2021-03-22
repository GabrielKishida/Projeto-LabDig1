library ieee;
use ieee.std_logic_1164.all;

entity nivel_select is
	port (
    clock			: in  std_logic;
	 clear			: in  std_logic;
    enable			: in  std_logic;
    nivel			: in  std_logic_vector(1 downto 0);
    limite			: out std_logic_vector(3 downto 0);
	 limite_timeout: out std_logic_vector(14 downto 0);
	 db_nivel		: out std_logic_vector(1 downto 0)
	);
end entity;

architecture arch of nivel_select is

	component registrador_2bits is
		port (
			clock:  in  std_logic;
			clear:  in  std_logic;
			enable: in  std_logic;
			D:      in  std_logic_vector(1 downto 0);
			Q:      out std_logic_vector(1 downto 0)
		);
	end component;
	
	signal s_nivel		: std_logic_vector(1 downto 0);


begin
	
	limite <=
		"0011" when	s_nivel = "00" else
		"0111" when s_nivel = "01" else
		"1011" when s_nivel = "10" else
		"1111" when s_nivel = "11" else
		"1111";
		
	limite_timeout <=
		"100001001101000" when s_nivel = "00" else
		"010111011100000" when s_nivel = "01" else
		"001111101000000" when s_nivel = "10" else
		"000111110100000" when s_nivel = "11" else
		"111111111111111";
		
	NIVEL_REG: registrador_2bits
		port map(
			clock				=> clock,
			clear				=> clear,
			enable			=> enable,
			D					=> nivel,
			Q					=> s_nivel
		);
		
	db_nivel <= s_nivel;
	

end architecture;