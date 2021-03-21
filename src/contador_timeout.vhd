----------------------------------------------------------------
-- Arquivo   : contador_163.vhd
-- Projeto   : Experiencia 01 - Primeiro Contato com VHDL
----------------------------------------------------------------
-- Descricao : contador binario hexadecimal (modulo 16) 
--             similar ao CI 74163
----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     29/12/2020  1.0     Edson Midorikawa  criacao
----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contador_timeout is
   port (
        clock : in  std_logic;
        clr   : in  std_logic;
        ld    : in  std_logic;
        ent   : in  std_logic;
        enp   : in  std_logic;
        D     : in  std_logic_vector (14 downto 0);
        Q     : out std_logic_vector (14 downto 0);
        rco   : out std_logic 
   );
end contador_timeout;

architecture comportamental of contador_timeout is
  signal IQ: integer range 0 to 18000;
begin
  
  process (clock, ent, IQ)
  begin

    if clock'event and clock='1' then
      if clr='0' then   IQ <= 0; 
      elsif ld='0' then IQ <= to_integer(unsigned(D));
      elsif ent='1' and enp='1' then
        if IQ=18000 then   IQ <= 0; 
        else            IQ <= IQ + 1; 
        end if;
      else              IQ <= IQ;
      end if;
    end if;
    
    if IQ=18000 and ent='1' then rco <= '1'; 
    else                      rco <= '0'; 
    end if;

    Q <= std_logic_vector(to_unsigned(IQ, Q'length));

  end process;
end comportamental;
