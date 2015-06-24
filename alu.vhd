LIBRARY	ieee;
USE		ieee.std_logic_1164.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY ALU IS
	
	GENERIC(width: integer := 32);
	PORT	(a,b: in std_logic_vector(width-1 downto 0);
			 sel:in std_logic_vector(2 downto 0);
			 saida: out std_logic_vector(width-1 downto 0));
END ALU;

ARCHITECTURE alu_arc OF alu IS

	component fulladd 
		generic (width: integer := 32);
		port (a, b: in std_logic_vector (width - 1 downto 0);
				saida: out std_logic_vector (width - 1 downto 0));
   end component;
	
	component portOR
		generic (width: integer := 32);
		port (a, b: in std_logic_vector (width - 1 downto 0);
				saida: out std_logic_vector (width - 1 downto 0));
   end component;
	
	component portAND
		generic (width: integer := 32);
		port (a, b: in std_logic_vector (width - 1 downto 0);
				saida: out std_logic_vector (width - 1 downto 0));
   end component;
	
	component sub
		generic (width: integer := 32);
		port (a, b: in std_logic_vector (width - 1 downto 0);
				saida: out std_logic_vector (width - 1 downto 0));
   end component;	
	
   component slt
		generic (width: integer := 32);
		port (a, b: in std_logic_vector (width - 1 downto 0);
				saida: out std_logic_vector (width - 1 downto 0));
   end component;  
	
	  component mux
       generic (width: integer := 32);
       port (s0, s1, s2,s3, s4: in std_logic_vector (width - 1 downto 0);
       sel: in std_logic_vector (2 downto 0);
       saida: out std_logic_vector (width - 1 downto 0));
end component;

	

   signal s0,s1,s2,s3,s4: std_logic_vector (width - 1 downto 0);
      BEGIN
			and1: portAND generic map (width) port map (a, b, s0);
         or1: portOR generic map (width) port map (a, b, s1);
         asomador: fulladd generic map (width) port map (a, b, s2);
         sub1: sub generic map (width) port map (a, b, s3);
         slt1: slt generic map (width) port map (a, b, s4);
			multx: mux generic map (width) port map (s0, s1, s2, s3, s4,sel, saida);

			
										       
END alu_arc;

