LIBRARY	ieee;
USE		ieee.std_logic_1164.all;
USE		ieee.numeric_std.all;

entity munit is
	port(
		CLK, RESET								: in  STD_LOGIC;
		PC, ALUOUT, WRITEDATA				: in  STD_LOGIC_VECTOR(31 downto 0);
		IORD, MEMREAD, MEMWRITE, IRWRITE	: in  STD_LOGIC;
		INSTRUCTION, MEMORYDATA				: out STD_LOGIC_VECTOR(31 downto 0)
	);
end entity;

architecture munit_arch of munit is

component single_port_ram is

	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 6
	);

	port 
	(
		clk	: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end component;

component mux4 is
	generic(
		LARGURA	: natural := 1
	);

	port(	
		a, b, c, d	: in  STD_LOGIC_VECTOR(LARGURA - 1 downto 0);
		sel			: in  STD_LOGIC_VECTOR(1 downto 0);
		q				: out STD_LOGIC_VECTOR(LARGURA - 1 downto 0)
	);
end component;

signal addr, memData		: STD_LOGIC_VECTOR(31 downto 0);
signal memout1, memout2	: STD_LOGIC_VECTOR(31 downto 0);
signal we1, we2			: STD_LOGIC;
signal ramAddr				: natural;

begin
	mux1: mux4 generic map(32) port map(PC, ALUOUT, x"FF_FF_FF_FF", x"FF_FF_FF_FF", "0" & IORD, addr);
	
	-- The memory blocks where split in two because of the 32 bits limitation on the software's numeric variables.
	mem1: single_port_ram generic map(32, 16) port map(CLK, ramAddr, WRITEDATA, we1, memout1);
	mem2: single_port_ram generic map(32, 16) port map(CLK, ramAddr, WRITEDATA, we2, memout2);
	
	ramAddr <= to_integer(unsigned(addr(30 downto 0)));
	
	we1 <= MEMWRITE and not(addr(31));
	we2 <= MEMWRITE and addr(31);
	memData <= memout1 when addr(31) = '0' else memout2;
		
	-- Instruction register
	process(RESET, IRWRITE, memData)
	begin
		if (RESET = '0') then
			INSTRUCTION <= x"00_00_00_00";
		elsif (IRWRITE = '1') then
			INSTRUCTION <= memData;
		end if;
	end process;
	
	-- Memory data register
	process(RESET, MEMREAD, memData)
	begin
		if (RESET = '0') then
			MEMORYDATA <= x"00_00_00_00";
		elsif (MEMREAD = '1') then
			MEMORYDATA <= memData;
		end if;
	end process;
	
end;
