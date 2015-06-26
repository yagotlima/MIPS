LIBRARY	ieee;
USE		ieee.std_logic_1164.all;
ENTITY sub IS
	
	GENERIC(width: integer := 32);
	PORT	(a,b: in std_logic_vector(width-1 downto 0);
			saida,cout: out std_logic_vector(width-1 downto 0));
end sub;

ARCHITECTURE sub_arc OF sub IS
        component fulladd IS
        generic (width: integer := 32);
        port (a,b: in std_logic_vector (width - 1 downto 0);
              saida: out std_logic_vector (width - 1 downto 0));
        end component;
		  signal carry: std_logic_vector (width downto 0) := (others => '0');
		  signal	negb: std_logic_vector(width-1 downto 0);
		  signal	compb: std_logic_vector(width-1 downto 0);
	BEGIN
		  negb <= not b;
		  add1: fulladd port map(negb, x"00_00_00_01", compb);
		  add2: fulladd port map(a, compb, saida);
END sub_arc;