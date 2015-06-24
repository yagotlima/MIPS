library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mux is
        generic (width: integer := 32);
        port (s0,s1,s2,s3,s4: in std_logic_vector (width - 1 downto 0);
                sel: in std_logic_vector (3 downto 0);
                saida: out std_logic_vector (width - 1 downto 0));
end mux;

architecture mux_arc of mux is

        signal unknown: std_logic_vector (width - 1 downto 0) := (others => 'X');

begin

        
        saida <= s0 when sel = "0000" else
                s1 when sel = "0001" else
                s2 when sel = "0010" else
                s3 when sel = "0110" else
                s4 when sel = "0111" else
                unknown;

end mux_arc;
