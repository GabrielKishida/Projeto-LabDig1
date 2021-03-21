library ieee;
use ieee.std_logic_1164.all;

entity comparador_timeout is
  port (
    i_A    : in std_logic_vector(14 downto 0);
    i_B    : in std_logic_vector(14 downto 0);
    i_AEQB : in  std_logic;
    o_AEQB : out std_logic
  );
end entity comparador_timeout;

architecture dataflow of comparador_timeout is
  signal aeqb : std_logic;
begin

  aeqb <= not((i_A(14) xor i_B(14)) or (i_A(13) xor i_B(13)) or (i_A(12) xor i_B(12)) or (i_A(11) xor i_B(11)) or (i_A(10) xor i_B(10)) or (i_A(9) xor i_B(9)) or
              (i_A(8) xor i_B(8)) or (i_A(7) xor i_B(7)) or (i_A(6) xor i_B(6)) or (i_A(5) xor i_B(5)) or
              (i_A(4) xor i_B(4)) or (i_A(3) xor i_B(3)) or (i_A(2) xor i_B(2)) or (i_A(1) xor i_B(1)) or
              (i_A(0) xor i_B(0)));

  o_AEQB <= aeqb and i_AEQB;
  
end architecture dataflow;

    
