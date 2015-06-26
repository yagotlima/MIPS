library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity system_ram is

	generic (
		ADDR_WIDTH : natural := 6
	);

	port (
		clk	: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector(31 downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector(31 downto 0)
	);

end system_ram;

architecture rtl of system_ram is
	constant MAX_ADDR : natural := 2**ADDR_WIDTH-1;

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector(7 downto 0);
	type memory_t is array(MAX_ADDR downto 0) of word_t;

	function init_ram
		return memory_t is 
		variable tmp : memory_t := (others => (others => '0'));
	begin
		tmp(3)  := x"20";
		tmp(2)  := x"08";
		tmp(1)  := x"00";
		tmp(0)  := x"42";
		
		tmp(7)  := x"08";
		tmp(6)  := x"00";
		tmp(5)  := x"00";
		tmp(4)  := x"08";
		
		tmp(11) := x"20";
		tmp(10) := x"09";
		tmp(9)  := x"00";
		tmp(8)  := x"04";
		
		tmp(15) := x"01";
		tmp(14) := x"09";
		tmp(13) := x"50";
		tmp(12) := x"22";
		
		tmp(19) := x"01";
		tmp(18) := x"48";
		tmp(17) := x"58";
		tmp(16) := x"25";
		
		tmp(23) := x"ac";
		tmp(22) := x"0b";
		tmp(21) := x"00";
		tmp(20) := x"2c";
		
		tmp(27) := x"8d";
		tmp(26) := x"2c";
		tmp(25) := x"00";
		tmp(24) := x"28";
		
		tmp(31) := x"08";
		tmp(30) := x"00";
		tmp(29) := x"00";
		tmp(28) := x"07";
		
		tmp(35) := x"10";
		tmp(34) := x"00";
		tmp(33) := x"ff";
		tmp(32) := x"f9";
		
		for addr_pos in 36 to MAX_ADDR loop 
			-- Initialize each address with the address itself
			tmp(addr_pos) := x"FF";
		end loop;
		return tmp;
	end init_ram;

	-- Declare the RAM signal and specify a default value.	Quartus II
	-- will create a memory initialization file (.mif) based on the 
	-- default value.
	signal ram : memory_t := init_ram;

	-- Register to hold the address 
	signal addr_reg : natural range 0 to MAX_ADDR;

begin

	process(clk)
	begin
	if(rising_edge(clk)) then
		if(we = '1') then
			ram(addr mod MAX_ADDR) <= data(7 downto 0);
			ram((addr + 1) mod MAX_ADDR) <= data(15 downto 8);
			ram((addr + 2) mod MAX_ADDR) <= data(23 downto 16);
			ram((addr + 3) mod MAX_ADDR) <= data(31 downto 24);
		end if;

		-- Register the address for reading
		addr_reg <= addr;
	end if;
	end process;

	q(7 downto 0) <= ram(addr_reg mod MAX_ADDR);
	q(15 downto 8) <= ram((addr_reg + 1) mod MAX_ADDR);
	q(23 downto 16) <= ram((addr_reg + 2) mod MAX_ADDR);
	q(31 downto 24) <= ram((addr_reg + 3) mod MAX_ADDR);

end rtl;
