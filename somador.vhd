LIBRARY	ieee;
USE		ieee.std_logic_1164.all;
ENTITY somador IS
	GENERIC(width: integer := 32);
	PORT	(a,b,cin: in std_logic;
			 saida,cout: out std_logic);
END  somador;

ARCHITECTURE somador_arc OF somador IS
	BEGIN 
	
		saida <= a xor b xor cin;
		cout <= (a and b) or (a and cin) or (b and cin);
END somador_arc	;