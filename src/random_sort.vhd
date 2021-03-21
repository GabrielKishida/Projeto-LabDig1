library ieee;
use ieee.std_logic_1164.all;
entity random_sort is
    port(
        clock     : in  std_logic;
        c_enable  : in  std_logic;
		  r_enable  : in  std_logic;
        c_clear   : in  std_logic;
        r_clear   : in  std_logic;
        dado      : out std_logic_vector(3 downto 0)
    );
end entity;

architecture arch of random_sort is


component contador_2bits is
    port (
        clock : in  std_logic;
        clr   : in  std_logic;
        ld    : in  std_logic;
        ent   : in  std_logic;
        enp   : in  std_logic;
        D     : in  std_logic_vector (1 downto 0);
        Q     : out std_logic_vector (1 downto 0);
        rco   : out std_logic 
    );
end component;

component registrador_4bits is
    port (
        clock   : in  std_logic;
        clear   : in  std_logic;
        enable  : in  std_logic;
        D       : in  std_logic_vector(3 downto 0);
        Q       : out std_logic_vector(3 downto 0)
      );
end component;

    signal sig_select	: std_logic_vector(1 downto 0);
	 signal sig_inreg		: std_logic_vector(3 downto 0);
	 
    begin
	 sig_inreg <=
		"0001" when sig_select = "00" else
		"0010" when sig_select = "01" else
		"0100" when sig_select = "10" else
		"1000" when sig_select = "11";

        contador : contador_2bits
        port map(
            clock => clock,
            clr   => c_clear,
            ld    => c_enable,
            ent   => c_enable,
            enp   => '1',
            D     => "00",
            Q     => sig_select,
            rco   => open
        );

        reg_dado : registrador_4bits
        port map(
            clock  => clock,
            clear  => r_clear,
            enable => r_enable,
            D      => sig_inreg,
            Q      => dado
        );

end architecture;