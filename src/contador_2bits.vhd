library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contador_2bits is
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
end contador_2bits;

architecture comportamental of contador_2bits is
  signal IQ: integer range 0 to 3;
begin
  
  process (clock, ent, IQ)
  begin

    if clock'event and clock='1' then
      if clr='0' then   IQ <= 0; 
      elsif ld='0' then IQ <= to_integer(unsigned(D));
      elsif ent='1' and enp='1' then
        if IQ=3 then   IQ <= 0; 
        else            IQ <= IQ + 1; 
        end if;
      else              IQ <= IQ;
      end if;
    end if;
    
    if IQ=3 and ent='1' then rco <= '1'; 
    else                      rco <= '0'; 
    end if;

    Q <= std_logic_vector(to_unsigned(IQ, Q'length));

  end process;
end comportamental;