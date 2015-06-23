ENTITY somador IS
	GENERIC(width: integer := 32);
	PORT	(a,b,cin: in std_logic_vector(width-1 downto 0);
			 saida,cout: out std_logic_vector(width-1 downto 0));
END  somador;

ARCHITECTURE somador_arc OF somador IS
	BEGIN 
	
		saida <= a xor b xor cin;
		cout <= (a and b) or (a and cin) or (b and cin);
END somador_arc	;