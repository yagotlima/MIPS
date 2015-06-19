LIBRARY	ieee;
USE		ieee.std_logic_1164.all;

entity MIPS is
	port(
		clk, reset	: in  STD_LOGIC
	);
end entity;

architecture mips_arch of MIPS is

component single_port_ram
	generic 
	(
		DATA_WIDTH : natural;
		ADDR_WIDTH : natural
	);
	port (
		clk	: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic;
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
end component;

begin
	-- TODO --
end;
