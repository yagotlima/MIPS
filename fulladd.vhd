library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY fulladd IS
        GENERIC (width: integer := 32);
        PORT (a,b: in std_logic_vector (width - 1 downto 0);
              saida: out std_logic_vector (width - 1 downto 0));
END fulladd;

ARCHITECTURE fulladd_arc OF fulladd IS
        component somador
        port (a, b, cin: in std_logic; 
				  saida, cout: out std_logic);
        end component;
		  signal carry: std_logic_vector (width downto 0) := (others => '0');
	BEGIN
        stages: for i in width - 1 downto 0 generate
                somador1: somador port map (a(i), b(i), carry(i), saida(i), carry(i + 1));
        end generate;
END fulladd_arc;

