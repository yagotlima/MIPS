ENTITY ALU IS
	
	GENERIC(width: integer := 32);
	PORT	(a,b: in std_logic_vector(width-1 downto 0);
			 operacao:in std_logic_vector(2 downto 0);
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
   component mux4
      generic (width: integer := 32);
      port (x0, x1, x2, x3 in std_logic_vector (width - 1 downto 0);
            sel: in std_logic_vector (2 downto 0);
            output: out std_logic_vector (width - 1 downto 0));
end component;
      signal s0,s1,s2,s3: std_logic_vector (width - 1 downto 0);
      BEGIN
			and1: portAND generic map (width) port map (a, b, s0);
         or1: portOR generic map (width) port map (a, b, s1);
         asomador: fulladd generic map (width) port map (a, b, s2);
         sub: sub generic map (width) port map (a, b, s3);
         slt: slt generic map (width) port map (a, b, s4);
         mux: mux4 generic map (width) port map (s0, s1, s2, s3, sel, saida);
END alu_arc;

