LIBRARY	ieee;
USE		ieee.std_logic_1164.all;

entity mux4 is
	generic(
		LARGURA	: natural := 1
	);

	port(
		a, b, c, d	: in  STD_LOGIC_VECTOR(LARGURA - 1 downto 0);
		sel			: in  STD_LOGIC_VECTOR(1 downto 0);
		q				: out STD_LOGIC_VECTOR(LARGURA - 1 downto 0)
	);
end entity;

architecture mux4_arch of mux4 is
begin
	with sel select
		q <= a when "00",
			  b when "01",
			  c when "10",
			  d when others;
end;
