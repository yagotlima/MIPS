LIBRARY	ieee;
USE		ieee.std_logic_1164.all;

ENTITY slt IS
	GENERIC(width: integer := 32);
	PORT	(a,b: in std_logic_vector(width-1 downto 0);
			 saida: out std_logic_vector(width-1 downto 0));
END  slt;
		 
ARCHITECTURE SLT_ARC OF slt IS
		component sub
			generic(width: integer := 32);
			port(a,b: in std_logic_vector(width-1 downto 0);
					saida: out std_logic_vector(width-1 downto 0));
		end component;
      signal output: std_logic_vector (width - 1 downto 0) := (others => '0');
      signal subx: std_logic_vector (width - 1 downto 0);

      BEGIN

          sub1: sub generic map (width) port map (a, b, subx);
          output(0) <= subx (width - 1);
          saida <= output;

END SLT_ARC;