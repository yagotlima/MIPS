ENTITY portOR IS
        GENERIC (width: integer := 32);
        PORT (a,b: in std_logic_vector (width - 1 downto 0);
              saida: out std_logic_vector (width - 1 downto 0));
END portOR;

ARCHITECTURE portOR_arc OF portOR IS
	BEGIN 
		portOR: for i in witdh-1 downto 0 generate 
			saida(i)<= a(i) or b(i);
		end generate ;
END portOR_arc;