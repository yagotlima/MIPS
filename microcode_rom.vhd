LIBRARY	ieee;
USE		ieee.std_logic_1164.all;

entity microcode_rom is
	generic(
		DATA_WIDTH : natural := 18;
		ADDR_WIDTH : natural := 4
	);

	port(
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		q		: out STD_LOGIC_VECTOR((DATA_WIDTH -1) downto 0)
	);
end entity;

architecture microcode_rom_arch of microcode_rom is
begin
	with addr select
		q <= "00" & x"2148" when 16#0#,
			  "00" & x"6002" when 16#1#,
			  "00" & x"C003" when 16#2#,
			  "00" & x"0300" when 16#3#,
			  "00" & x"1401" when 16#4#,
			  "00" & x"0281" when 16#5#,
			  "10" & x"8000" when 16#6#,
			  "00" & x"1801" when 16#7#,
			  "01" & x"8015" when 16#8#,
			  "00" & x"0029" when 16#9#,
			  "00" & x"C000" when 16#A#,
			  "00" & x"1001" when 16#B#,
			  "11" & x"FFFF" when others;
end;
