library ieee;
use ieee.std_logic_1164.all;

entity logic_unit is
    port(
        a  : in  std_logic_vector(31 downto 0);
        b  : in  std_logic_vector(31 downto 0);
        op : in  std_logic_vector(1 downto 0);
        r  : out std_logic_vector(31 downto 0)
    );
end logic_unit;

architecture synth of logic_unit is
begin

    r <= a nor b WHEN op="00" else
         a and b WHEN op="01" else
         a or  b WHEN op="10" else
         a xnor b WHEN op="11" else
         (OTHERS => '0') ; 
end synth;
