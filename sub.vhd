LIBRARY	ieee;
USE		ieee.std_logic_1164.all;
ENTITY sub IS
	
	GENERIC(width: integer := 32);
	PORT	(a,b: in std_logic_vector(width-1 downto 0);
			saida,cout: out std_logic_vector(width-1 downto 0));
end sub;

ARCHITECTURE sub_arc OF sub IS
        component somador
        port (a, b, cin: in std_logic; 
				  saida, cout: out std_logic);
        end component;
		  signal carry: std_logic_vector (width downto 0) := (others => '0');
		  signal	compb: std_logic_vector(width-1 downto 0);
	BEGIN
		  compb <= not b;	
        stages: for i in width - 1 downto 0 generate
                somador1: somador port map (a(i), b(i), carry(i), saida(i), carry(i + 1));
					 
        end generate;
END sub_arc;