LIBRARY	ieee;
USE		ieee.std_logic_1164.all;
USE		ieee.numeric_std.all;

entity registers is
	port(
		CLK, RESET						: in  STD_LOGIC;
		REGWRITE							: in  STD_LOGIC;
		RDREGISTER1, RDREGISTER2	: in  STD_LOGIC_VECTOR(4 downto 0);
		WRREGISTER						: in  STD_LOGIC_VECTOR(4 downto 0);
		WRDATA							: in  STD_LOGIC_VECTOR(31 downto 0);
		RDDATA1, RDDATA2				: out STD_LOGIC_VECTOR(31 downto 0)
	);
end entity;

architecture registers_arch of registers is

-- Build a 2-D array type for the RAM
subtype word_t is std_logic_vector(31 downto 0);
type memory_t is array(2**5 -1 downto 0) of word_t;

-- Declare the RAM 
shared variable ram : memory_t;

signal addr1, addr2, addr3	: natural;

begin
	addr1 <= to_integer(unsigned(RDREGISTER1));
	addr2 <= to_integer(unsigned(RDREGISTER2));
	addr3 <= to_integer(unsigned(WRREGISTER));
	
	-- Read A
	process(CLK)
	begin
	if(rising_edge(CLK)) then
		if addr1 = 0 then
			RDDATA1 <= x"00_00_00_00";
		else
			RDDATA1 <= ram(addr1);
		end if;
	end if;
	end process;

	-- Read B 
	process(CLK)
	begin
	if(rising_edge(CLK)) then 
		if addr2 = 0 then
			RDDATA2 <= x"00_00_00_00";
		else
			RDDATA2 <= ram(addr2);
		end if;
	end if;
	end process;
	
	-- Write
	process(CLK)
	begin
	if(rising_edge(CLK) and REGWRITE = '1') then 
		ram(addr3) := WRDATA;
	end if;
	end process;
	
end;
