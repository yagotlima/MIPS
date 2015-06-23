ENTITY portAND IS
        GENERIC (width: integer := 32);
        PORT (a,b: in std_logic_vector (width - 1 downto 0);
              saida: out std_logic_vector (width - 1 downto 0));
END portAND;

ARCHITECTURE portAND_arc OF portAND IS
	BEGIN 
		portAND: for i in witdh-1 downto 0 generate 
			saida(i)<= a(i) and b(i);
		end generate ;
END portAND_arc;